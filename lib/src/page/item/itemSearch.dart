
import 'package:flutter/material.dart';
import 'package:flutter_get/src/controller/item/itemRegisterController.dart';
import 'package:flutter_get/styles/style.dart';
import 'package:get/get.dart';

class ItemSearch extends StatelessWidget {

  final ItemRegisterController controller = Get.find<ItemRegisterController>();

  Widget _appbar() {
    return AppBar(
      title: Text('물건명 검색'),
      elevation: 1,
      actions: [
        TextButton(onPressed: (){controller.getItemDefaultInfo(); Get.back();}, child: Text('완료'))
      ],
    );
  }

  Widget _body() {
    return Container(
      padding: Styles.paddingSide,
      child: Obx(
        () => Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: '물건명 입력',
                      border: InputBorder.none
                    ),
                  )
                ),
                IconButton(icon: Icon(Icons.search), onPressed: (){controller.getItemLists();})
              ],
            ),

            controller.items.length == 0 ?
            Expanded(
                child: Container(
                  child: Center(
                    child: Text('검색된 아이템이 없습니다.'),
                  ),
                )
            )
            :
            Expanded(
              child: ListView.builder(
                itemCount: controller.items.length,
                itemBuilder: (context, index) {
                  return Obx(
                    () => ListTile(
                      title: Text('[${controller.items[index]['brand']}] ${controller.items[index]['name']}'),
                      leading: controller.itemIndex.value == index ? Icon(Icons.check, color: Colors.red,) : Text(''),
                      onTap: (){ controller.selectItemName(index);},
                    ),
                  );
                }
              ),
            )
          ],
        ),
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
