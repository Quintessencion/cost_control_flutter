import 'dart:async';

import 'package:cost_control/entities/day.dart';
import 'package:cost_control/entities/month.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseRealtimeDatabase {
  static FirebaseRealtimeDatabase _instance;

  static FirebaseRealtimeDatabase get instance {
    if (_instance == null) {
      _instance = FirebaseRealtimeDatabase();
    }
    return _instance;
  }

  FirebaseUser _user;
  String _userUid = "";

  //main table name
  static const String USERS = "users";

  //sub table name
  static const String MONTHS = "months";

  //sub table name
  static const String DAYS = "days";

  //sub table name
  static const String DAY = "day";

  //fields name
  static const String SUM = "sum";
  static const String TIME_CREATION = "created";

  DatabaseReference reference = FirebaseDatabase.instance.reference();

//  Future<Query> queryExpense() async {
//    if (_userUid.isEmpty) return null;
//
//    return reference.child(USERS).child(_userUid).child(MONTHS);
//  }

  void saveMonths(Map<String, dynamic> months) async {
    if (_userUid.isEmpty) return;

    reference.child(USERS).child(_userUid).child(MONTHS).update(months);
  }

  Future<void> saveDay(Day day) async {
    if (_userUid.isEmpty) return;

    reference
        .child(USERS)
        .child(_userUid)
        .child(MONTHS)
        .child("${day.parent.name}-${day.parent.yearNumber}")
        .child(DAYS)
        .child('${day.number}')
        .update(day.toMap());
  }

  Future<void> removeAll() async {
    if (_userUid.isEmpty) return;

    reference.child(USERS).child(_userUid).remove();
//    return queryExpense();
  }

  Future<StreamSubscription<Event>> getMonthStream(
      Month month, void onData(Month month)) async {
    StreamSubscription<Event> subscription = reference
        .child(USERS)
        .child(_userUid)
        .child(MONTHS)
        .child("${month.name}-${month.yearNumber}")
        .onValue
        .listen((Event event) {
      Map<dynamic, dynamic> value = event.snapshot.value;
      onData(Month.fromMap(value));
    });

    return subscription;
  }

  void setUser(FirebaseUser user, List<Month> months) {
    _user = user;
    _userUid = user.uid;
    saveMonths(Month.listToMap(months));
  }
}
