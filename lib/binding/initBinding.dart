
import 'package:flutter_get/src/controller/appController.dart';
import 'package:flutter_get/src/controller/authController.dart';
import 'package:flutter_get/src/controller/chatController.dart';
import 'package:flutter_get/src/controller/homeController.dart';
import 'package:get/get.dart';

class InitBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AppController());
    Get.put(AuthController());
  }
}