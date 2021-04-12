
import 'package:flutter/material.dart';
import 'package:flutter_get/src/controller/authController.dart';
import 'package:flutter_get/src/page/auth/login.dart';
import 'package:get/get.dart';

import '../app.dart';

class Splash extends StatelessWidget {

  final AuthController authController = Get.put(AuthController());

  void callTest () async {
    await Future.delayed(Duration(seconds: 4));
    Get.to(() => App());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          if(authController.isLogin.value) {
            callTest();
            return Container(
              child: Center(
                child: Text('로딩중...'),
              ),
            );
          } else {
            return Login();
          }
        }
      ),
    );
  }
}
