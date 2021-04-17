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
  final String itemId;
  final String seller;
  
  RxInt slideIndex = 0.obs;
  RxBool isWatchlist = false.obs;
  RxBool isMe = false.obs;
  String userId;
  
  // 클래스 초기화
  ItemController({this.itemId, this.seller});

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
  }

  // 파는사람이 나인지 아닌지.
  void itemUserCheck() async {
    final itemSeller = await authRepository.getUserId() == seller;
    logger.d('판매자 : $itemSeller');
    isMe(itemSeller);
  }

  void getWatchlistNew() async {
    logger.d('아이템아이디 $itemId');
    var watchlist = await _fireStore.collection('watchlist').doc(userId).collection('list').doc(itemId).get();
    var data = watchlist.data();
    if(data == null) {
      isWatchlist(false);
      return;
    }
    isWatchlist(data['status']);
  }

  void setWatchlistNew(bool status) async {
    var watchRef = _fireStore.collection('watchlist').doc(userId).collection('list').doc(itemId);
    watchRef.set({ 'status' : status });

    isWatchlist(status);
  }
}