import 'package:flutter/cupertino.dart';
import 'package:flutter_get/src/components/home/bottomSheet.dart';
import 'package:get/get.dart';
enum Menu { HOME, COMM , ADD, CHAT, MY }

class AppController extends GetxService {
  static AppController get to => Get.find();
  RxInt currentIndex = 0.obs;

  void changePageIndex(int index) {
    if(Menu.values[index] == Menu.ADD) {
      _showBottomSheet();
    } else {
      currentIndex(index);
    }
  }

  void _showBottomSheet() {
    Get.bottomSheet(MenuBottomSheet());
  }
}