import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_get/binding/initBinding.dart';
import 'package:flutter_get/src/page/splash.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage( _firebaseMessagingBackgroundHandler ) ;

  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("백그라운드 FCM 메세지 : ${message.messageId}");
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