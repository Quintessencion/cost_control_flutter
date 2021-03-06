import 'package:cost_control/entities/month.dart';
import 'package:cost_control/entities/monthMovement.dart';

class CreateMovement {
  final Month month;
  final int direction;
  final String name;
  final double sum;
  final void Function() onComplete;
  final void Function(String) onError;

  CreateMovement({
    this.month,
    this.direction,
    this.name,
    this.sum,
    this.onComplete,
    this.onError,
  });
}

class EditMovement {
  final Month month;
  final MonthMovement movement;
  final void Function() onComplete;
  final void Function(String) onError;

  EditMovement({
    this.month,
    this.movement,
    this.onComplete,
    this.onError,
  });
}

class DeleteMovement {
  final Month month;
  final MonthMovement movement;
  final void Function() onComplete;
  final void Function(String) onError;

  DeleteMovement({
    this.month,
    this.movement,
    this.onComplete,
    this.onError,
  });
}
