import 'dart:math';

import 'package:flutter/material.dart';

class OtherSellItems extends StatelessWidget {

  final List<Map<String, dynamic>> gridItems = [
    {'id': 1, 'title':'Hello World!'},
    {'id': 2, 'title':'Hello apple!'},
    {'id': 3, 'title':'banana'},
    {'id': 4, 'title':'lineage'},
    {'id': 5, 'title':'홀리쉣더뻑더'},
    {'id': 6, 'title':'메2플스토리'},

  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('다른 판매상품 보기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            Text('모두보기', style: TextStyle(fontSize: 12, color: Colors.grey),),
          ],
        ),
        _gridView(context),
      ],
    );
  }

  Widget _gridView(context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height) / 2;
    final double itemWidth = size.width / 2;

    return GridView.count(
      padding: EdgeInsets.only(top: 16),
      primary: false,
      shrinkWrap : true,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      childAspectRatio: 0.78,
      children: gridItems.map((element) => _gridBox(element)).toList()
    );
  }

  Widget _gridBox(Map<String, dynamic> itemInfo){
      return GestureDetector(
        onTap: (){print(itemInfo['id']);},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                child: Image.asset("assets/images/ara-3.jpg", fit:BoxFit.cover,),
                color: Colors.teal[(Random().nextInt(4)+1) *100],
              ),
            ),
            SizedBox(height: 5,),
            Text(itemInfo['title'].toString(), style: TextStyle(fontSize: 14)),
            Text('32,000원', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
          ]
        ),
      );
  }
}
