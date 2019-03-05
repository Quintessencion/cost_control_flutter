import 'package:redux/redux.dart';
import 'package:cost_control/redux/states/monthInfoState.dart';
import 'package:cost_control/redux/actions/monthInfoActions.dart';

final monthInfoReducer = combineReducers<MonthInfoState>([
  TypedReducer<MonthInfoState, SetMonth>((state, action) {
    state.month = action.month;
    return state;
  }),
]);
