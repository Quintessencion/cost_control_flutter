import 'package:redux/redux.dart';
import 'package:cost_control/redux/states/appState.dart';
import 'package:cost_control/redux/actions/mainActions.dart';
import 'package:cost_control/redux/reducers/mainReducer.dart';
import 'package:cost_control/redux/reducers/monthInfoReducer.dart';
import 'package:cost_control/redux/middlewares/mainMiddleware.dart';
import 'package:cost_control/redux/actions/monthInfoActions.dart';
import 'package:cost_control/redux/middlewares/monthInfoMiddleware.dart';
import 'package:cost_control/redux/reducers/editReducer.dart';
import 'package:cost_control/redux/middlewares/editMiddleware.dart';

Store<AppState> prepareStore() {
  return new Store<AppState>(
      (AppState state, dynamic action) => _getReducers(state, action),
      middleware: _getMiddlewares(),
      initialState: new AppState.initial());
}

AppState _getReducers(AppState state, dynamic action) {
  return new AppState(
    mainState: mainReducer(state.mainState, action),
    monthInfoState: monthInfoReducer(state.monthInfoState, action),
    editState: editReducer(state.editState, action),
  );
}

List<Middleware<AppState>> _getMiddlewares() {
  return [
    TypedMiddleware<AppState, LoadMonths>(MainMiddleware()),
    MonthInfoMiddleware(),
    EditMiddleware(),
  ];
}
