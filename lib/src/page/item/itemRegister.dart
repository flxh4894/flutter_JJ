import 'package:flutter/material.dart';
import 'package:flutter_get/src/controller/item/itemRegisterController.dart';
import 'package:flutter_get/src/page/item/itemSearch.dart';
import 'package:flutter_get/src/utils/dataUtils.dart';
import 'package:flutter_get/styles/style.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ItemRegisterPage extends StatelessWidget {

  final ItemRegisterController controller = Get.put(ItemRegisterController());
  final TextEditingController titleController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  final double imageWidth = 60;
  final double imageHeight = 60;
  final node = FocusScopeNode();
  final detailNode = FocusScopeNode();

  Widget _appbar() {
    return AppBar(
      title: Text('아이템등록'),
      elevation: 1,
      actions: [
        TextButton(onPressed: (){controller.setItemRegister({ 'title': titleController.text, 'price': priceController.text });}, child: Text('등록')),
      ],
    );
  }

  Widget _body() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  imageButton(),
                  SizedBox(width: 10,),
                  Expanded(child: buildListView()),
                ],
              ),
              divider(),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: '제목',
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
              divider(),
              categoryDropdown(),
              divider(),
              methodDropdown(),
              divider(),
              itemInfo(),
              divider(),
              price(),
              divider(),
              itemDefaultInfo(),
              divider(),
              itemDetailInfo()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListView() {
    return Container(
      height: imageHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.images.length,
        itemBuilder: (BuildContext context, int index) {
          Asset asset = controller.images[index];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: AssetThumb(
                asset: asset,
                width: 100,
                height: 100,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget imageButton() {
    return GestureDetector(
      onTap: () {
        controller.loadAssets();
      },
      child: Container(
        width: imageWidth,
        height: imageHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 1, color: Colors.grey.withOpacity(0.7)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Icon(Icons.photo_camera, color: Colors.grey.withOpacity(0.7),),
              Text('${controller.images.length}/10')
            ]
        ),
      ),
    );
  }

  Widget methodDropdown() {
    return Container(
      child: DropdownButtonFormField(
        isExpanded: true,
        elevation: 16,
        onChanged: (String newValue) {
          controller.setCategory(newValue);
        },
        items: controller.menuCategory(),
        decoration: InputDecoration(labelText: '카테고리', border:InputBorder.none ),
      ),
    );
  }


  Widget categoryDropdown() {
    return Container(
      child: DropdownButtonFormField(
        isExpanded: true,
        elevation: 16,
        onChanged: (String newValue) {
          controller.setDealMethod(newValue);
        },
        items: controller.menuDealMethod(),
        decoration: InputDecoration(labelText: '거래방법', border:InputBorder.none),
      ),
    );
  }

  Widget itemInfo() {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: itemNameController..text = controller.items.isEmpty ? '' : '[${controller.items[controller.itemIndex.value]['brand']}] ${controller.items[controller.itemIndex.value]['name']}',
              readOnly: true,
              decoration: InputDecoration(
                hintText: '물품명',
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              if(controller.category.value == '0'){
                Get.snackbar('알림', '카테고리를 선택해 주세요.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.black, colorText: Colors.white);
                return;
              }
              Get.to(() => ItemSearch());
            },
          )
        ]
      ),
    );
  }

  Widget price () {
    return TextFormField(
      controller: priceController,
      focusNode: node,
      keyboardType: TextInputType.number,
      onTap: (){priceController.text = priceController.text.replaceAll(',', '').replaceAll('원', '');} ,
      onEditingComplete: (){priceController.text = DataUtils.calcNumFormat(priceController.text); node.unfocus();},
      decoration: InputDecoration(
        hintText: '가격',
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
      ),
    );
  }

  // 기본 기재 정보
  Widget itemDefaultInfo() {
    List<Widget> menu = [];
    for(var i=0; i<controller.itemDefaultInfo.length; i++) {
      menu.add(
        Row(
          children:[
            Container(
              width: 100,
              child: DropdownButtonFormField(
                isExpanded: true,
                value: controller.itemDefaultInfo[i]['menu'],
                onChanged: (newValue){ controller.itemDefaultInfo[i]['menu'] = newValue; },
                items: controller.defaultInfoMenu.map((e) => DropdownMenuItem<String>(value: e, child: Text(e))).toList(),
                decoration: InputDecoration(border:InputBorder.none),
              ),
            ),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '기본기재사항'
                ),
              ),
            ),
            IconButton(icon: Icon(Icons.remove, color: Colors.red,), onPressed: (){
              if(controller.itemDefaultInfo.length > 1)
                controller.itemDefaultInfo.removeAt(i);
              else
                Get.snackbar('알림', '최소 1개의 기재정보는 입력해야 합니다.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.black, colorText: Colors.white);
            })
          ]
        )
      );
    }

    return Container(
      child: Column(
        children: [
          ...menu,
          menu.length == 0 ? Text('판매 물건을 선택해 주세요.') : TextButton(onPressed: (){ controller.addDefaultInfo(); }, child: Text('추가하기'))
        ]
      ),
    );
  }

  Widget itemDetailInfo() {
    return Container(
      height: 200,
      child: TextFormField(
        controller: detailController,
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 10,
        focusNode: detailNode,
        onEditingComplete: (){detailNode.unfocus();},
        decoration: InputDecoration(
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: '제품의 상세한 정보를 입력해주세요. 카테고리에 맞지 않거나 거래가 의심되는 내용은 삭제 될 수 있어요.',
        ),
      ),
    );
  }

  Widget divider() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Divider(),
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
