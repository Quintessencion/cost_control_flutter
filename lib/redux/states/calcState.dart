import 'package:cost_control/entities/calcItem.dart';
import 'package:cost_control/entities/expense.dart';

class CalcState {
  List<Expense> initExpenses;
  List<CalcItem> expenses;
  int currentPage;

  CalcState({this.expenses, this.currentPage});

  factory CalcState.initial() {
    return new CalcState(expenses: [CalcItem()], currentPage: 0);
  }
}
