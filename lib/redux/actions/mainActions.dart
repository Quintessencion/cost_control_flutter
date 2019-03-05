import 'package:cost_control/entities/month.dart';

class LoadMonths {
  final int currentPage;

  LoadMonths({this.currentPage = -1});
}

class OnMonthsLoaded {
  final List<Month> months;
  final int currentPage;

  OnMonthsLoaded({this.months, this.currentPage});
}

class SetCurrentPage {
  final int currentPage;

  SetCurrentPage({this.currentPage});
}
