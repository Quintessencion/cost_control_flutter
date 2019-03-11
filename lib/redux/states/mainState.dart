import 'package:cost_control/entities/month.dart';

class MainState {
  List<Month> months;
  int currentPage;
  bool firstSession;

  MainState({this.months, this.currentPage, this.firstSession});

  factory MainState.initial() {
    return new MainState(months: null, currentPage: 0, firstSession: false);
  }
}
