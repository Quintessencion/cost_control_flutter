class Expense {
  String id;
  int year;
  int month;
  int day;
  String description;
  double cost;

  Expense({
    this.id,
    this.year,
    this.month,
    this.day,
    this.description,
    this.cost,
  });

  factory Expense.fromJson(Map<String, dynamic> json) => new Expense(
        id: json["id"],
        year: json["year"],
        month: json["month"],
        day: json["day"],
        description: json["description"],
        cost: json["cost"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "year": year,
        "month": month,
        "day": day,
        "description": description,
        "cost": cost,
      };
}
