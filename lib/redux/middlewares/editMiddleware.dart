import 'package:redux/redux.dart';
import 'package:cost_control/redux/states/appState.dart';
import 'package:cost_control/database.dart';
import 'package:cost_control/entities/month.dart';
import 'package:cost_control/entities/monthMovement.dart';
import 'package:cost_control/redux/actions/editActions.dart';
import 'package:uuid/uuid.dart';

class EditMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    if (action is CreateMovement) {
      try {
        await createMovement(action);
        action.onComplete();
      } catch (e) {
        action.onError("Ошибка при создании записи");
      }
    } else if (action is EditMovement) {
      try {
        await editMovement(action);
        action.onComplete();
      } catch (e) {
        action.onError("Ошибка при обновлении записи");
      }
    } else {
      next(action);
    }
  }

  Future<int> createMovement(CreateMovement action) async {
    Month month = await DBProvider.db.getMonth(action.month.id);
    if (month == null) {
      await DBProvider.db.addMonth(action.month);
    }
    MonthMovement movement = new MonthMovement(
      id: Uuid().v1(),
      direction: action.direction,
      monthId: action.month.id,
      name: action.name,
      sum: action.sum,
    );
    return DBProvider.db.addMonthMovement(movement);
  }

  Future<int> editMovement(EditMovement action) async {
    return DBProvider.db.updateMonthMovement(action.movement);
  }
}
