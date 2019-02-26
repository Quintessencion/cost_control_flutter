import 'package:cost_control/entities/month.dart';

class SetMonth {
  final Month month;

  SetMonth({this.month});
}

class ReloadMonth {
  final Month month;

  ReloadMonth({this.month});
}

class SaveAccumulationPercent {
  final Month month;
  final int percent;

  SaveAccumulationPercent({this.month, this.percent});
}
