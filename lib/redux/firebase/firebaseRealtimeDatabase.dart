import 'dart:async';

import 'package:cost_control/entities/day.dart';
import 'package:cost_control/entities/month.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseRealtimeDatabase {
  static FirebaseRealtimeDatabase _instance;

  static FirebaseRealtimeDatabase get instance {
    if (_instance == null) {
      _instance = FirebaseRealtimeDatabase();
    }
    return _instance;
  }

  //main table name
  static const String USERS = "users";

  //sub table name
  static const String MONTHS = "months";

  //sub table name
  static const String DAY = "day";

  //fields name
  static const String SUM = "sum";
  static const String TIME_CREATION = "created";

  final String uid = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";

  DatabaseReference reference = FirebaseDatabase.instance.reference();

  Future<Query> queryExpense() async {
    String accountKey = await _getAccountKey();

    return reference.child(USERS).child(accountKey).child(MONTHS);
  }

  void saveMonths(Map<String, dynamic> months) async {
    String accountKey = await _getAccountKey();

    reference.child(USERS).child(accountKey).child(MONTHS).update(months);
  }

  Future<void> saveDay(Day day) async {
    String accountKey = await _getAccountKey();

    reference
        .child(USERS)
        .child(accountKey)
        .child(MONTHS)
        .child("${day.parent.name}-${day.parent.yearNumber}")
        .child('${day.number}')
        .update(day.toMap());
  }

  Future<Query> removeAll() async {
    String accountKey = await _getAccountKey();

    reference.child(USERS).child(accountKey).remove();

    return queryExpense();
  }

  Future<StreamSubscription<Event>> getMonthStream(
      Month month, void onData(Month month)) async {
    String accountKey = await _getAccountKey();

    StreamSubscription<Event> subscription = reference
        .child(USERS)
        .child(accountKey)
        .child(MONTHS)
        .child("${month.name}-${month.yearNumber}")
        .onValue
        .listen((Event event) {
      Map<dynamic, dynamic> value = event.snapshot.value;
      onData(Month.fromMap(value));
      print("");
    });

    return subscription;
  }

  Future<String> _getAccountKey() async => uid;
}
