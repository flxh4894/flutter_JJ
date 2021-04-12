import 'package:get/get.dart';

enum Menu { HOME, COMM , LOCATION, CHAT, MY }

class AppController extends GetxService {
  static AppController get to => Get.find();
  RxInt currentIndex = 0.obs;

  void changePageIndex(int index) {
    currentIndex(index);
  }
}