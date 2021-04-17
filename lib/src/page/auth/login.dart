import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_get/helper/login_background.dart';
import 'package:flutter_get/src/app.dart';
import 'package:flutter_get/src/controller/authController.dart';
import 'package:flutter_get/src/page/auth/register.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            CustomPaint(
              size: size,
              painter: LoginBackground(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.05,
                ),
                Expanded(child: _logoImage),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Stack(
                  children: <Widget>[
                    _inputForm(size),
                    _loginButton(size, context),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                GestureDetector(
                    onTap: () => Get.to(()=> Register(), transition: Transition.rightToLeft),
                    child: Text("회원가입 하러 가기")),
                SizedBox( height: size.height * 0.10,)
              ],
            )
          ],
        ));
  }

  // 로그인 진행
  void _login(BuildContext context) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text
      );

      if(userCredential != null) {
        _authController.updateProfile();
        Get.offAll(() => App());
      }
    } on FirebaseAuthException catch (e) {
      String errMsg;
      if (e.code == 'user-not-found') {
        errMsg="이메일을 확인할 수 없습니다.";
      } else if (e.code == 'wrong-password') {
        errMsg="비밀번호를 확인할 수 없습니다.";
      }
      final snackBar = SnackBar(
        content: Text(errMsg),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget get _logoImage {
    return Padding(
      padding: EdgeInsets.only(top: 40, left: 24, right: 24),
      child: FittedBox(
        fit: BoxFit.contain,
        child: CircleAvatar(
            backgroundImage: NetworkImage("https://picsum.photos/200")
        ),
      ),
    );
  }

  Widget _loginButton(Size size, BuildContext context) {
    return Positioned(
      left: size.width * 0.20,
      right: size.width * 0.20,
      bottom: 0,
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          child: Text(
            "로그인",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            _authController.login(_emailController.text, _passwordController.text);
          },
          style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25))),
        ),

      ),
    );
  }

  Widget _inputForm(Size size) {

    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 30),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.account_circle, color: Colors.grey,),
                      hintText: '이메일을 입력해 주세요.',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10),
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "이메일이 입력되지 않았습니다.";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key, color: Colors.grey,),
                      hintText: '비밀번호를 입력해 주세요.',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10),
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "올바른 형태의 비밀번호를 입력해 주세요.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>ResetPassword()));
                    },
                    child: Text("비밀번호를 잊으셨나요?"),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
