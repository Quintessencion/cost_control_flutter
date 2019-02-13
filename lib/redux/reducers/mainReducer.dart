import 'package:redux/redux.dart';
import 'package:cost_control/redux/states/mainState.dart';
import 'package:cost_control/redux/actions/mainActions.dart';

final mainReducer = combineReducers<MainState>([
  TypedReducer<MainState, OnMonthsLoaded>((state, action) {
    state.months = action.months;
    return state;
  })
]);
