import 'package:redux/redux.dart';
import 'package:cost_control/redux/states/mainState.dart';
import 'package:cost_control/redux/actions/mainActions.dart';

final mainReducer = combineReducers<MainState>([
  TypedReducer<MainState, OnMonthsLoaded>((state, action) {
    state.months = action.months;
    state.currentPage = action.currentPage;
    return state;
  }),
  TypedReducer<MainState, SetCurrentPage>((state, action) {
    state.currentPage = action.currentPage;
    return state;
  }),
  TypedReducer<MainState, SetFirstScreenVisibility>((state, action) {
    state.firstSession = action.visibility;
    return state;
  }),
]);
