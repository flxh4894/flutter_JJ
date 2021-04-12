import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HomeController extends GetxController{
  static HomeController get to => Get.find();
  ScrollController scrollController = ScrollController();

  RxInt testNumb = 100.obs;
  RxInt pageIndex = 0.obs;
  RxString location = "이도원동".obs;
  RxInt propensity = (32767).obs;
  RxInt listCount = 10.obs;
  RxString name = 'apple'.obs;

  var locationList = {
    "a":"이도원동",
  "b":"우주미남동",
  "c":"슈퍼섹시동",
  }.obs;

  RxList datas = [
    {
      "cid": "1",
      "image": "assets/images/ara-1.jpg",
      "title": "네메시스 축구화275",
      "location": "제주 제주시 아라동",
      "price": "30000",
      "likes": "2"
    },
    {
      "cid": "2",
      "image": "assets/images/ara-2.jpg",
      "title": "LA갈비 5kg팔아요~",
      "location": "제주 제주시 아라동",
      "price": "100000",
      "likes": "5"
    },
    {
      "cid": "3",
      "image": "assets/images/ara-3.jpg",
      "title": "치약팝니다",
      "location": "제주 제주시 아라동",
      "price": "5000",
      "likes": "0"
    },
    {
      "cid": "4",
      "image": "assets/images/ara-4.jpg",
      "title": "[풀박스]맥북프로16인치 터치바 스페이스그레이",
      "location": "제주 제주시 아라동",
      "price": "2500000",
      "likes": "6"
    },
    {
      "cid": "5",
      "image": "assets/images/ara-5.jpg",
      "title": "디월트존기임팩",
      "location": "제주 제주시 아라동",
      "price": "150000",
      "likes": "2"
    },
    {
      "cid": "6",
      "image": "assets/images/ara-6.jpg",
      "title": "갤럭시s10",
      "location": "제주 제주시 아라동",
      "price": "180000",
      "likes": "2"
    },
    {
      "cid": "7",
      "image": "assets/images/ara-7.jpg",
      "title": "선반",
      "location": "제주 제주시 아라동",
      "price": "15000",
      "likes": "2"
    },
    {
      "cid": "8",
      "image": "assets/images/ara-8.jpg",
      "title": "냉장 쇼케이스",
      "location": "제주 제주시 아라동",
      "price": "80000",
      "likes": "3"
    },
    {
      "cid": "9",
      "image": "assets/images/ara-9.jpg",
      "title": "대우 미니냉장고",
      "location": "제주 제주시 아라동",
      "price": "30000",
      "likes": "3"
    },
    {
      "cid": "10",
      "image": "assets/images/ara-10.jpg",
      "title": "멜킨스 풀업 턱걸이 판매합니다.",
      "location": "제주 제주시 아라동",
      "price": "50000",
      "likes": "7"
    },
  ].obs;

  @override
  void onInit() {
    _event();
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

  void refreshData() {
    datas.clear();
    List<Map<String, String>> newList = [{
      "cid": "11",
      "image": "assets/images/ara-3.jpg",
      "title": "도짱이 추가함!!!",
      "location": "제주 제주시 아라동",
      "price": "130000",
      "likes": "3"
    },
      {
        "cid": "12",
        "image": "assets/images/ara-3.jpg",
        "title": "??갑자기 된다고?",
        "location": "제주 제주시 아라동",
        "price": "130000",
        "likes": "3"
      }];
    datas.addAll(newList);
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
