import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChatController extends GetxService {
  final ScrollController scrollController = ScrollController();

  RxList<Map<String, dynamic>> chatList = <Map<String, dynamic>>[].obs;
  RxMap<String, dynamic> tes = <String, dynamic>{
    'appleRoom' : {
      'lastReadChat': 120,
      'lastReceiveChat': 124,
      'list' : [
        {'chatid': 120, 'sendUser':'dowon', 'text': '내가 만들어본 채팅 내용이야', 'date': '2021-04-11 23:10'},
        {'chatid': 120, 'sendUser':'dowon', 'text': '내가 만들어본 채팅 내용이야', 'date': '2021-04-11 23:10'},
        {'chatid': 121, 'sendUser':'supersexy', 'text': '다행이다 빈센조가 끝난게 아니라서 ㅎ.ㅎ', 'date': '2021-04-11 23:10'},
      ]
    },
    'samsungRoom' : {
      'lastReadChat': 120,
      'lastReceiveChat': 124,
      'list' : [
        {'chatid': 120, 'sendUser':'dowon', 'text': '안녕하세요 이런식으로 채팅방이 구성이 됩니다.', 'date': '2021-04-11 23:10'},
        {'chatid': 120, 'sendUser':'supersexy', 'text': '아, 네 안녕하세요 반갑습니다.', 'date': '2021-04-11 23:10'},
        {'chatid': 121, 'sendUser':'dowon', 'text': '호우 홀리 쉣~~~', 'date': '2021-04-11 23:10'},
      ]
    }
  }.obs;


  RxMap<String, dynamic> chatting = <String, dynamic>{
      'supersexy': [
        {'chatid': 120, 'sendUser':'dowon', 'text': '내가 만들어본 채팅 내용이야 ㅅㅂ', 'date': '2021-04-11 23:10'},
        {'chatid': 120, 'sendUser':'dowon', 'text': '내가 만들어본 채팅 내용이야', 'date': '2021-04-11 23:10'},
        {'chatid': 121, 'sendUser':'supersexy', 'text': '다행이다 빈센조가 끝난게 아니라서 ㅎ.ㅎ', 'date': '2021-04-11 23:10'},
      ]
    }.obs;

  @override
  void onInit() {
    print('채팅 컨트롤러 초기화');
    _getChatList();
    _addScrollEvent();
    super.onInit();
  }

  void _addScrollEvent() {
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        _getChatList();
      }
    });
  }

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

  void refreshChatList() {

  }

  Future readMoreChatHistory() async {
    Future.delayed(Duration(seconds: 1), () => print('서버에서 불러왔어요'));
    List<Map<String, dynamic>> addData = [
      {'chatid': 120, 'sendUser':'dowon', 'text': '추가된 데이터 123', 'date': '2021-04-11 23:10'},
      {'chatid': 120, 'sendUser':'dowon', 'text': '메이플 스토리', 'date': '2021-04-11 23:10'},
      {'chatid': 120, 'sendUser':'dowon', 'text': '내가바로 리니지다', 'date': '2021-04-11 23:10'},
    ];

    addData.addAll(chatting['supersexy']);

    chatting['supersexy'] = addData;
  }

  Future addChatting(Map<String, dynamic> input) async {
    List<Map<String, dynamic>> addData = chatting['supersexy'];
    addData.add(input);
    chatting['supersexy'] = addData;
  }

  void newAddChatting(String roomName, Map<String, dynamic> input) {
    Map<String, dynamic> newArray = tes[roomName];
    newArray['list'].add(input);

    tes[roomName] = newArray;
  }

}