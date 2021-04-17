
import 'package:flutter/material.dart';
import 'package:flutter_get/styles/style.dart';

class ItemRegisterPage extends StatelessWidget {


  Widget _appbar() {
    return AppBar(
      title: Text('아이템등록'),
    );
  }

  Widget _body() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text('이미지 선택')
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: _body(),
    );
  }
}
