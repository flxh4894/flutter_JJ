import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_get/src/repository/authRepository.dart';
import 'package:get/get.dart';
import 'package:image/image.dart';
import 'package:logger/logger.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:uuid/uuid.dart';

class ItemRegisterController extends GetxController{
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final Logger logger = Logger(
    printer: PrettyPrinter(),
  );
  RxList<Asset> images = <Asset>[].obs;
  RxString error = ''.obs;
  RxString dealMethod = '1'.obs;
  RxString category = '0'.obs;
  RxList itemDefaultInfo = [].obs; // 메뉴 + 텍스트
  RxList defaultInfoMenu = [].obs; // 메뉴

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 이미지 선택
  void loadAssets() async {
    List<Asset> resultList = [];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarTitle: "이미지 폴더",
          allViewTitle: "모든 이미지",
          useDetailsView: false,
          selectCircleStrokeColor: "#ffffff",
        ),
      );
    } on Exception catch (e) {
      error(e.toString());
      logger.e(e);
    }

    images(resultList);
  }

  // 거래방법 메뉴
  List menuDealMethod() {
    List menu = [
      {'title': '직거래', 'value':'1'},
      {'title': '택배거래', 'value':'2'},
      {'title': '모두가능', 'value':'3'},
    ];
    return menu.map((e) => DropdownMenuItem<String>(value: e['value'], child: Text(e['title']))).toList();
  }

  // 거래 방법 저장
  void setDealMethod (String method) {
    dealMethod(method);
  }

  // 카테고리 메뉴
  List menuCategory() {
    List menu = [
      {'title': 'CPU', 'value':'1'},
      {'title': 'RAM', 'value':'2'},
      {'title': 'VGA', 'value':'3'},
      {'title': 'MB', 'value':'4'},
      {'title': 'iPhone', 'value':'5'},
      {'title': '안드로이드', 'value':'6'},
      {'title': '태블릿', 'value':'7'},
    ];
    return menu.map((e) => DropdownMenuItem<String>(value: e['value'], child: Text(e['title']))).toList();
  }

  // 카테고리 저장
  void setCategory(String category) {
    this.category(category);
  }

  void setItemDetail(int index, String selected) {
    itemDefaultInfo[index]['menu'] = selected;
  }

  // 기본 기재정보 추가
  void addDefaultInfo() {
    if(itemDefaultInfo.length == defaultInfoMenu.length){
      Get.snackbar('알림', '더이상 추가가 불가능 합니다.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.black, colorText: Colors.white);
      return;
    }
    var data = {
      'menu': defaultInfoMenu[itemDefaultInfo.length].toString(),
      'text': ''
    };

    itemDefaultInfo.add(data);
  }

  // 물건 검색시 선택 인덱스
  RxInt itemIndex = 0.obs;
  void selectItemName(int index) {
    itemIndex(index);
  }

  // 서버에서 아이템 기본 정보 불러오기
  void getItemDefaultInfo() {
    logger.d('${items[itemIndex.value]}의 정보를 불러옵니다.');
    List defaultInfo = ['AS 유무', '오버클럭 여부', 'PBO 최대'];
    defaultInfoMenu.clear();
    defaultInfoMenu.addAll(defaultInfo);
    itemDefaultInfo.clear();
    itemDefaultInfo.add({'menu': defaultInfo[0] , 'text': ''});
  }

  // 아이템 목록 불러오기
  RxList items = [].obs;
  void getItemLists() async {
    Get.dialog(Center(child: CircularProgressIndicator()),barrierDismissible: true);
    await Future.delayed(Duration(seconds: 2));
    items.add({'brand':'AMD', 'name':'Ryzen 5600X'});
    items.add({'brand':'AMD', 'name':'Ryzen 5700X'});
    Get.back();
  }

  // 이미지 저장
  Future<List> saveImage() async {

    List urls = [];
    var uuid = Uuid();

    for(var image in images) {
      String fileName = uuid.v4();
      ByteData byteData = await image.getByteData(); // requestOriginal is being deprecated
      List<int> imageData = byteData.buffer.asUint8List();
      var tempImg = decodeImage(imageData);
      var thumbnail = copyResize(tempImg, width: 1000); // 이미지 리사이즈

      try {
        var ref = firebase_storage.FirebaseStorage.instance
            .ref('items/$fileName');
        var uploadTask = await ref.putData(encodePng(thumbnail));
        urls.add(await uploadTask.ref.getDownloadURL());
      } catch (e) {
        logger.e(e);
      }
    }
    return urls;
  }
  
  // 아이템 등록
  void setItemRegister(Map data) async {
    Get.dialog(Center(child: CircularProgressIndicator()),barrierDismissible: true);

    var itemRef = _fireStore.collection('sell_list');
    var time = DateTime.now();
    var userId = await AuthRepository().getUserId();
    var price = data['price'].replaceAll(',', '').replaceAll('원', '');
    var urls = await saveImage();

    itemRef.add({
      'category': int.parse(category.value),
      'date': time,
      'deal_method': int.parse(dealMethod.value),
      'deal_type': 2,
      'images': urls,
      'price': int.parse(price),
      'itemInfo': 15,
      'sell_user': userId,
      'title': data['title']
    });

    Get.back();
    Get.back();
  }

}