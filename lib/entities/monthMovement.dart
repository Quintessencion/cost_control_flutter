class MonthMovement {
  String id;
  int direction;
  String monthId;
  String name;
  double sum;

  MonthMovement({this.id, this.direction, this.monthId, this.name, this.sum});

  factory MonthMovement.fromJson(Map<String, dynamic> json) =>
      new MonthMovement(
        id: json["id"],
        direction: json["direction"],
        monthId: json["monthId"],
        name: json["name"],
        sum: json["sum"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "direction": direction,
        "monthId": monthId,
        "name": name,
        "sum": sum,
      };
}
