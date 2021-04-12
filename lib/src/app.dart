// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_get/src/controller/appController.dart';
import 'package:flutter_get/src/page/chat/chatlist.dart';
import 'package:flutter_get/src/page/home.dart';
import 'package:flutter_get/styles/style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class App extends GetView<AppController> {

  Widget _body() {
    int index = controller.currentIndex.value;
    switch (Menu.values[index]) {
      case Menu.HOME:
        return Home();
      case Menu.COMM:
        return Container();
      case Menu.LOCATION:
        return Container();
      case Menu.CHAT:
        return ChatList();
      case Menu.MY:
        return Container();
    }

    return Container();
  }

  BottomNavigationBarItem _bottomNavigationBarItem(String icon, String label) {
    return BottomNavigationBarItem(
        icon: Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: SvgPicture.asset(
              "assets/svg/${icon}_off.svg",
              width: 20,
              height: 20,
            )),
        label: label,
        activeIcon: Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: SvgPicture.asset(
              "assets/svg/${icon}_on.svg",
              width: 20,
              height: 20,
              color: Styles.primaryColor,
            )));
  }

  Widget _bottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Styles.primaryColor,
      selectedFontSize: 12,
      items: <BottomNavigationBarItem>[
        _bottomNavigationBarItem("home", "홈"),
        _bottomNavigationBarItem("notes", "동네생활"),
        _bottomNavigationBarItem("location", "내지역"),
        _bottomNavigationBarItem("chat", "채팅"),
        _bottomNavigationBarItem("user", "나의당근"),
      ],
      onTap: controller.changePageIndex,
      currentIndex: controller.currentIndex.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    // var users = FirebaseFirestore.instance.collection('chat').doc('appleRoom').collection('message').orderBy('date').limitToLast(1);
    return Obx(
          () => Scaffold(
        body: _body(),
        bottomNavigationBar: _bottomNavigation(),
      ),
    );
    // return StreamBuilder(
    //   stream: users.snapshots(),
    //   builder: (context, snapshot) {
    //
    //     if(snapshot.hasError){
    //       print('에러다');
    //       return Container(
    //         child: Center(
    //           child: Text('에러'),
    //         ),
    //       );
    //     }
    //
    //     if(snapshot.connectionState == ConnectionState.waiting){
    //       print('기다리는중');
    //       return Container(
    //         child: Center(
    //           child: Text('읽는중'),
    //         ),
    //       );
    //     }
    //     return Obx(
    //           () => Scaffold(
    //         body: _body(),
    //         bottomNavigationBar: _bottomNavigation(),
    //       ),
    //     );
    //   },
    // );
  }
}
