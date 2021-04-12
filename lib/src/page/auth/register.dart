import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_get/src/page/auth/login.dart';
import 'package:flutter_get/styles/style.dart';
import 'package:get/get.dart';

class Register extends StatelessWidget {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register(BuildContext context) async {
    bool snackFlag= false;
    String errMsg;
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text
      );

      if(userCredential != null) {
        _showMyDialog(context);
      }
    } on FirebaseAuthException catch (e) {
      snackFlag = true;
      if (e.code == 'weak-password') {
        errMsg="비밀번호가 너무 취약합니다.";
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        errMsg="이미 사용중인 이메일입니다.";
        print('The account already exists for that email.');
      }
    } catch (e) {
      snackFlag = true;
      errMsg=e;
      print(e);
    }

    if(snackFlag){
      final snackBar = SnackBar(
        content: Text(errMsg),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('축하합니다!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('회원가입이 완료 되었습니다.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Get.offAll(()=>Login());
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Container(
        padding: Styles.paddingSide,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                icon: Icon(Icons.account_circle, color: Colors.grey,),
                hintText: '이메일을 입력해 주세요.',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 10),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(Icons.vpn_key, color: Colors.grey,),
                hintText: '비밀번호를 입력해 주세요.',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 10),
              ),
            ),
            SizedBox(height: 8,),
            ElevatedButton(onPressed: () => _register(context), child: Text('회원가입')),
          ],
        ),
      ),
    );
  }
}
