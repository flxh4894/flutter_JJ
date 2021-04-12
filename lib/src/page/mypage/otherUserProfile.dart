
import 'package:flutter/material.dart';
import 'package:flutter_get/src/page/components/propensityLevel.dart';
import 'package:flutter_get/styles/style.dart';
import 'package:get/get.dart';

class OtherUserProfile extends StatelessWidget {

  final String userId = Get.arguments as String;

  Widget _appbar() {
    return AppBar(
      title: Text('$userId 프로필'),
    );
  }

  Widget _body(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          _userInfo(height, width),
        ],
      )
    );
  }

  Widget _userInfo(double height, double width){
    return Column(
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: FadeInImage.assetNetwork(placeholder: "assets/images/common/loading.gif", image: "https://i.pinimg.com/originals/6c/15/b0/6c15b0166c044974d4e4e9234f881f92.jpg" ,width: 70, height: 70, fit: BoxFit.cover,)
            ),
            SizedBox(width: 16,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('우주미남도원',style: Styles.fontSize16withBold,),
                Text('서울특별시 북가좌동'),
              ],
            )
          ],
        ),
        PropensityLevel(width: width, height: 10,),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: _body(context),
    );
  }
}
