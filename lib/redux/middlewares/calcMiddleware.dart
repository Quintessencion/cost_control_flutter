import 'package:cost_control/database.dart';
import 'package:cost_control/entities/calcItem.dart';
import 'package:cost_control/entities/day.dart';
import 'package:cost_control/entities/expense.dart';
import 'package:cost_control/redux/actions/calcActions.dart';
import 'package:cost_control/redux/states/appState.dart';
import 'package:cost_control/utils/reminder.dart';
import 'package:cost_control/utils/sharedPref.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';

class CalcMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    if (action is SaveDay) {
      try {
        List<CalcItem> expenses = store.state.calcState.expenses;
        Day day = action.day;

        day.expenses.clear();
        for (CalcItem expense in expenses) {
          if (!expense.isEmpty()) {
            day.expenses.add(Expense(
              id: Uuid().v1(),
              year: day.parent.yearNumber,
              month: day.parent.number,
              day: day.number,
              cost: expense.value,
              description: expense.description,
            ));
          }
        }
        await DBProvider.db.updateDay(day);
        if (_isChanged(store.state.calcState.initExpenses, day.expenses)) {
          await SharedPref.internal().tryUpdateFirstEditMonth(day.parent);
          Reminder.cancelCurrentDayRemind();
        }
        action.onComplete();
        Future.delayed(const Duration(milliseconds: 1000),
            () => next(FirebaseSaveDay(day: day)));
      } catch (e) {
        action.onError("Ошибка при сохранении данных");
      }
    }
    if (action is SaveDays) {
      var days = action.days;
      for (Day newDay in days) {
        List<Expense> newExpenses = List<Expense>();
        for (Expense expense in newDay.expenses) {
          newExpenses.add(expense);
        }
        newDay.expenses.clear();
        for (Expense expense in newExpenses) {
          newDay.expenses.add(Expense(
            id: Uuid().v1(),
            year: newDay.parent.yearNumber,
            month: newDay.parent.number,
            day: newDay.number,
            cost: expense.cost,
            description: expense.description,
          ));
        }
        await DBProvider.db.updateDay(newDay);
      }
      Future.delayed(
          const Duration(milliseconds: 1000), () => action.onComplete());
    }
  }

  bool _isChanged(List<Expense> a, List<Expense> b) {
    if (a.length != b.length) {
      return true;
    }
    for (int i = 0; i < a.length; i++) {
      Expense ea = a[i];
      Expense eb = b[i];
      if (ea.cost != eb.cost || ea.description != eb.description) {
        return true;
      }
    }
    return false;
  }
}
