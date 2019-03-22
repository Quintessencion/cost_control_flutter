import 'package:cost_control/entities/month.dart';

class LoadMonths {}

class OnMonthsLoaded {
  final List<Month> months;

  OnMonthsLoaded({this.months});
}

class SetCurrentPage {
  final int currentPage;

  SetCurrentPage({this.currentPage});
}

class SetFirstScreenVisibility {
  final bool visibility;

  SetFirstScreenVisibility({this.visibility});
}

class PurchaseNextMonth {
  final void Function(String) onResult;

  PurchaseNextMonth({this.onResult});
}

class RestorePurchase {
  final void Function(String) onResult;

  RestorePurchase({this.onResult});
}

