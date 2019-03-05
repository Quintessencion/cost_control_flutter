import 'package:cost_control/redux/states/mainState.dart';
import 'package:cost_control/redux/states/monthInfoState.dart';
import 'package:cost_control/redux/states/editState.dart';
import 'package:cost_control/redux/states/calcState.dart';

class AppState {
  MainState mainState;
  MonthInfoState monthInfoState;
  EditState editState;
  CalcState calcState;

  AppState({
    this.mainState,
    this.monthInfoState,
    this.editState,
    this.calcState,
  });

  factory AppState.initial() {
    return new AppState(
      mainState: MainState.initial(),
      monthInfoState: MonthInfoState.initial(),
      editState: EditState(),
      calcState: CalcState.initial(),
    );
  }
}
