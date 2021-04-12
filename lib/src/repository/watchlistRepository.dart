import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class WatchlistRepository {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future getWatchlist () {

  }

  Future setWatchlist (Map<String ,dynamic> data) async {
    print(data['title']);
    String jsonData = jsonEncode(data).toString();
    print(jsonDecode(jsonData)['title']);
  }

}