import 'package:cost_control/entities/monthMovement.dart';

class MonthInfo {
  List<MonthMovement> incomes;
  List<MonthMovement> expenses;
  int accumulationPercentage;

  MonthInfo(this.incomes, this.expenses, this.accumulationPercentage);
}
