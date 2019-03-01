class CalcItem {
  String expression;
  String value;
  String description;

  CalcItem({
    this.expression = "",
    this.value = "",
    this.description = "",
  });

  bool isEmpty() {
    return expression.isEmpty && value.isEmpty && description.isEmpty;
  }
}
