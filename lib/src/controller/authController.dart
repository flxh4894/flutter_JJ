
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  RxBool isLogin = false.obs;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() async {
    _firebaseAuth.signOut();
    User user = _firebaseAuth.currentUser;
    print(user);
    if(user != null){
      isLogin(true);
    }
  }

  void updateProfile () async {
    User user = _firebaseAuth.currentUser;
    final profileData = await _firestore.collection('users').where('id', isEqualTo: user.uid).get();
    final List<DocumentSnapshot> docouments = profileData.docs;


    String token = await user.getIdToken(true);
    print(token);

    if(docouments.length == 0) {
      final data = {'nickname': 'dowon', 'photo': 'https://i.pinimg.com/originals/6c/15/b0/6c15b0166c044974d4e4e9234f881f92.jpg', 'id':user.email};
      _firestore.collection('users').doc(user.uid).set(data);
    }
  }
}