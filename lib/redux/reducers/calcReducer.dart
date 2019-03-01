import 'package:redux/redux.dart';
import 'package:cost_control/redux/states/calcState.dart';
import 'package:cost_control/redux/actions/calcActions.dart';
import 'package:cost_control/entities/calcItem.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:intl/intl.dart';

final double error = 0.01;

final calcReducer = combineReducers<CalcState>([
  TypedReducer<CalcState, AddSymbol>((state, action) {
    CalcItem item = state.expenses[state.currentPage];
    item.expression += action.symbol;
    item.value = _evaluate(item.expression);
    return state;
  }),
  TypedReducer<CalcState, DeleteSymbol>((state, action) {
    CalcItem item = state.expenses[state.currentPage];
    if (item.expression.isNotEmpty) {
      item.expression = item.expression.substring(0, item.expression.length - 1);
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
    return NumberFormat("0.##").format(evaluated);
  } catch (e) {
    return "";
  }
}
