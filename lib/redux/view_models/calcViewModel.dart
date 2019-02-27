import 'package:cost_control/redux/states/calcState.dart';

class CalcViewModel {
  final CalcState state;
  final void Function(String) onAddSymbol;
  final void Function() onDeleteSymbol;

  CalcViewModel({this.state, this.onAddSymbol, this.onDeleteSymbol});
}
