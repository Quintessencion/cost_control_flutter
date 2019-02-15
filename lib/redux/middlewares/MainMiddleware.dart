import 'package:redux/redux.dart';
import 'package:cost_control/redux/states/appState.dart';
import 'package:cost_control/redux/actions/mainActions.dart';
import 'package:cost_control/entities/month.dart';
import 'package:cost_control/entities/day.dart';
import 'package:cost_control/entities/expense.dart';
import 'package:cost_control/utils/timeUtils.dart';
import 'package:cost_control/database.dart';

class MainMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    List<Expense> expenses = await DBProvider.db.getAllExpenses();
    List<Month> months = getAvailableMonths(expenses);
    for (Expense expense in expenses) {
      //months[expense.month - 1].days[expense.day - 1].expenses.add(expense);
    }
    next(new OnMonthsLoaded(months: months));
  }

  List<Month> getAvailableMonths(List<Expense> expenses) {
    DateTime beginDate = DateTime.now();
    DateTime endDate = DateTime(beginDate.year + 1, beginDate.month, 0);
    for (Expense expense in expenses) {
      DateTime curr = DateTime(expense.year, expense.month);
      if (curr.compareTo(beginDate) < 0) {
        beginDate = curr;
      }
      if (curr.compareTo(endDate) > 0) {
        endDate = curr;
      }
    }
    beginDate = DateTime(beginDate.year, beginDate.month, 1);
    endDate = DateTime(endDate.year, endDate.month, 1);

    List<Month> months = new List();
    while (beginDate.compareTo(endDate) <= 0) {
      List<Day> days = new List();
      for (int j = 1; j <= TimeUtils.getDaysCountByDate(beginDate); j++) {
        days.add(new Day(
          number: j,
          monthNumber: beginDate.month,
          expenses: [],
        ));
      }
      months.add(new Month(
        number: beginDate.month,
        name: TimeUtils.getMonthNameByNumber(beginDate.month),
        shortName: TimeUtils.getMonthShortNameByNumber(beginDate.month),
        days: days,
      ));
      beginDate = DateTime(beginDate.year, beginDate.month + 1, beginDate.day);
    }
    return months;
  }
}
