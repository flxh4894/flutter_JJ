import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController{
  static NotificationController get to => Get.find();
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void onInit() {
    _initNotification();
    _getToken();
    super.onInit();
  }

  void _initNotification() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    User user = _firebaseAuth.currentUser;
    await _messaging.subscribeToTopic(user.uid);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  void _getToken() async {
    String token = await _messaging.getToken();
    print(token);
  }
}