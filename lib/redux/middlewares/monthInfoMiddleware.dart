import 'package:redux/redux.dart';
import 'package:cost_control/redux/states/appState.dart';
import 'package:cost_control/database.dart';
import 'package:cost_control/entities/month.dart';
import 'package:cost_control/redux/actions/monthInfoActions.dart';

class MonthInfoMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    if (action is ReloadMonth) {
      try {
        reloadMonth(next, action);
      } catch (e) {
        //Nothing
      }
    }
  }

  void reloadMonth(NextDispatcher next, ReloadMonth action) async {
    Month month = await DBProvider.db.getMonth(action.month.id);
    if (month != null) {
      next(new SetMonth(month: month));
    }
  }
}
