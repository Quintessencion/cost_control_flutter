import 'package:cost_control/entities/month.dart';

class MainState {
  List<Month> months;

  MainState({this.months});

  factory MainState.initial() {
    return new MainState(months: null);
  }
}
