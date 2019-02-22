import 'package:cost_control/redux/states/monthInfoState.dart';
import 'package:cost_control/entities/monthMovement.dart';

class MonthInfoViewModel {
  final MonthInfoState state;
  final void Function() onAdd;
  final void Function(MonthMovement) onEdit;

  MonthInfoViewModel({this.state, this.onAdd, this.onEdit});
}
