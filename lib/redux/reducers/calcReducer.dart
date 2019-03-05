import 'package:redux/redux.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:cost_control/utils/moneyUtils.dart';
import 'package:cost_control/redux/states/calcState.dart';
import 'package:cost_control/redux/actions/calcActions.dart';
import 'package:cost_control/entities/calcItem.dart';

final calcReducer = combineReducers<CalcState>([
  TypedReducer<CalcState, InitState>((state, action) {
    state.expenses = action.day.expenses.map((e) {
      String cost = MoneyUtils.twoDigits(e.cost);
      return CalcItem(
        expression: cost,
        value: cost,
        description: e.description,
      );
    }).toList();
    state.expenses.add(CalcItem());
    return state;
  }),
  TypedReducer<CalcState, AddSymbol>((state, action) {
    CalcItem item = state.expenses[state.currentPage];
    item.expression += action.symbol;
    item.value = _evaluate(item.expression);
    _checkOnNeedAddItem(state);
    return state;
  }),
  TypedReducer<CalcState, DeleteSymbol>((state, action) {
    CalcItem item = state.expenses[state.currentPage];
    if (item.expression.isNotEmpty) {
      item.expression =
          item.expression.substring(0, item.expression.length - 1);
    }
    item.value = _evaluate(item.expression);
    return state;
  }),
  TypedReducer<CalcState, SetCurrentPage>((state, action) {
    state.currentPage = action.currentPage;
    return state;
  }),
  TypedReducer<CalcState, ChangeDescription>((state, action) {
    CalcItem item = state.expenses[state.currentPage];
    item.description = action.description;
    _checkOnNeedAddItem(state);
    return state;
  }),
  TypedReducer<CalcState, DeleteCurrentPage>((state, action) {
    List<CalcItem> items = state.expenses;
    if (state.currentPage != items.length - 1) {
      items.removeAt(state.currentPage);
      if (state.currentPage > 0) {
        state.currentPage--;
      }
      action.onComplete(state.currentPage);
    }
    return state;
  }),
]);

String _evaluate(String str) {
  if (str.isEmpty) {
    return "0";
  }
  try {
    String lastChar = str[str.length - 1];
    if (lastChar == '*' ||
        lastChar == '/' ||
        lastChar == '+' ||
        lastChar == '-') {
      str = str.substring(0, str.length - 1);
    }
    Parser p = new Parser();
    Expression e = p.parse(str);
    double evaluated = e.evaluate(EvaluationType.REAL, ContextModel());
    return MoneyUtils.twoDigits(evaluated);
  } catch (e) {
    return "";
  }
}

void _checkOnNeedAddItem(CalcState state) {
  CalcItem lastItem = state.expenses.last;
  if (!lastItem.isEmpty()) {
    state.expenses.add(CalcItem());
  }
}