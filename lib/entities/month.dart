import 'package:cost_control/entities/day.dart';
import 'package:cost_control/utils/timeUtils.dart';

class Month {
  int _yearNumber;
  int _number;
  String _name;
  String _shortName;
  List<Day> _days;

  int generalBalance;

  Month(this._yearNumber, this._number) {
    _name = TimeUtils.getMonthNameByNumber(_number);
    _shortName = TimeUtils.getMonthShortNameByNumber(_number);
    _days = new List();
  }

  int get yearNumber => _yearNumber;
  int get number => _number;
  String get name => _name;
  String get shortName => _shortName;
  List<Day> get days => _days;

  int get expensesSum {
    int res = 0;
    for (Day d in _days) {
      res += d.expensesSum;
    }
    return res;
  }

  bool isBelong(DateTime date) {
    return _yearNumber == date.year && _number == date.month;
  }

  int computeBalanceWithDailyIncome(int dailyIncome) {
    generalBalance = 0;
    for (Day day in _days) {
      day.balance = dailyIncome - day.expensesSum;
      generalBalance += day.balance;
      day.balanceToDay = generalBalance;
    }
    return generalBalance;
  }
}
