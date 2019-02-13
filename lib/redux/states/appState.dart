import 'package:cost_control/redux/states/mainState.dart';

class AppState {
  MainState mainState;

  AppState({
    this.mainState,
  });

  factory AppState.initial() {
    return new AppState(
      mainState: MainState.initial(),
    );
  }
}
