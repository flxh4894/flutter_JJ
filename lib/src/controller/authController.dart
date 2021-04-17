
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_get/src/controller/chatController.dart';
import 'package:flutter_get/src/controller/homeController.dart';
import 'package:flutter_get/src/page/auth/login.dart';
import 'package:flutter_get/src/repository/authRepository.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../app.dart';

class AuthController extends GetxController {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final AuthRepository _authRepository = AuthRepository();
  final Logger logger = Logger(
    printer: PrettyPrinter(),
  );
  RxBool isLogin = false.obs;


  @override
  void onReady() {
    isSignedIn();
    super.onReady();
  }

  isSignedIn() async {
    logger.i('로그인 상태 체크 진입');
    User user = _firebaseAuth.currentUser;

    if(user != null){
      _authRepository.setUserUid(user.uid);
      Get.off(() => App());
    } else {
      Get.off(() => Login());
    }
  }

  // 파이어베이스 and 로컬에 사용자 프로필 정보 저장
  void updateProfile () async {
    User user = _firebaseAuth.currentUser;
    final profileData = await _firestore.collection('users').where('id', isEqualTo: user.uid).get();
    final documents = profileData.docs;
    final flag = await _authRepository.getUserUid() == user.uid;

    // 저장된 정보가 디비에 없는 경우 또는 로컬과 아이디가 다를 경우
    if(documents.length == 0 || !flag) {
      logger.d('사용자 같음 : $flag OR 첫 로그인? : ${documents.length}');
      String nickname = 'dowon';
      String photoUrl = 'https://i.pinimg.com/originals/6c/15/b0/6c15b0166c044974d4e4e9234f881f92.jpg';
      String userId = user.email;

      // Update data to Server (첫 로그인)
      if(documents.length == 0){
        final data = {'nickname': nickname, 'photo': photoUrl, 'id': userId};
        _firestore.collection('users').doc(user.uid).set(data);
      }

      // Save data to local
      _authRepository.setUserProfile(nickname, photoUrl, userId);
    }
    Get.offAll(() => App());
  }

  void login(String id, String password) async {
    // 인디케이터
    Get.dialog(Center(child: CircularProgressIndicator()),barrierDismissible: true);

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: id,
          password: password
      );

      if(userCredential != null) {
        logger.d('유저 정보 : $userCredential');
        updateProfile();
      }
    } on FirebaseAuthException catch (e) {
      String errMsg;
      if (e.code == 'user-not-found') {
        errMsg="이메일을 확인할 수 없습니다.";
      } else if (e.code == 'wrong-password') {
        errMsg="비밀번호를 확인할 수 없습니다.";
      }
      logger.d(errMsg);

      Get.back();
      Get.snackbar('오류', errMsg, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.black, colorText: Colors.white);
    }


  }
}