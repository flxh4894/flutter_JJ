import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository{
  SharedPreferences prefs;

  AuthRepository (){
    init();
  }

  void init() async {
    prefs = await SharedPreferences.getInstance();
  }


}