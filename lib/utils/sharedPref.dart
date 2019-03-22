import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cost_control/entities/month.dart';

class SharedPref {
  static const String IS_FIRST_SESSION = "first_session";
  static const String LAST_DAY_OF_EDITED = "expenses_edited";
  static const String IS_PURCHASED_NEXT_MONTH = "purchased_next_month";
  static const String FIRST_YEAR = "first_year";
  static const String FIRST_MONTH = "first_month";

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

  Future<bool> isEditedDay(int day) async {
    final sh = await sharedPreferences;
    int lastDayEdited = sh.getInt(LAST_DAY_OF_EDITED);
    if (lastDayEdited == null || lastDayEdited != day) {
      return true;
    } else {
      return false;
    }
  }

  Future setLastEditedDay(int day) async {
    final sh = await sharedPreferences;
    return sh.setInt(LAST_DAY_OF_EDITED, day);
  }

  Future tryUpdateFirstEditMonth(Month month) async {
    Month firstEdit = await getFirstEditMonth();
    if (firstEdit == null) {
      return _setFirstEditMonth(month);
    }
  }

  Future _setFirstEditMonth(Month month) async {
    final sh = await sharedPreferences;
    await sh.setInt(FIRST_YEAR, month.yearNumber);
    return sh.setInt(FIRST_MONTH, month.number);
  }

  Future<Month> getFirstEditMonth() async {
    final sh = await sharedPreferences;
    int year = await sh.getInt(FIRST_YEAR);
    int month = await sh.getInt(FIRST_MONTH);
    if (year != null && month != null) {
      return Month(year, month);
    } else {
      return null;
    }
  }

  Future<bool> isPurchasedNextMonth() async {
    final sh = await sharedPreferences;
    bool res = sh.getBool(IS_PURCHASED_NEXT_MONTH);
    if (res == null) {
      return false;
    }
    return res;
  }

  Future purchasedNextMonth() async {
    final sh = await sharedPreferences;
    sh.setBool(IS_PURCHASED_NEXT_MONTH, true);
  }
}
