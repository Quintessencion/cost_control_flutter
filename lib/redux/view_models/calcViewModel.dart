import 'package:cost_control/redux/states/calcState.dart';

class CalcViewModel {
  final CalcState state;
  final void Function(String) onAddSymbol;
  final void Function() onDeleteSymbol;
  final void Function(String) onChangeDescription;
  final void Function(int) onPageChange;

  CalcViewModel({
    this.state,
    this.onAddSymbol,
    this.onDeleteSymbol,
    this.onChangeDescription,
    this.onPageChange,
  });
}
