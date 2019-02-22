import 'package:tuple/tuple.dart';
import 'package:redux/redux.dart';
import 'package:cost_control/redux/states/appState.dart';
import 'package:cost_control/redux/actions/mainActions.dart';
import 'package:cost_control/entities/month.dart';
import 'package:cost_control/entities/day.dart';
import 'package:cost_control/entities/expense.dart';
import 'package:cost_control/entities/monthMovement.dart';
import 'package:cost_control/utils/timeUtils.dart';
import 'package:cost_control/database.dart';

class MainMiddleware extends MiddlewareClass<AppState> {
  //Потом надо получать с помощью расчетов
  static const double DAILY_INCOME = 225.80;

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    List<Expense> expenses = await DBProvider.db.getAllExpenses();
    List<Month> months = getAvailableMonths(expenses);
    addExpensesToDays(months, expenses);
    addMonthExpensesAndIncomes(months);
    computeMonths(months);
    next(new OnMonthsLoaded(
      months: months,
      currentPage: getCurrentPage(months),
    ));
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

  void addMonthExpensesAndIncomes(List<Month> months) {
    //Тестовые данные:
    for (Month month in months) {
      month.incomes = [
        MonthMovement(
          direction: 1,
          monthId: month.id,
          name: "Зарплата",
          sum: 15500,
        ),
        MonthMovement(
          direction: 1,
          monthId: month.id,
          name: "Сдача в аренду",
          sum: 517,
        ),
        MonthMovement(
          direction: 1,
          monthId: month.id,
          name: "Бизнес",
          sum: 42500,
        ),
        MonthMovement(
          direction: 1,
          monthId: month.id,
          name: "Накопления",
          sum: 510000,
        ),
      ];
      month.expenses = [
        MonthMovement(
          direction: -1,
          monthId: month.id,
          name: "Квартира",
          sum: 15500,
        ),
        MonthMovement(
          direction: -1,
          monthId: month.id,
          name: "Стоянка",
          sum: 517,
        ),
        MonthMovement(
          direction: -1,
          monthId: month.id,
          name: "Спорт",
          sum: 42500,
        ),
      ];
      month.accumulationPercentage = 15;
    }
  }

  void computeMonths(List<Month> months) {
    for (Month month in months) {
      month.computeBalanceWithDailyIncome(DAILY_INCOME);
    }
  }

  int getCurrentPage(List<Month> months) {
    for (int i = 0; i < months.length; i++) {
      if (months[i].isBelong(DateTime.now())) {
        return i;
      }
    }
    return 0;
  }
}
