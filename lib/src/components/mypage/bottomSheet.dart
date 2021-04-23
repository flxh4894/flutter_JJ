
import 'package:flutter/material.dart';
import 'package:flutter_get/src/page/item/itemPriceChart.dart';
import 'package:flutter_get/src/page/item/itemRegister.dart';
import 'package:get/get.dart';

class ItemBottomSheet extends StatelessWidget {

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
            SizedBox(height: 10,),
            _itemButton(icon: (Icons.delete), iconSize: 17, label: '삭제하기', onTap: (){Get.back();  }),
            SizedBox(height: 10,),
            _itemButton(icon: (Icons.edit), iconSize: 17, label: '수정하기', onTap: (){Get.back(); }),
            SizedBox(height: 10,),
            _itemButton(icon: (Icons.visibility_off), iconSize: 17, label: '숨기기', onTap: (){Get.back(); }),
          ],
        ),
      ),
    );
  }
}
