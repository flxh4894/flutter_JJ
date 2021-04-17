
import 'package:flutter/material.dart';
import 'package:flutter_get/src/controller/authController.dart';
import 'package:flutter_get/src/controller/chatController.dart';
import 'package:flutter_get/src/controller/homeController.dart';
import 'package:flutter_get/src/controller/itemController.dart';
import 'package:flutter_get/src/page/auth/login.dart';
import 'package:get/get.dart';

import '../app.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: CircularProgressIndicator(),
        )
      )
    );
  }
}
