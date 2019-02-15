import 'package:cost_control/entities/day.dart';

class Month {
  int number;
  String name;
  String shortName;
  List<Day> days;

  Month({this.number, this.name, this.shortName, this.days});
}
