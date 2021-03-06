import 'package:cost_control/database.dart';
import 'package:cost_control/entities/day.dart';
import 'package:cost_control/entities/expense.dart';
import 'package:cost_control/entities/month.dart';
import 'package:cost_control/entities/monthMovement.dart';
import 'package:cost_control/redux/actions/mainActions.dart';
import 'package:cost_control/redux/firebase/firebaseRealtimeDatabase.dart';
import 'package:cost_control/redux/states/appState.dart';
import 'package:cost_control/utils/sharedPref.dart';
import 'package:cost_control/utils/timeUtils.dart';
import 'package:cost_control/utils/purchasesManager.dart';
import 'package:redux/redux.dart';
import 'package:tuple/tuple.dart';

class MainMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    if (action is LoadMonths) {
      loadMonths(action, next);
    } else if (action is SetFirstScreenVisibility) {
      hideFirstScreen(next);
    } else if (action is PurchaseNextMonth) {
      purchaseNextMonth(action, next);
    }  else if (action is RestorePurchase) {
      restorePurchase(action, next);
    } else {
      next(action);
    }
  }

  void loadMonths(LoadMonths action, NextDispatcher next) async {
    SharedPref().isFirstSession().then((isFirst) {
      if (isFirst) {
        next(SetFirstScreenVisibility(visibility: true));
      }
    });

    //Получение "реальных" элеметов из таблицы
    List<Expense> expenses = await DBProvider.db.getAllExpenses();
    List<Month> dataBaseMonths = await DBProvider.db.getAllMonths();
    List<MonthMovement> movements = await DBProvider.db.getAllMonthMovements();

    //Получение границы значений "виртуальных" месяцев
    List<Month> months = getAvailableMonths(expenses);

    //Соединение виртуальных и реальных данных
    addExpensesToDays(months, expenses);
    addMonthMovements(dataBaseMonths, movements);
    addRealMonthData(months, dataBaseMonths);

    await computeMonths(months);

    next(new OnMonthsLoaded(
      months: months,
    ));
  }

  void hideFirstScreen(NextDispatcher next) async {
    await SharedPref().unsetFirstSession();
    next(SetFirstScreenVisibility(visibility: false));
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
      Month month = new Month(beginDate.year, beginDate.month);
      for (int j = 1; j <= TimeUtils.getDaysCountByDate(beginDate); j++) {
        month.days.add(new Day(month, j));
      }
      months.add(month);
      beginDate = DateTime(beginDate.year, beginDate.month + 1, beginDate.day);
    }
    return months;
  }

  void purchaseNextMonth(PurchaseNextMonth action, NextDispatcher next) async {
    PurchasesManager manager;
    try {
      manager = await PurchasesManager.instance;
    } catch (e) {
      action.onResult("Магазин недоступен");
    }
    if (manager == null) {
      return;
    }
    try {
      bool res = await manager.buyNextMonth();
      if (res) {
        action.onResult("Приобретено!");
        loadMonths(LoadMonths(), next);
      } else {
        throw Error();
      }
    } catch (e) {
      action.onResult("При покупке произошла ошибка");
    }
  }

  void restorePurchase(RestorePurchase action, NextDispatcher next) async {
    PurchasesManager manager;
    try {
      manager = await PurchasesManager.instance;
    } catch (e) {
      action.onResult("Магазин недоступен");
    }
    if (manager == null) {
      return;
    }
    try {
      await manager.restorePurchases();
      bool res = await manager.isPurchasedNextMonth();
      if (res) {
        action.onResult("Покупка восстановлена");
        loadMonths(LoadMonths(), next);
      } else {
        action.onResult("У вас нет данной покупки");
      }
    } catch (e) {
      action.onResult("Восстановление не удалось");
    }
  }

  void addExpensesToDays(List<Month> months, List<Expense> expenses) {
    Map<Tuple2<int, int>, Month> map = new Map();
    for (Month month in months) {
      map[Tuple2(month.yearNumber, month.number)] = month;
    }
    for (Expense expense in expenses) {
      Month month = map[Tuple2(expense.year, expense.month)];
      month.days[expense.day - 1].expenses.add(expense);
    }
  }

  void addRealMonthData(List<Month> months, List<Month> databaseMonths) {
    Map<Tuple2<int, int>, Month> map = new Map();
    for (Month month in databaseMonths) {
      map[Tuple2(month.yearNumber, month.number)] = month;
    }
    List<Month> empty = new List();
    for (Month month in months) {
      Month real = map[Tuple2(month.yearNumber, month.number)];
      if (real != null) {
        month.addJsonData(real);
      } else {
        empty.add(month);
      }
    }
    if (empty.isEmpty || databaseMonths.isEmpty) {
      return;
    }
    databaseMonths.sort((a, b) => a.compareTo(b));
    int i = 0;
    for (Month month in empty) {
      while (i + 1 < databaseMonths.length &&
          month.compareTo(databaseMonths[i + 1]) > 0) {
        i++;
      }
      month.addVirtualData(databaseMonths[i]);
    }
  }

  void addMonthMovements(List<Month> months, List<MonthMovement> movements) {
    Map<String, Month> map = new Map();
    for (Month month in months) {
      map[month.id] = month;
    }
    for (MonthMovement movement in movements) {
      Month month = map[movement.monthId];
      if (month == null) {
        continue;
      }
      if (movement.direction > 0) {
        month.incomes.add(movement);
      }
      if (movement.direction < 0) {
        month.expenses.add(movement);
      }
    }
  }

  Future<bool> computeMonths(List<Month> months) async {
    Month firstEdited = await SharedPref.internal().getFirstEditMonth();
    Month notEmptyMonth;
    for (Month month in months) {
      month.computeBalance();
      if (firstEdited != null && month.compareTo(firstEdited) == 0) {
        notEmptyMonth = month;
      }
    }
    bool isPurchasedNextMonth;
    try {
      PurchasesManager manager = await PurchasesManager.instance;
      isPurchasedNextMonth = await manager.isPurchasedNextMonth();
    } catch (error) {
      return Future.value(false);
    }
    if (isPurchasedNextMonth || notEmptyMonth == null) {
      for (Month month in months) {
        month.isAvailable = true;
      }
    } else {
      notEmptyMonth.isAvailable = true;
    }
    return Future.value(true);
  }
}
