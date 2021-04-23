
import 'package:flutter/material.dart';
import 'package:flutter_get/src/components/mypage/bottomSheet.dart';
import 'package:flutter_get/src/controller/mypage/mypageController.dart';
import 'package:flutter_get/src/utils/dataUtils.dart';
import 'package:get/get.dart';

class MyPageDealList extends StatelessWidget {
  final MyPageController controller = Get.find<MyPageController>();

  Widget itemList() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Obx(
        () => controller.lists.length == 0 ? itemIsNull() : listView()
      ),
    );
  }

  Widget itemIsNull() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey.withOpacity(0.7)),
            Text('판매중인 상품이 없습니다.')
          ],
        ),
      ),
    );
  }

  Widget listView() {
    return ListView.builder(
        itemCount: controller.lists.length,
        itemBuilder: (context, index) {
          return Container(
            height: 120,
            child: Row(
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(5), child: Image.network(controller.lists[index].thumbnail, width: 110, height: 110, fit: BoxFit.cover)),
                SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(controller.lists[index].title),
                          GestureDetector(child: Icon(Icons.more_vert), onTap: () => controller.showBottomSheet(),)
                        ],
                      ),
                      Text(DataUtils.calcNumFormat(controller.lists[index].price.toString()),  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      Expanded(child: Container()),
                      TextButton(onPressed: (){}, child: Text('거래내역'))
                    ],
                  ),
                )
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return itemList();
  }
}
