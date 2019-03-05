import 'package:cost_control/redux/states/mainState.dart';
import 'package:cost_control/entities/day.dart';

class MainViewModel {
  final MainState state;
  final void Function() onOpenInfoScreen;
  final void Function(Day day) onOpenCalcScreen;
  final void Function(int index) onPageChange;

  MainViewModel({
    this.state,
    this.onOpenInfoScreen,
    this.onOpenCalcScreen,
    this.onPageChange,
  });
}
