import 'package:cost_control/entities/month.dart';

class MonthInfoState {
  Month month;

  MonthInfoState({this.month});

  factory MonthInfoState.initial() {
    return new MonthInfoState(month: null);
  }
}
