import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_get/binding/initBinding.dart';
import 'package:flutter_get/src/controller/authController.dart';
import 'package:flutter_get/src/page/auth/login.dart';
import 'package:flutter_get/src/page/splash.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Joong Jeon Official',
      theme: ThemeData(
          primaryColor: Colors.white,
          textTheme: TextTheme(headline6: TextStyle(color: Colors.black)),
          primarySwatch: Colors.blue
      ),
      initialBinding: InitBinding(),
      home: Splash(),
    );
  }
}