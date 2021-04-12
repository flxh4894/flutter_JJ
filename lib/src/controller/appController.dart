import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

enum Menu { HOME, COMM , LOCATION, CHAT, MY }

class AppController extends GetxService {
  static AppController get to => Get.find();
  RxInt currentIndex = 0.obs;
  final Future<FirebaseApp> initialization = Firebase.initializeApp();
  @override
  void onInit() {
    super.onInit();
  }


  void changePageIndex(int index) {
    currentIndex(index);
  }
}