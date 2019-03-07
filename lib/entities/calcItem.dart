class CalcItem {
  String expression;
  String value;
  String description;
  bool hashFocus;

  CalcItem({
    this.expression = "",
    this.value = "",
    this.description = "",
    this.hashFocus = false,
  });

  bool isEmpty() {
    return expression.isEmpty && value.isEmpty && description.isEmpty;
  }
}
