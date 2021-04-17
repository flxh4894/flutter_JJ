import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository{
  SharedPreferences prefs;
  final Logger logger = Logger(
    printer: PrettyPrinter(),
  );

  void setUserUid(String uid) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('UID', uid);
  }

  void setUserProfile(String nickname, String photoUrl, String userId) async {
    prefs = await SharedPreferences.getInstance();

    prefs.setString('nickname', nickname);
    prefs.setString('photoUrl', photoUrl);
    prefs.setString('userId', userId);
  }

  Future<String> getUserUid() async {
    prefs = await SharedPreferences.getInstance();
    logger.d(prefs.get('UID'));
    return prefs.get('UID');
  }

  Future<String> getUserNickname() async {
    prefs = await SharedPreferences.getInstance();

    return prefs.getString('nickname');
  }

  Future<String> getPhotoUrl() async {
    prefs = await SharedPreferences.getInstance();

    return prefs.getString('photoUrl');
  }

  Future<String> getUserId() async {
    prefs = await SharedPreferences.getInstance();

    return prefs.getString('userId');
  }

}