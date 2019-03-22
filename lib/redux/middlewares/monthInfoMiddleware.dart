import 'package:redux/redux.dart';
import 'package:cost_control/redux/states/appState.dart';
import 'package:cost_control/database.dart';
import 'package:cost_control/entities/month.dart';
import 'package:cost_control/utils/sharedPref.dart';
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
    } else if (action is SaveAccumulationPercent) {
      try {
        savePercent(next, action);
      } catch (e) {

      }
    } else {
      next(action);
    }
  }

  void reloadMonth(NextDispatcher next, ReloadMonth action) async {
    Month month = await DBProvider.db.getMonth(action.month.id);
    if (month != null) {
      next(new SetMonth(month: month));
    }
  }

  void savePercent(NextDispatcher next, SaveAccumulationPercent action) async {
    Month month = await DBProvider.db.getMonth(action.month.id);
    if (month == null) {
      month = action.month;
      month.accumulationPercentage = action.percent;
      await DBProvider.db.addMonth(month);
      await SharedPref.internal().tryUpdateFirstEditMonth(month);
    } else {
      month.accumulationPercentage = action.percent;
      await DBProvider.db.updateMonth(month);
    }
    next(new SetMonth(month: month));
  }
}
