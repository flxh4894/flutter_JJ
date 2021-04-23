import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_get/src/repository/authRepository.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String WATCHLIST = 'watchlist';

class ItemController extends GetxController {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final Logger logger = Logger(
    printer: PrettyPrinter(),
  );
  final AuthRepository authRepository = AuthRepository();
  final String itemDocId;
  final String seller;
  final int itemId;
  
  RxInt slideIndex = 0.obs;
  RxBool isWatchlist = false.obs;
  RxBool isMe = false.obs;
  RxString itemNm = ''.obs;
  String userId;
  
  // 클래스 초기화
  ItemController({this.itemDocId, this.seller, this.itemId});

  void setSlideIndex(int index) {
    slideIndex(index);
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() async{
    userId = await authRepository.getUserId();
    itemUserCheck();
    getWatchlistNew();
    getItemName();
  }

  // 파는사람이 나인지 아닌지.
  void itemUserCheck() async {
    final itemSeller = await authRepository.getUserId() == seller;
    logger.d('판매자 : $itemSeller');
    isMe(itemSeller);
  }

  // 아이템 이름 가져오기
  void getItemName() async {
    var itemName = await _fireStore.collection('items').where('id', isEqualTo: itemId).get();
    var docItemName = itemName.docs[0].data();
    itemNm('[${docItemName['brand']}] ${docItemName['name']}');
  }

  // 관심목록에 등록이 된 아이템인지
  void getWatchlistNew() async {
    var watchlist = await _fireStore.collection('watchlist').doc(userId).collection('list').doc(itemDocId).get();
    var data = watchlist.data();
    if(data == null) {
      isWatchlist(false);
      return;
    }
    isWatchlist(data['status']);
  }

  void setWatchlistNew(bool status) async {
    var watchRef = _fireStore.collection('watchlist').doc(userId).collection('list').doc(itemDocId);
    watchRef.set({ 'status' : status });

    isWatchlist(status);
  }
}