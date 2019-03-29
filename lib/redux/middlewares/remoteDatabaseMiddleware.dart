import 'package:cost_control/redux/actions/calcActions.dart';
import 'package:cost_control/redux/firebase/firebaseRealtimeDatabase.dart';
import 'package:cost_control/redux/states/appState.dart';
import 'package:redux/redux.dart';

class RemoteDatabaseMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store store, action, NextDispatcher next) {
    if (action is FirebaseSaveDay) {
      FirebaseRealtimeDatabase.instance.saveDay(action.day);
    }
    next(action);
  }
}