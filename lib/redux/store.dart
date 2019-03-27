import 'package:cost_control/redux/middlewares/remoteDatabaseMiddleware.dart';
import 'package:redux/redux.dart';
import 'package:cost_control/redux/states/appState.dart';
import 'package:cost_control/redux/actions/mainActions.dart';
import 'package:cost_control/redux/reducers/mainReducer.dart';
import 'package:cost_control/redux/reducers/monthInfoReducer.dart';
import 'package:cost_control/redux/middlewares/mainMiddleware.dart';
import 'package:cost_control/redux/middlewares/monthInfoMiddleware.dart';
import 'package:cost_control/redux/middlewares/editMiddleware.dart';
import 'package:cost_control/redux/actions/calcActions.dart';
import 'package:cost_control/redux/reducers/calcReducer.dart';
import 'package:cost_control/redux/middlewares/calcMiddleware.dart';

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
    calcState: calcReducer(state.calcState, action),
  );
}

List<Middleware<AppState>> _getMiddlewares() {
  return [
    RemoteDatabaseMiddleware(),
    MainMiddleware(),
    MonthInfoMiddleware(),
    EditMiddleware(),
    TypedMiddleware<AppState, SaveDay>(CalcMiddleware()),
  ];
}
