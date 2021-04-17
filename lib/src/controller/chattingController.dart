
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_get/src/controller/chatController.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ChattingController extends GetxController {
  final Logger logger = Logger(printer: PrettyPrinter());
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String roomId;

  ChattingController({this.roomId});

  @override
  void onInit() {
    // 1. 처음 20개 불러오기
    init();
    super.onInit();
  }

  init () async {
    await setChatData();
    readMessage();
    chatParticipants();
  }

  Stream<QuerySnapshot> chat;
  RxList myChatData = [].obs;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onClose() {
    readSubscription.cancel();
    participantSubscription.cancel();
  }


  // 처음 20개 불러오기
  Future<bool> setChatData() async {
    logger.d('1. 처음 20개 불러오기');
    var chatlist = await firestore
        .collection('chat')
        .doc(roomId)
        .collection('message')
        .orderBy('id')
        .limitToLast(20)
        .get();

    if(chatlist.docs.length != 0){
      var list = chatlist.docs.map((e) => e.data()).toList();
      var list2 = list.map((e) => {}..addAll(e)..addAll({'read': true})).toList();

      myChatData.addAll(list2);
      print('setChatData 길이는 ${myChatData.length}');

      final userId = Get.find<ChatController>().userId;
      logger.d('${roomId}_${userId.hashCode}는 있는가');
      await firestore.collection('participant').doc('${roomId}_${userId.hashCode}').update({'lastIndex': list2[list2.length-1]['id']});
    }

    return true;
  }

  // 메세지 읽기
  StreamSubscription readSubscription;
  var lastIndex;
  void readMessage() async {
    logger.d('2. 메세지 읽기 Snapshot 실행');
    // 채팅방의 마지막 채팅 ID 가져옴
    var chatRoomInfo = firestore.collection('chat').doc(roomId).collection('message').orderBy('id').limitToLast(1).snapshots();

    final userId = Get.find<ChatController>().userId;

    readSubscription = chatRoomInfo.listen((event) {
      var batch = firestore.batch();
      if(event.docs.length != 0) {
        // 채팅방 마지막 ID (파이어베이스)
        lastIndex = event.docs[0].data()['id'];

        // 현재 채팅방에 저장된 마지막 채팅 ID
        var myChatLastIndex = myChatData.length == 0 ? -1 : myChatData[myChatData.length-1]['id'];
        if(lastIndex != myChatLastIndex){
          myChatData.add(event.docs[0].data());
          var indexRef = firestore.collection('participant').doc('${roomId}_${userId.hashCode}');
          batch.update(indexRef, {'lastIndex' : lastIndex});
          batch.commit().then((value) => logger.d('$userId 인덱스 $lastIndex로 업데이트 완료'));
        }
      }
    });
  }

  // 누가 채팅방에 참여중인지
  StreamSubscription participantSubscription;
  void chatParticipants() {
    logger.d('3. Participant 등록');
    final userId = Get.find<ChatController>().userId;
    var participantRef = firestore.collection('participant').where('roomId', isEqualTo: roomId).snapshots();

    participantSubscription = participantRef.listen((event) {
      event.docs.forEach((element) {
        if(element.data()['userId'] != userId) {
          var readIndex = element.data()['lastIndex'];
          logger.d('${element.data()['userId']}의 LastIndex가 $readIndex 입니다.');

          print('chatParticipants 길이는 ${myChatData.length}');
          var list = myChatData.map((element) {
            if(element['id'] > readIndex) {
              return {}..addAll(element)..addAll({'read': false});
            } else {
              return {}..addAll(element)..addAll({'read': true});
            }
          }).toList();
          myChatData(list);
        }
      });
    });

  }


  // StreamSubscription subscription;
  // void joinRoom(String roomId)async {
  //   // await firstUpdate(roomId);
  //   final userId = Get.find<ChatController>().userId;
  //   chat = firestore
  //       .collection('chat')
  //       .doc(roomId)
  //       .collection('message')
  //       .orderBy('id')
  //       .limitToLast(1)
  //       .snapshots();
  //
  //
  //   subscription = chat.listen((event) {
  //     var batch = firestore.batch();
  //     // 1. 메세지 받으면 무조건 participant 최신으로 업데이트
  //     var indexRef = firestore.collection('participant').doc('${roomId}_${userId.hashCode}');
  //     batch.update(indexRef, {'lastIndex' : event.docs[0].data()['id']});
  //     batch.commit().then((value) => logger.d('업데이트 완료'));
  //     // if(event.docs.length != 0 && event.docs[event.docs.length-1].data()['read'] == false){
  //     //   // 내가보낸게 아닐경우 마지막 받은게 false 인 경우
  //     //   if(event.docs[event.docs.length-1].data()['sendUser'] != userId) {
  //     //     var readMsgRef = firestore.collection('chat').doc(roomId).collection('message').doc(event.docs[event.docs.length-1].id);
  //     //     batch.update(readMsgRef, {'read': true});
  //     //   }
  //     // }
  //   });
  //
  //
  //   myChatData.bindStream(chat.map((event) => event.docs.asMap().entries.map((e){
  //     return {}..addAll(e.value.data())..addAll({'id': e.value.id});
  //   }).toList()));
  // }

  // 방 진입하자마자 다 읽음 처리
  // Future<bool> firstUpdate (roomId) async {
  //   logger.d('2. 채팅방 진입시 인덱스 최신화');
  //   final userId = Get.find<ChatController>().userId;
  //   // 1. 유저 아이디 + 채팅방 정보 기준으로 조회
  //   var participantInfo =  firestore.collection('participant').doc('${roomId}_${userId.hashCode}');
  //   var lastRead = await participantInfo.get();
  //
  //   // 2. 채탕방 가장 마지막 인덱스를 불러온다.
  //   var lastChatId = await firestore.collection('chat').doc(roomId).collection('message').orderBy('id').limitToLast(1).get();
  //
  //   // 3. 채팅인덱스와 읽은 인덱스 비교
  //   if(lastRead.data()['lastIndex'] != lastChatId.docs[0]['id']) {
  //     logger.d('서로 인덱스가 다릅니다. ${lastRead.data()['lastIndex']} : ${lastChatId.docs[0]['id']}');
  //     participantInfo.update({'lastIndex': lastChatId.docs[0]['id']}).then((value) => logger.d('인덱스 업데이트 완료'));
  //   }
  //   return true;
  // }


}