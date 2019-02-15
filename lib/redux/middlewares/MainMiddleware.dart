import 'package:redux/redux.dart';
import 'package:cost_control/redux/states/appState.dart';
import 'package:cost_control/redux/actions/mainActions.dart';
import 'package:cost_control/entities/month.dart';
import 'package:cost_control/entities/day.dart';
import 'package:cost_control/utils/timeUtils.dart';

class MainMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    List<Month> months = new List();
    for (int i = 1; i <= TimeUtils.MONTH_IN_YEAR; i++) {
      List<Day> days = new List();
      for (int j = 1; j <= TimeUtils.getDaysCountByMonth(i); j++) {
        days.add(new Day(number: j));
      }
      months.add(new Month(
        number: i,
        name: TimeUtils.getMonthNameByNumber(i),
        shortName: TimeUtils.getMonthShortNameByNumber(i),
        days: days,
      ));
    }
    next(new OnMonthsLoaded(months: months));
  }
}
