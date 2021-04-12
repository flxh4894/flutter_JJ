
import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: non_constant_identifier_names
final String WATCHLIST = 'watchlist';

class ItemController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  RxInt slideIndex = 0.obs;
  RxBool isWatchlist = false.obs;
  
  void setSlideIndex(int index) {
    slideIndex(index);
  }

  Future addWatchlist(String cid)async {
    final SharedPreferences prefs = await _prefs;
    List<String> list = getSharedData(prefs);
    if(list.length == 0){
      list= [cid];
    } else {
      list.add(cid);
    }
    prefs.setString(WATCHLIST, jsonEncode(list));
  }

  Future removeWatchlist(String cid)async {
    final SharedPreferences prefs = await _prefs;
    List<String> list = getSharedData(prefs);

    list.removeAt(list.indexOf(cid));
    prefs.setString(WATCHLIST, jsonEncode(list));

    //삽질코드
    // List<String> newList = [];
    // list.forEach((element) {
    //   if(element != cid){
    //     newList.add(element);
    //   }
    // });
  }

  Future<bool> getWatchlist(String cid)async {
    final SharedPreferences prefs = await _prefs;
    final List<String> list = getSharedData(prefs);

    if(list.indexOf(cid) != -1) {
      return true;
    }
    return false;
  }
  
  List<String> getSharedData(SharedPreferences prefs) {
    final String jsonString = prefs.getString(WATCHLIST);
    if(jsonString == null) {
      return [];
    }
    return jsonDecode(jsonString).cast<String>();
  }
}