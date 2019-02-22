import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cost_control/views/baseMonthInfoFragment.dart';
import 'package:cost_control/entities/month.dart';
import 'package:cost_control/entities/monthMovement.dart';

class ExpensesFragment extends BaseMonthInfoFragment {
  final Month _month;
  final void Function(MonthMovement) onEditExpense;

  ExpensesFragment(this._month, {this.onEditExpense});

  @override
  Widget build(BuildContext context) {
    double height = ITEM_HEIGHT *
        max(
          _month.expenses.length,
          _month.incomes.length,
        );

    return Container(
      child: Column(
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: Container(
              height: ITEM_HEIGHT * _month.expenses.length,
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                itemCount: _month.expenses.length,
                separatorBuilder: (BuildContext context, int i) {
                  return getDivider();
                },
                itemBuilder: (context, i) {
                  return InkWell(
                      child: getContainerLine(
                        _month.expenses[i].name,
                        _month.expenses[i].sum,
                      ),
                      onTap: () => onEditExpense(_month.expenses[i]));
                },
              ),
            ),
          ),
          getDivider(),
          Padding(
            padding: EdgeInsets.only(top: 16, bottom: 12, left: 20, right: 20),
            child: Row(
              children: <Widget>[
                Text(
                  "Откладываем",
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Color.fromRGBO(101, 101, 101, 1),
                  ),
                ),
                Expanded(child: Container()),
                Text(
                  _month.accumulationPercentage.toString(),
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(91, 122, 229, 1),
                  ),
                ),
                Text(
                  " %",
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Color.fromRGBO(91, 122, 229, 1),
                  ),
                ),
              ],
            ),
          ),
          getDivider(),
          Expanded(child: Container()),
          Padding(
            padding: EdgeInsets.only(top: 16, bottom: 12, left: 20, right: 20),
            child: Row(
              children: <Widget>[
                Text(
                  "Всего",
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(61, 61, 61, 1),
                  ),
                ),
                Expanded(child: Container()),
                Text(
                  "37 600",
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(61, 61, 61, 1),
                  ),
                ),
                Text(
                  " ₽",
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: Color.fromRGBO(61, 61, 61, 1),
                  ),
                )
              ],
            ),
          ),
          getDivider(),
        ],
      ),
      constraints: BoxConstraints.expand(height: height + ITEM_HEIGHT),
    );
  }
}
