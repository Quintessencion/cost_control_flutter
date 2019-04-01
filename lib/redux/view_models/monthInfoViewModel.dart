import 'package:cost_control/redux/states/monthInfoState.dart';
import 'package:cost_control/entities/monthMovement.dart';

class MonthInfoViewModel {
  final MonthInfoState state;
  final void Function() onAdd;
  final void Function(MonthMovement) onEdit;
  final void Function(int) onChangeAccumulationPercent;
  final void Function() onLogin;
  final void Function() onLogout;

  MonthInfoViewModel({
    this.state,
    this.onAdd,
    this.onEdit,
    this.onChangeAccumulationPercent,
    this.onLogin,
    this.onLogout,
  });
}
