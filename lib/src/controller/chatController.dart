import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_get/src/page/chat/chatting.dart';
import 'package:flutter_get/src/repository/authRepository.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ChatController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final AuthRepository _authRepository = AuthRepository();
  final Logger logger = Logger(printer: PrettyPrinter());
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool flag = true;
  String userId;
  RxMap<String, dynamic> chatIndex = <String, dynamic>{}.obs;
  RxList<Chatting> chatList = <Chatting>[].obs;

  @override
  void onInit() {
    _addScrollEvent();
    init();
    super.onInit();
  }


  @override
  void onReady() {
    getChatRoomList();
  }

  @override
  void dispose() {
    roomSubscription.cancel();
    super.dispose();
  }

  init() async {
    userId = await _authRepository.getUserId();
    logger.i('유저아이디 : $userId');
    updateChatRoom();
    // _getChatList();
  }

  // 스크롤 이벤트
  void _addScrollEvent() {
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // _getChatList();
      }
    });
  }

  void createChatRoom(String peerId, String itemId) async {
    final String id = await _authRepository.getUserId();
    final roomId = id.hashCode > peerId.hashCode
        ? '${id.hashCode}-${peerId.hashCode}-${itemId.hashCode}'
        : '${peerId.hashCode}-${id.hashCode}-${itemId.hashCode}';

    var isChatRoomExist = await firestore.collection('chat').doc(roomId).get();
    if (!isChatRoomExist.exists) {
      DocumentReference chatRoomRef = firestore.collection('chat').doc(roomId);
      chatRoomRef.set({
        'createAt': DateTime.now(),
        'participant': [id, peerId],
        'itemNo': itemId,
        'lastIndex': 0,
        'lastMsg': '',
        'updateAt': DateTime.now()
      });

      DocumentReference participantMe =
          firestore.collection('participant').doc('${roomId}_${id.hashCode}');
      DocumentReference participantPeer = firestore
          .collection('participant')
          .doc('${roomId}_${peerId.hashCode}');
      participantMe.set({'userId': id, 'roomId': roomId, 'lastIndex': 0});
      participantPeer.set({'userId': peerId, 'roomId': roomId, 'lastIndex': 0});
    }
    Get.to(() => ChattingRoom(),
        arguments: roomId, transition: Transition.rightToLeft);
  }

  // New 채팅 목록 불러오기 (초기 1번)
  var streamFlag = false;
  void getChatRoomList() async {
    logger.i('1. 채팅방 불러오기');
    chatList.clear();

    firestore
        .collection('chat')
        .where('participant', arrayContains: userId)
        .orderBy('updateAt', descending: true)
        .get()
        .then((value) => {
          value.docs.forEach((element) {
            if(element.data()['lastIndex'] != 0){
              chatList.add(Chatting(
                roomId: element.id,
                itemNo: element.data()['itemNo'],
                lastMsg: element.data()['lastMsg'],
                lastIndex: element.data()['lastIndex'].toString(),
                participant: element.data()['participant'],
                nickname: '',
                unreadCount: 0,
              ));
            }
          })
        })
        .then((value) => chatList.asMap().forEach((index, e) async {
            List peerId = e.participant;
            var nickname = await firestore
                .collection('users')
                .where('id', isEqualTo: peerId.firstWhere((element) => element != userId))
                .get();
            chatList[index].nickname = nickname.docs[0].data()['nickname'];
            var roomId = chatList[index].roomId;
            firestore.collection('participant').doc('${roomId}_${userId.hashCode}').get().then((value) => {
              chatList[index].unreadCount = int.parse(chatList[index].lastIndex) - value.data()['lastIndex']
            });
          })
        );
  }

  StreamSubscription roomSubscription;
  void updateChatRoom () {
    logger.i('2. 채팅방 리스너 등록');
    var room = firestore.collection('chat').where('participant', arrayContains: userId).orderBy('updateAt', descending: true).limit(1).snapshots();
    roomSubscription = room.listen((event) {

        if(event.docs.length == 0){
          return;
        }

        if(event.docs[0].data()['lastIndex'] != 0) {
          var data = event.docs[0].data();
          var roomInfo = Chatting(roomId: event.docs[0].id, itemNo: data['itemNo'], lastMsg: data['lastMsg'], lastIndex: data['lastIndex'].toString(), participant: data['participant']);

          // 이미 존재하는 방인지 파악
          var index = chatList.indexWhere((element) => element.roomId == event.docs[0].id);

          // 방이 있다면
          if( index != -1 ){
            if(chatList[index].unreadCount != null) {
              var nickname = chatList[index].nickname;
              var unread = chatList[index].unreadCount;

              roomInfo.nickname = nickname;
              if(event.docs[0].data()['lastSendUser'] == userId){
                roomInfo.unreadCount = 0;
              } else {
                roomInfo.unreadCount = unread + 1;
              }
              chatList.removeAt(index);
              chatList.insert(0, roomInfo);
            }
          } else { // 방이 신규로 생성됐다면
            List peerId = event.docs[0].data()['participant'];
            firestore
                .collection('users')
                .where('id',
                isEqualTo: peerId.firstWhere((element) => element != userId))
                .get()
                .then((value) {
              var nickname = value.docs[0].data()['nickname'];
              roomInfo.nickname = nickname;

              if(event.docs[0].data()['lastSendUser'] == userId){
                roomInfo.unreadCount = 0;
              } else {
                roomInfo.unreadCount = 1;
              }
              chatList.insert(0, roomInfo);
            });
          }
        }
    });
  }

  // 채팅 리스트 불러오기
  RxList<String> userInfo = <String>[].obs;
  void _getChatList() async {
    logger.i('채팅방 불러오기');
    Stream<QuerySnapshot> chat = firestore
        .collection('chat')
        .where('participant', arrayContains: userId)
        .orderBy('updateAt', descending: true)
        .snapshots();

    Stream<List<Chatting>> list = chat.map((event) {
      return event.docs.map((e) {
        List peerId = e.data()['participant'];
        firestore
            .collection('users')
            .where('id',
                isEqualTo: peerId.firstWhere((element) => element != userId))
            .get()
            .then((value) => userInfo.add(value.docs[0].data()['nickname']));

        return Chatting(
            roomId: e.id,
            itemNo: e.data()['itemNo'],
            lastMsg: e.data()['lastMsg'],
            lastIndex: e.data()['lastIndex'].toString());
      }).toList();
    });

    chatList.bindStream(list);
  }

  void setUnreadZero(int index) {
    final data = chatList[index];
    chatList[index] = Chatting(roomId: data.roomId, lastIndex: data.lastIndex, lastMsg: data.lastMsg, itemNo: data.itemNo, participant: data.participant, nickname: data.nickname, unreadCount: 0);
  }

  // 채팅 내용 더 불러오기
  Future readMoreChatHistory(String roomName) async {
    // print('${tes[roomName][0]['chatid']} 보다 작은 채팅ID를 20개씩 가지고 올거에요.');
  }

  // 메세지 전송
  void onEmitMessage(String roomName, Map<String, dynamic> input) async {
    logger.d('메세지 발송');
    // 테스트라인 시작 (아이디를 정수로 변환)
    var lastIndexRef = await firestore
        .collection('chat')
        .doc(roomName)
        .collection('message')
        .orderBy('id')
        .limitToLast(1)
        .get();
    int lastIndex = lastIndexRef.docs.length == 0
        ? 1
        : lastIndexRef.docs[0].data()['id'] + 1;
    logger.d('보낼때 메세지 ID : $lastIndex');

    // 1. 서버에 보낸다. (소켓)
    final index = DateTime.now().microsecondsSinceEpoch.toString();
    DocumentReference messageRef = firestore
        .collection('chat')
        .doc(roomName)
        .collection('message')
        .doc(index);
    messageRef
        .set({}
          ..addAll(input)
          ..addAll({'sendUser': userId, 'read': false, 'id': lastIndex}))
        .then((value) {
      DocumentReference ref = firestore.collection('chat').doc(roomName);
      ref.update({
        'lastIndex': lastIndex,
        'lastMsg': input['text'],
        'lastSendUser': userId,
        'updateAt': DateTime.now()
      });
    });
  }
}

class Chatting {
  final String roomId;
  final String lastMsg;
  final String lastIndex;
  final String itemNo;
  final List participant;
  String nickname;
  int unreadCount;

  Chatting(
      {this.roomId,
      this.lastIndex,
      this.lastMsg,
      this.itemNo,
      this.participant,
      this.nickname,
      this.unreadCount});

  factory Chatting.fromMap(Map data) {
    return Chatting(
        roomId: data['roomId'],
        lastMsg: data['lastMsg'],
        lastIndex: data['lastIndex'],
        itemNo: data['itemNo'],
        participant: data['participant'],
        nickname: data['nickname'],
        unreadCount: data['unreadCount']);
  }
}
