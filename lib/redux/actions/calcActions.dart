import 'package:cost_control/entities/day.dart';

class AddSymbol {
  final String symbol;
  final Function(int newCurrentTab) onChangeTab;

  AddSymbol({this.symbol, this.onChangeTab});
}

class DeleteSymbol {}

class ChangeDescription {
  final String description;
  final Function(int newCurrentTab) onChangeTab;

  ChangeDescription({this.description, this.onChangeTab});
}

class SetCurrentTab {
  final int currentTab;

  SetCurrentTab({this.currentTab});
}

class DeleteCurrentTab {
  final Function(int newCurrentTab) onComplete;

  DeleteCurrentTab({this.onComplete});
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

class FirebaseSaveDay {
  final Day day;

  FirebaseSaveDay({this.day});
}

class SaveDays {
  final List<Day> days;
  final void Function() onComplete;
  final void Function(String) onError;

  SaveDays({this.days, this.onComplete, this.onError});
}

class ClearFocus {}
