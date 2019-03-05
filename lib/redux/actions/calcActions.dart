import 'package:cost_control/entities/day.dart';

class AddSymbol {
  final String symbol;

  AddSymbol({this.symbol});
}

class DeleteSymbol {}

class ChangeDescription {
  final String description;

  ChangeDescription({this.description});
}

class SetCurrentPage {
  final int currentPage;

  SetCurrentPage({this.currentPage});
}

class DeleteCurrentPage {
  final Function(int newCurrentPage) onComplete;

  DeleteCurrentPage({this.onComplete});
}

class InitState {
  final Day day;

  InitState({this.day});
}

class SaveDay {
  final Day day;
  final void Function() onComplete;
  final void Function(String) onError;

  SaveDay({this.day, this.onComplete, this.onError});
}
