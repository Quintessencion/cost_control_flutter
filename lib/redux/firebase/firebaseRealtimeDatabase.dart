import 'dart:async';

import 'package:cost_control/entities/day.dart';
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

    return reference
        .child(USERS)
        .child(accountKey)
        .child(DAY)
        .orderByChild(TIME_CREATION);
  }

  Future<void> saveDay(Day day) async {
    String accountKey = await _getAccountKey();

    reference
        .child(USERS)
        .child(accountKey)
        .child(MONTHS)
        .child(day.parent.name)
        .child('${day.number}')
        .update(day.toMap());
  }

  Future<void> saveSum(String snapshotKey, String sum) async {
    String accountKey = await _getAccountKey();

    return reference
        .child(USERS)
        .child(accountKey)
        .child(DAY)
        .child(snapshotKey)
        .child(SUM)
        .set(sum);
  }

  Future<Query> removeCostRecord(String snapshotKey) async {
    String accountKey = await _getAccountKey();

    reference
        .child(USERS)
        .child(accountKey)
        .child(DAY)
        .child(snapshotKey)
        .remove();

    return queryExpense();
  }

  Future<Query> removeAll() async {
    String accountKey = await _getAccountKey();

    reference.child(USERS).child(accountKey).child(DAY).remove();

    return queryExpense();
  }

  Future<StreamSubscription<Event>> getSumStream(
      String snapshotKey, void onData(String name)) async {
    String accountKey = await _getAccountKey();

    StreamSubscription<Event> subscription = reference
        .child(USERS)
        .child(accountKey)
        .child(DAY)
        .child(snapshotKey)
        .child(SUM)
        .onValue
        .listen((Event event) {
      String sum = event.snapshot.value as String;
      onData(sum == null ? "" : sum);
    });

    return subscription;
  }

  Future<String> _getAccountKey() async => uid;
}
