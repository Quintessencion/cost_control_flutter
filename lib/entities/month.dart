import 'package:cost_control/entities/day.dart';
import 'package:cost_control/utils/timeUtils.dart';

class Month {
  int _yearNumber;
  int _number;
  String _name;
  String _shortName;
  List<Day> _days;
  double _generalBalance;

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

  double get generalBalance => _generalBalance;

  double get expensesSum {
    double res = 0;
    for (Day d in _days) {
      res += d.expensesSum;
    }
    return res;
  }

  double get balanceToCurrentDay {
    if (DateTime.now().year == _yearNumber && DateTime.now().month == _number) {
      return _days[DateTime.now().day - 1].balance;
    } else {
      return _generalBalance;
    }
  }

  bool isBelong(DateTime date) {
    return _yearNumber == date.year && _number == date.month;
  }

  void computeBalanceWithDailyIncome(double dailyIncome) {
    double prevBalance = 0;
    for (Day day in _days) {
      day.budget = dailyIncome + prevBalance;
      prevBalance = day.balance = day.budget - day.expensesSum;
    }
    _generalBalance = prevBalance;
  }
}
