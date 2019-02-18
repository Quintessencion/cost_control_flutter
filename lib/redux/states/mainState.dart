import 'package:cost_control/entities/month.dart';

class MainState {
  List<Month> months;
  int currentPage;

  MainState({this.months, this.currentPage});

  factory MainState.initial() {
    return new MainState(months: null, currentPage: 0);
  }
}
