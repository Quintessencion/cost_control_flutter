import 'package:redux/redux.dart';
import 'package:cost_control/entities/month.dart';
import 'package:cost_control/redux/states/mainState.dart';
import 'package:cost_control/redux/actions/mainActions.dart';

final mainReducer = combineReducers<MainState>([
  TypedReducer<MainState, OnMonthsLoaded>((state, action) {
    state.months = action.months;
    state.currentPage = _getCurrentPage(state, action.months);
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

int _getCurrentPage(MainState state, List<Month> months) {
  if (state.currentPage >= 0) {
    return state.currentPage;
  }
  for (int i = 0; i < months.length; i++) {
    if (months[i].isBelong(DateTime.now())) {
      return i;
    }
  }
  return 0;
}
