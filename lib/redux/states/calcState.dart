class CalcState {
  String expr;
  String value;

  CalcState({this.expr, this.value});

  factory CalcState.initial() {
    return new CalcState(expr: "", value: "0");
  }
}