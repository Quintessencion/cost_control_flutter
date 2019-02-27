import 'package:redux/redux.dart';
import 'package:cost_control/redux/states/calcState.dart';
import 'package:cost_control/redux/actions/calcActions.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:intl/intl.dart';

final double error = 0.01;

final calcReducer = combineReducers<CalcState>([
  TypedReducer<CalcState, AddSymbol>((state, action) {
    state.expr += action.symbol;
    state.value = evaluate(state.expr);
    return state;
  }),
  TypedReducer<CalcState, DeleteSymbol>((state, action) {
    if (state.expr.isNotEmpty) {
      state.expr = state.expr.substring(0, state.expr.length - 1);
      state.value = evaluate(state.expr);
    } else {
      state.value = "0";
    }
    return state;
  })
]);

String evaluate(String str) {
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
    if ((evaluated * 100 - evaluated.round() * 100).abs() < error) {
      return evaluated.round().toString();
    }
    return evaluated.toStringAsFixed(2);
  } catch (e) {
    return "";
  }
}
