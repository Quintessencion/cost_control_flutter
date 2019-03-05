import 'package:cost_control/redux/states/editState.dart';

class EditViewModel {
  final EditState state;
  final void Function() onSave;
  final void Function() onDelete;

  EditViewModel({this.state, this.onSave, this.onDelete});
}
