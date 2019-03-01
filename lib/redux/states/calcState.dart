import 'package:cost_control/entities/calcItem.dart';

class CalcState {
  List<CalcItem> expenses;
  int currentPage;

  CalcState({this.expenses, this.currentPage});

  factory CalcState.initial() {
    return new CalcState(expenses: [CalcItem()], currentPage: 0);
  }
}
