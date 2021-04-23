import 'package:flutter/material.dart';
import 'package:flutter_get/src/controller/itemController.dart';
import 'package:flutter_get/src/page/item/itemPriceChart.dart';
import 'package:get/get.dart';

class ItemDetailInfo extends StatelessWidget {
  final Map<String, dynamic> data;
  final ItemController controller = Get.find<ItemController>();

  ItemDetailInfo({this.data});

  @override
  Widget build(BuildContext context) {
    ItemInfo itemInfo = ItemInfo.mapping(data);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 5,),

          Text(
            itemInfo.title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "디지털/가전 · 22시간 전",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Row(
             children: [
              Expanded(child: Text(controller.itemNm.value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)) ),
              TextButton(onPressed: () => Get.to(() => ItemPriceChart()), child: Text('현재시세'))
            ]
          ),
          SizedBox(height: 15,),
          Text(
            "동해물과 백두산이 마르고 닳도록 \n 하느님이 보우하사 우리나라만세 \n 무궁화 삼천리 화려강산 \n 대한사람 대한으로 길이 보전하세.\n 대한민국 애국가",
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          SizedBox(height: 15,),
          Text(
            "채팅 3 · 관심 17 · 조회 51",
            style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class ItemInfo {
  final String title;
  final String info;
  final int itemId;

  ItemInfo({this.info, this.title, this.itemId});

  factory ItemInfo.mapping(Map<String, dynamic> data) {
    return ItemInfo(
      title: data['title'] as String,
      info: data['info'] as String,
      itemId: data['itemInfo'] as num
    );
  }
}
