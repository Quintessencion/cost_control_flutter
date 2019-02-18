import 'package:cost_control/entities/expense.dart';
import 'package:cost_control/entities/month.dart';

class Day {
  Month _parent;
  int _number;
  List<Expense> _expenses;
  int balance;
  int balanceToDay;

  Day(this._parent, this._number) {
    _expenses = new List();
  }

  Month get parent => _parent;
  int get number => _number;
  List<Expense> get expenses => _expenses;

  int get expensesSum {
    int res = 0;
    for (Expense e in _expenses) {
      res += e.cost;
    }
    return res;
  }

  String get description {
    StringBuffer res = new StringBuffer();
    for (int i = 0; i < _expenses.length; i++) {
      String description = _expenses[i].description.toLowerCase();
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
}
