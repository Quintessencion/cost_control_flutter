import 'package:cost_control/redux/states/mainState.dart';
import 'package:cost_control/redux/states/monthInfoState.dart';
import 'package:cost_control/redux/states/editState.dart';

class AppState {
  MainState mainState;
  MonthInfoState monthInfoState;
  EditState editState;

  AppState({
    this.mainState,
    this.monthInfoState,
    this.editState,
  });

  factory AppState.initial() {
    return new AppState(
      mainState: MainState.initial(),
      monthInfoState: MonthInfoState.initial(),
      editState: EditState(),
    );
  }
}
