import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const String IS_FIRST_SESSION = "first_session";

  static SharedPref _instance = new SharedPref.internal();

  SharedPref.internal();

  factory SharedPref() => _instance;

  SharedPreferences _sharedPreferences;

  Future<SharedPreferences> get sharedPreferences async {
    if (_sharedPreferences != null) {
      return _sharedPreferences;
    }
    return await SharedPreferences.getInstance().then((prefs) {
      return _sharedPreferences = prefs;
    });
  }

  Future<bool> isFirstSession() async {
    final sh = await sharedPreferences;
    bool res = sh.getBool(IS_FIRST_SESSION);
    if (res == null) {
      res = false;
    }
    return !res;
  }

  Future unsetFirstSession() async {
    final sh = await sharedPreferences;
   return sh.setBool(IS_FIRST_SESSION, true);
  }
}
