import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class HomeController extends GetxController{
  static HomeController get to => Get.find();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final Logger logger = Logger(
    printer: PrettyPrinter(),
  );

  ScrollController scrollController = ScrollController();

  RxInt testNumb = 100.obs;
  RxInt pageIndex = 0.obs;
  RxString location = "이도원동".obs;
  RxInt propensity = (32767).obs;
  RxInt listCount = 10.obs;
  RxString name = 'apple'.obs;
  RxBool initHome = false.obs;

  var locationList = {
    "a":"이도원동",
  "b":"우주미남동",
  "c":"슈퍼섹시동",
  }.obs;
  RxList datas = [].obs;

  @override
  void onInit() {
    _event();
    initItemList();
    super.onInit();
  }

  void _event() {
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        await new Future.delayed(const Duration(milliseconds: 500));
        setListCount();
      }
    });
  }

  void makeItem () async {
    CollectionReference itemRef = _fireStore.collection('sell_list');
    final data = {
      'category' : 2,
      'date': DateTime.now(),
      'deal_type': 3,
      'deal_method': 3,
      'images': ['ara-4.jpg', 'ora-2.jpg'],
      'itemInfo': 15,
      'price': 560000,
      'sell_user': 'flxh4894@naver.com',
      'title': '내가파는 아이템'
    };
    itemRef.add(data);
  }

  void initItemList() async {
    var itemList = await _fireStore.collection('sell_list').orderBy('date', descending: true).limit(10).get();
    List<Map<String, dynamic>> list = itemList.docs.map((e) => {
        "cid": e.id.toString(),
        "image": e['images'][0],
        "title": e['title'],
        "location": "서울특별시 공덕동",
        "price": e['price'].toString(),
        'sellUser': e['sell_user'],
        "likes": "2"
    }).toList();

    datas(list);
    initHome(true);
  }

  void refreshData() {
    initItemList();
  }

  void setListCount() async {
    listCount++;
    datas.add({
      "cid": "11",
      "image": "assets/images/ara-3.jpg",
      "title": "도짱이 추가함!!!",
      "location": "제주 제주시 아라동",
      "price": "130000",
      "likes": "3"
    });
  }

  void setPropensity(int propensity){
    this.propensity(propensity);
  }

  void setLocation(String location) {
    this.location(location);
  }

  void changePageIndex(int index){
    pageIndex(index);
  }
}
