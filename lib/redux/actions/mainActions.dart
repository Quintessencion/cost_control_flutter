import 'package:cost_control/entities/month.dart';

class LoadMonths {}

class OnMonthsLoaded {
  final List<Month> months;

  OnMonthsLoaded({this.months});
}
