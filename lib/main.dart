import 'package:flutter/material.dart';
import 'package:flutter_get/binding/initBinding.dart';
import 'package:get/get.dart';
import 'package:flutter_get/src/app.dart';

void main() {
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
      home: App(),
    );
  }
  
}