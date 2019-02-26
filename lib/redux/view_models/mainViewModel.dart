import 'package:cost_control/redux/states/mainState.dart';

class MainViewModel {
  final MainState state;
  final void Function() onOpenInfoScreen;
  final void Function(int index) onPageChange;

  MainViewModel({this.state, this.onOpenInfoScreen, this.onPageChange});
}
