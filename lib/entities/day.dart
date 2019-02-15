import 'package:cost_control/entities/expense.dart';

class Day {
  int monthNumber;
  int number;
  List<Expense> expenses;

  Day({this.monthNumber, this.number, this.expenses});
}
