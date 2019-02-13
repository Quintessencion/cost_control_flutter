class Month {
  int number;
  String name;

  Month({this.number, this.name});

  static List<Month> fromJsonArray(List<dynamic> json) {
    if (json == null) {
      return new List();
    }
    List<Month> res = new List();
    for (dynamic room in json) {
      res.add(Month.fromJson(room));
    }
    return res;
  }

  factory Month.fromJson(Map<String, dynamic> json) => new Month(
        number: json["number"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "name": name,
      };
}
