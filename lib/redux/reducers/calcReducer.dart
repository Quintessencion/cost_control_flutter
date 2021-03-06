import 'dart:math';
import 'package:redux/redux.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:cost_control/utils/moneyUtils.dart';
import 'package:cost_control/redux/states/calcState.dart';
import 'package:cost_control/redux/actions/calcActions.dart';
import 'package:cost_control/entities/calcItem.dart';

final calcReducer = combineReducers<CalcState>([
  TypedReducer<CalcState, InitState>((state, action) {
    state.initExpenses = List.from(action.day.expenses);
    state.expenses = action.day.expenses.map((e) {
      return CalcItem(
        expression: MoneyUtils.calc(e.cost),
        value: e.cost,
        description: e.description,
      );
    }).toList();
    state.currentPage = 0;
    state.expenses.insert(0, CalcItem());
    return state;
  }),
  TypedReducer<CalcState, AddSymbol>((state, action) {
    bool isChangedPage = _checkOnAddPage(state);
    CalcItem item = state.expenses[state.currentPage];
    item.expression += action.symbol;
    item.value = _evaluate(item.expression);
    if (isChangedPage) {
      action.onChangeTab(state.currentPage);
    }
    return state;
  }),
  TypedReducer<CalcState, DeleteSymbol>((state, action) {
    CalcItem item = state.expenses[state.currentPage];
    if (item.expression.isNotEmpty) {
      item.expression =
          item.expression.substring(0, item.expression.length - 1);
    }
    item.value = _evaluate(item.expression);
    return state;
  }),
  TypedReducer<CalcState, SetCurrentTab>((state, action) {
    state.currentPage = action.currentTab;
    return state;
  }),
  TypedReducer<CalcState, ChangeDescription>((state, action) {
    bool isChangedPage = _checkOnAddPage(state);
    CalcItem item = state.expenses[state.currentPage];
    item.description = action.description;
    if (isChangedPage) {
      action.onChangeTab(state.currentPage);
    }
    return state;
  }),
  TypedReducer<CalcState, DeleteCurrentTab>((state, action) {
    List<CalcItem> items = state.expenses;
    if (state.currentPage != 0) {
      items.removeAt(state.currentPage);
      if (state.currentPage == 1) {

      }
      if (state.currentPage < items.length - 1) {
        state.currentPage++;
      }
      state.currentPage = min(state.currentPage, state.expenses.length - 1);
      action.onComplete(state.currentPage);
    }
    return state;
  }),
  TypedReducer<CalcState, ClearFocus>((state, action) {
    for (CalcItem item in state.expenses) {
      item.hashFocus = false;
    }
    return state;
  }),
]);

double _evaluate(String str) {
  if (str.isEmpty) {
    return 0;
  }
  try {
    String lastChar = str[str.length - 1];
    if (lastChar == '*' ||
        lastChar == '/' ||
        lastChar == '+' ||
        lastChar == '-') {
      str = str.substring(0, str.length - 1);
    }
    Parser p = new Parser();
    Expression e = p.parse(str);
    return e.evaluate(EvaluationType.REAL, ContextModel());
  } catch (e) {
    return 0;
  }
}

bool _checkOnAddPage(CalcState state) {
  if (state.currentPage == 0) {
    state.expenses.insert(0, CalcItem());
    state.currentPage++;
    return true;
  }
  return false;
}
