import 'package:cost_control/entities/month.dart';
import 'package:cost_control/entities/monthMovement.dart';

class CreateMovement {
  final Month month;
  final int direction;
  final String name;
  final String sum;

  CreateMovement({this.month, this.direction, this.name, this.sum});
}

class EditMovement {
  final Month month;
  final MonthMovement movement;

  EditMovement({this.month, this.movement});
}
