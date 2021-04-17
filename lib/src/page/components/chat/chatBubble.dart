
import 'package:flutter/material.dart';
import 'package:flutter_get/src/page/mypage/otherUserProfile.dart';
import 'package:get/get.dart';

enum SendUser { ME, YOU }

class ChatBubble extends StatelessWidget {

  final SendUser sendUser;
  final String userId;
  final String text;
  final bool read;
  ChatBubble({this.sendUser, this.text, this.userId, this.read});

  Widget _myBubble(double width) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              read ? Text('') : Text('1',style: TextStyle(color: Colors.blue),),
              Text('오후 10:18', style: TextStyle(fontSize: 14),),
            ]
        ),
        Container(
          constraints: BoxConstraints(maxWidth: width * 0.65),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.blue[200]
          ),
          margin: EdgeInsets.only(left: 5),
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(text, style: TextStyle(fontSize: 16),),
        ),
      ]
    );
  }

  Widget _othersBubble(double width) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: GestureDetector(
              onTap: ()=> Get.to(() => OtherUserProfile(), transition: Transition.rightToLeftWithFade, arguments: userId),
              child: Image.asset("assets/images/ara-5.jpg",width: 50, height: 50,)
            )
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(width: 10,),
            Container(
              constraints: BoxConstraints(maxWidth: width * 0.55),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade200,
              ),
              margin: EdgeInsets.only(right: 5),
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Text(text, style: TextStyle(fontSize: 16),),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  read ? Text('') : Text('1',style: TextStyle(color: Colors.blue),),
                  Text('오후 10:18', style: TextStyle(fontSize: 14),),
                ]
            ),
          ]
        ),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: sendUser == SendUser.ME ? MainAxisAlignment.end : MainAxisAlignment.start ,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  sendUser == SendUser.ME ? _myBubble(width) : _othersBubble(width) ,
                ]
              )
            ]
          ),
        )
      ],
    );
  }
}
