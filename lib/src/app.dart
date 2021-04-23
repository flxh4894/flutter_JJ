import 'package:flutter/material.dart';
import 'package:flutter_get/src/controller/appController.dart';
import 'package:flutter_get/src/controller/chatController.dart';
import 'package:flutter_get/src/controller/homeController.dart';
import 'package:flutter_get/src/page/chat/chatlist.dart';
import 'package:flutter_get/src/page/home.dart';
import 'package:flutter_get/src/page/mypage/mypageMain.dart';
import 'package:flutter_get/styles/style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class App extends GetView<AppController> {

  init() {
    Get.put(HomeController());
    Get.put(ChatController());
  }

  Widget _body() {
    int index = controller.currentIndex.value;
    switch (Menu.values[index]) {
      case Menu.HOME:
        return Home();
      case Menu.COMM:
        return Container();
      case Menu.ADD:
        break;
      case Menu.CHAT:
        return ChatList();
      case Menu.MY:
        return MyPageMainPage();
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
          color: Colors.black.withOpacity(0.5),
        )
      ),
      label: label,
      activeIcon: Padding(
        padding: EdgeInsets.only(bottom: 5),
        child: SvgPicture.asset(
          "assets/svg/${icon}_off.svg",
          width: 20,
          height: 20,
          color: Colors.black,
        )
      )
    );
  }

  Widget _bottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      selectedFontSize: 12,
      items: <BottomNavigationBarItem>[
        _bottomNavigationBarItem("home", "홈"),
        _bottomNavigationBarItem("notes", "동네생활"),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 10),
            child: SvgPicture.asset(
              "assets/svg/plus.svg",
              width: 35,
              height: 35,
            ),
          ),
          label: ""
        ),
        _bottomNavigationBarItem("chat", "채팅"),
        _bottomNavigationBarItem("user", "나의당근"),
      ],
      onTap: controller.changePageIndex,
      currentIndex: controller.currentIndex.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Obx(
          () => Scaffold(
        body: _body(),
        bottomNavigationBar: _bottomNavigation(),
      ),
    );
  }
}
