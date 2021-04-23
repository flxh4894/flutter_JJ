
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_get/src/components/mypage/bottomSheet.dart';
import 'package:flutter_get/src/repository/authRepository.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

enum MyPageTab { Sale, Reserve, Done }

class MyPageController extends GetxController {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final AuthRepository authRepository = AuthRepository();
  final Logger logger = Logger(
    printer: PrettyPrinter(),
  );  
  RxInt tabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    getItemDealList();
  }


  RxList<MyPageItem> lists = <MyPageItem>[].obs;
  // 판매중 리스트
  void getItemDealList () async {
    Get.dialog(Center(child: CircularProgressIndicator()),barrierDismissible: true);
    lists.clear();

    var userId = await authRepository.getUserId();
    var list = await _fireStore.collection('sell_list').where('sell_user', isEqualTo: userId).where('deal_type', isEqualTo: 2).get();
    list.docs.forEach((element) {
      var data = element.data();
      lists.add(MyPageItem(id: element.id, title: data['title'], price: data['price'], thumbnail: data['images'][0]));
    });

    Get.back();
  }

  // 예약중 리스트
  void getItemReserveList () async {
    Get.dialog(Center(child: CircularProgressIndicator()),barrierDismissible: true);
    lists.clear();

    var userId = await authRepository.getUserId();
    var list = await _fireStore.collection('sell_list').where('sell_user', isEqualTo: userId).where('deal_type', isEqualTo: 3).get();
    list.docs.forEach((element) {
      var data = element.data();
      lists.add(MyPageItem(id: element.id, title: data['title'], price: data['price'], thumbnail: data['images'][0]));
    });

    Get.back();
  }

  // 완료된 리스트
  void getItemDoneList () async {
    Get.dialog(Center(child: CircularProgressIndicator()),barrierDismissible: true);
    lists.clear();

    // var userId = await authRepository.getUserId();
    // var list = await _fireStore.collection('sell_list').where('sell_user', isEqualTo: userId).where('deal_type', isEqualTo: 3).get();
    // list.docs.forEach((element) {
    //   var data = element.data();
    //   lists.add(MyPageItem(id: element.id, title: data['title'], price: data['price'], thumbnail: data['images'][0]));
    // });

    Get.back();
  }

  // 탭 이동시 데이터베이스 조회
  void setTabInfo(int index){
    tabIndex(index);

    switch (MyPageTab.values[index]) {
      case MyPageTab.Sale:
        getItemDealList();
        break;
      case MyPageTab.Reserve:
        getItemReserveList();
        break;
      case MyPageTab.Done:
        getItemDoneList();
        break;
    }
  }
  void showBottomSheet() {
    Get.bottomSheet(ItemBottomSheet());
  }
}

class MyPageItem {
  final String id;
  final String title;
  final String thumbnail;
  final int price;
  final Timestamp date;

  MyPageItem({this.id,  this.price, this.date, this.thumbnail, this.title});
}
