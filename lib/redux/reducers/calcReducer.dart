import 'package:redux/redux.dart';
import 'package:cost_control/redux/states/calcState.dart';
import 'package:cost_control/redux/actions/calcActions.dart';

final calcReducer = combineReducers<CalcState>([
  TypedReducer<CalcState, AddSymbol>((state, action) {
    state.expr += action.symbol;
    return state;
  }),
  TypedReducer<CalcState, DeleteSymbol>((state, action) {
    if (state.expr.isNotEmpty) {
      state.expr = state.expr.substring(0, state.expr.length - 1);
    }
    return state;
  })
]);
