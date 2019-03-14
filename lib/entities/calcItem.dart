class CalcItem {
  static const double _ERROR = 0.01;
  String expression;
  double value;
  String description;
  bool hashFocus;

  CalcItem({
    this.expression = "",
    this.value = 0,
    this.description = "",
    this.hashFocus = false,
  });

  bool isEmpty() {
    return value < _ERROR || value == double.infinity;
  }
}
