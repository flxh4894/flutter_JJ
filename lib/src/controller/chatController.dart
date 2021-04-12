import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_get/src/repository/chatRepository.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChatController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final ChatRepository _chatRepository = ChatRepository();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxList<Map<String, dynamic>> chatList = <Map<String, dynamic>>[].obs;
  RxMap<String, dynamic> chatIndex = <String, dynamic>{}.obs;
  RxMap<String, dynamic> tes = <String, dynamic>{}.obs;
  int myIndex = 100;
  bool flag = true;

  @override
  void onInit() {
    print('채팅 컨트롤러 초기화');
    _getChatList();
    _addScrollEvent();
    super.onInit();
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

  // 채팅 리스트 불러오기
  void _getChatList() async {
    var url =
    Uri.https('jsonplaceholder.typicode.com', '/photos', {'_limit': '10'});
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      chatList.addAll(parsed);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  // 채팅 내용 더 불러오기
  Future readMoreChatHistory(String roomName) async {
    print('${tes[roomName][0]['chatid']} 보다 작은 채팅ID를 20개씩 가지고 올거에요.');
    // 1. 로컬에 저장된 데이터 중 맨 처음 채팅 ID를 가지고 온다.
    // 2. 채팅아이디를 가지고 그거보다 더 작은 채팅아이디를 20개 단위로 불러온다.
    // 3. 불러온 채팅 데이터를 로컬스토리지에 맨 앞쪽으로 저장한다.
  }

  // 패치 데이터 (채팅방 진입시 1번)
  void fetchMessage(String roomName) async{
    var data2 = await firestore.collection('chat').doc(roomName).collection('message').get();
    List<Map<String, dynamic>> ok = data2.docs.map((element) => element.data() ).toList();
    tes[roomName] = ok;
  }


  // 보낼때
  void onEmitMessage(String roomName, Map<String, dynamic> input) async {
    // 1. 서버에 보낸다. (소켓)

    final index = DateTime.now().microsecondsSinceEpoch.toString();
    DocumentReference messageRef = firestore.collection('chat').doc(roomName).collection('message').doc(index);
    DocumentReference userRef = firestore.collection('users').doc(input['sendUser']);
    messageRef.set(input)
        .then((value) => {
          userRef.set({
            'read': index,
            'lastIndex': index
          }).then((value) => print("추가 성공"))
    });

    await Future.delayed(Duration(microseconds: 200), () => print('서버에 메세지 전달함.'));
  }

  // 받을때
  void onMessage(String roomName, Map<String, dynamic> input) async {
    // 1. 메세지가 서버에서 넘어온다 (Socket.on)

    // 보낸사람, 메세지, 인덱스 ( 방에 참여한 상태라면 마지막 인덱스 업데이트)
    await Future.delayed(Duration(microseconds: 200), () => print('서버에서 메세지 도착.'));
    // 2. 로컬스토리지에 저장한다. (메세지)
    // 3.
    _chatRepository.setMessage(roomName, input, myIndex, 200);
    var list = tes[roomName];
    list.add(input);
    tes[roomName] = list;
  }
}

