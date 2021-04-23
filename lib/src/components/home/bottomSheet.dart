
import 'package:flutter/material.dart';
import 'package:flutter_get/src/page/item/itemPriceChart.dart';
import 'package:flutter_get/src/page/item/itemRegister.dart';
import 'package:get/get.dart';

class MenuBottomSheet extends StatelessWidget {

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('만들기', style: TextStyle(fontSize: 16),),
        IconButton(icon: Icon(Icons.close), onPressed: Get.back)
      ],
    );
  }

  Widget _itemButton({IconData icon, double iconSize, String label, Function onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(0.3)),
              child: Container(child: Icon(icon), width: iconSize, height: iconSize)),
          SizedBox(width: 15,),
          Text(label)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Container(
        padding: const EdgeInsets.only(left: 20),
        height: 200,
        color: Colors.white,
        child: Column(
          children: [
            _header(),
            SizedBox(height: 10,),
            _itemButton(icon: (Icons.add), iconSize: 17, label: '물건 등록하기', onTap: (){Get.back(); Get.to(() => ItemRegisterPage(), transition: Transition.downToUp); }),
            SizedBox(height: 10,),
            _itemButton(icon: (Icons.favorite), iconSize: 17, label: '관심 물건 보기', onTap: (){Get.back(); Get.to(()=> ItemPriceChart());}),
          ],
        ),
      ),
    );
  }
}
