import 'package:cost_control/entities/expense.dart';
import 'package:cost_control/entities/month.dart';

class Day {
  Month _parent;
  int _number;
  List<Expense> _expenses;
  double budget;
  double balance;

  Day(this._parent, this._number) {
    _expenses = new List();
  }

  Day.withMap(
      this._parent, this._number, this._expenses, this.budget, this.balance);

  Month get parent => _parent;

  int get number => _number;

  List<Expense> get expenses => _expenses;

  double get expensesSum {
    double res = 0;
    for (Expense e in _expenses) {
      res += e.cost;
    }
    return res;
  }

  String get description {
    StringBuffer res = new StringBuffer();
    List<Expense> withDescription =
        expenses.where((e) => e.description.isNotEmpty).toList();

    for (int i = 0; i < withDescription.length; i++) {
      String description = withDescription[i].description.toLowerCase();
      if (i == 0) {
        res.write(description.substring(0, 1).toUpperCase());
        if (description.length > 1) {
          res.write(description.substring(1));
        }
      } else {
        res.write(", ");
        res.write(description);
      }
    }
    return res.toString();
  }

  static Map<String, dynamic> listToMap(List<Day> days) {
    Map<String, dynamic> daysMap = Map();

    for (Day day in days) {
      daysMap["${day.number}"] = day.toMap();
    }

    return daysMap;
  }

  Map<String, dynamic> toMap() {
    var expenses = Map<String, Map<String, dynamic>>();
    for (int i = 0; i < _expenses.length; i++) {
      expenses['$i'] = _expenses[i].toJson();
    }

    return <String, dynamic>{
      "number": _number,
      "expenses": expenses,
      "budget": budget,
      "balance": balance,
    };
  }

  static List<Day> fromMap(List<dynamic> days, Month month) {
    var list = List.from(days);
    list.removeWhere((value) => value == null);
    return list.map((value) {
      Map<dynamic, dynamic> daysMap = value;
      return Day.withMap(
        Month(month.yearNumber, month.number),
        daysMap["number"],
        Expense.fromList(daysMap["expenses"]),
        daysMap["budget"].toDouble(),
        daysMap["balance"].toDouble(),
      );
    }).toList();
  }
}
