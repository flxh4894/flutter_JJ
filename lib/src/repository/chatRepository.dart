
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ChatRepository {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void setMessage(String roomName, Map<String, dynamic> data, int readIndex, int lastReadIndex) async {
    final SharedPreferences prefs = await _prefs;
    var list = prefs.getStringList(roomName);
    if (list != null) {
      list.add(jsonEncode(data));
      prefs.setStringList(roomName, list);
    } else {
      prefs.setStringList(roomName, [jsonEncode(data)]);
    }

    final indexData = {
      'read': readIndex,
      'last': lastReadIndex
    };
    prefs.setString('${roomName}_index', jsonEncode(indexData));
  }

  Future getMessage(String roomName)async {
    final SharedPreferences prefs = await _prefs;
    final List<String> jsonString = prefs.getStringList(roomName);
    final String jsonMessageIndex = prefs.getString('${roomName}_index');
    final List<Map<String, dynamic>> newList = jsonString.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();

    print(jsonMessageIndex);
    return newList;
  }
}