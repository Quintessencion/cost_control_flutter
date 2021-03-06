import 'package:cost_control/entities/day.dart';
import 'package:cost_control/entities/monthMovement.dart';
import 'package:cost_control/utils/timeUtils.dart';
import 'package:uuid/uuid.dart';

class Month {
  String _id;
  int _yearNumber;
  int _number;
  List<MonthMovement> incomes;
  List<MonthMovement> expenses;
  int accumulationPercentage;
  bool isAvailable;
  String _name;
  String _shortName;
  List<Day> _days;
  double _generalBalance;

  Month(this._yearNumber, this._number) {
    _id = Uuid().v1();
    _name = TimeUtils.getMonthNameByNumber(_number);
    _shortName = TimeUtils.getMonthShortNameByNumber(_number);
    _days = new List();
    incomes = [];
    expenses = [];
    accumulationPercentage = 0;
    isAvailable = true;
  }

  Month.withJson(
      {String id, int yearNumber, int number, accumulationPercentage}) {
    _id = id;
    _yearNumber = yearNumber;
    _number = number;
    _name = TimeUtils.getMonthNameByNumber(number);
    _shortName = TimeUtils.getMonthShortNameByNumber(number);
    incomes = [];
    expenses = [];
    this.accumulationPercentage = accumulationPercentage;
    isAvailable = true;
  }

  Month.withMap({
    id,
    yearNumber,
    number,
    accumulationPercentage,
    isAvailable,
    generalBalance,
  }) {
    _id = id;
    _yearNumber = yearNumber;
    _number = number;
    _name = TimeUtils.getMonthNameByNumber(number);
    _shortName = TimeUtils.getMonthShortNameByNumber(number);
    incomes = [];
    expenses = [];
    this.accumulationPercentage = accumulationPercentage;
    this.isAvailable = isAvailable;
    _generalBalance = generalBalance;
  }

  String get id => _id;

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

  void computeBalance() {
    double prevBalance = 0;
    double dailyIncome = dayBudget;
    for (Day day in _days) {
      day.budget = dailyIncome + prevBalance;
      prevBalance = day.balance = day.budget - day.expensesSum;
    }
    _generalBalance = prevBalance;
  }

  double get monthIncomesSum {
    double res = 0;
    for (MonthMovement movement in incomes) {
      res += movement.sum;
    }
    return res;
  }

  double get monthExpensesSum {
    double res = 0;
    for (MonthMovement movement in expenses) {
      res += movement.sum;
    }
    res += monthAccumulation;
    return res;
  }

  double get budget {
    return monthIncomesSum - monthExpensesSum;
  }

  double get dayBudget {
    return budget /
        TimeUtils.getDaysCountByDate(new DateTime(_yearNumber, _number));
  }

  double get monthAccumulation {
    return monthIncomesSum * accumulationPercentage / 100;
  }

  double get yearAccumulation {
    return monthAccumulation * TimeUtils.MONTH_IN_YEAR;
  }

  void addJsonData(Month month) {
    _id = month.id;
    accumulationPercentage = month.accumulationPercentage;
    incomes = month.incomes;
    expenses = month.expenses;
  }

  void addVirtualData(Month month) {
    accumulationPercentage = month.accumulationPercentage;
    month.incomes.forEach((inc) {
      incomes.add(MonthMovement.copy(Uuid().v1(), id, inc));
    });
    month.expenses.forEach((exp) {
      expenses.add(MonthMovement.copy(Uuid().v1(), id, exp));
    });
  }

  int compareTo(Month other) {
    return DateTime(yearNumber, number)
        .compareTo(DateTime(other.yearNumber, other.number));
  }

  factory Month.fromJson(Map<String, dynamic> json) => new Month.withJson(
        id: json["id"],
        yearNumber: json["yearNumber"],
        number: json["number"],
        accumulationPercentage: json["accumulationPercentage"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "yearNumber": yearNumber,
        "number": number,
        "accumulationPercentage": accumulationPercentage,
      };

  static Map<String, dynamic> listToMap(List<Month> months) {
    Map<String, dynamic> monthsMap = Map();

    for (Month month in months) {
      monthsMap["${month.name}-${month.yearNumber}"] = month.toMap();
    }

    return monthsMap;
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "yearNumber": yearNumber,
        "number": number,
        "accumulationPercentage": accumulationPercentage,
        "isAvailable": isAvailable,
        "days": Day.listToMap(days),
        "generalBalance": generalBalance,
      };

  factory Month.fromMap(Map<dynamic, dynamic> map) {
    Month month = Month.withMap(
      id: map["id"],
      yearNumber: map["yearNumber"],
      number: map["number"],
      accumulationPercentage: map["accumulationPercentage"],
      isAvailable: map["isAvailable"],
      generalBalance: map["generalBalance"].toDouble(),
    );
    month.setDays(Day.fromMap(map["days"], month));
    return month;
  }

  setDays(List<Day> days) => _days = days;
}
