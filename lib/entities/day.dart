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

  toMap() {
    var expenses = Map<String, Map<String, dynamic>>();
    for (int i = 0; i < _expenses.length; i++) {
      expenses['$i'] = _expenses[i].toJson();
    }

    return <String, dynamic>{
      "month": _parent.toJson(),
      "number": _number,
      "expenses": expenses,
      "budget": budget,
      "balance": balance,
    };
  }
}
