import 'package:redux/redux.dart';
import 'package:cost_control/redux/states/appState.dart';
import 'package:cost_control/database.dart';
import 'package:cost_control/entities/day.dart';
import 'package:cost_control/entities/calcItem.dart';
import 'package:cost_control/entities/expense.dart';
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
      action.onComplete();
    } catch (e) {
      action.onError("Ошибка при сохранении данных");
    }
  }
}
