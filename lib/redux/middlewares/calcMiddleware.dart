import 'package:redux/redux.dart';
import 'package:cost_control/redux/states/appState.dart';
import 'package:cost_control/database.dart';
import 'package:cost_control/entities/day.dart';
import 'package:cost_control/entities/calcItem.dart';
import 'package:cost_control/entities/expense.dart';
import 'package:cost_control/utils/reminder.dart';
import 'package:uuid/uuid.dart';

class CalcMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
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
        Reminder.setRemind();
      }
      action.onComplete();
    } catch (e) {
      action.onError("Ошибка при сохранении данных");
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
