import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cost_control/views/baseMonthInfoFragment.dart';
import 'package:cost_control/entities/monthInfo.dart';

class ExpensesFragment extends BaseMonthInfoFragment {
  final MonthInfo _monthInfo;

  ExpensesFragment(this._monthInfo);

  @override
  Widget build(BuildContext context) {
    double height = 50.0 *
        max(
          _monthInfo.expenses.length,
          _monthInfo.incomes.length,
        );

    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 50.0 * _monthInfo.expenses.length,
            child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              itemCount: _monthInfo.expenses.length,
              separatorBuilder: (BuildContext context, int i) {
                return getDivider();
              },
              itemBuilder: (context, i) {
                return getContainerLine(
                  _monthInfo.expenses[i].name,
                  _monthInfo.expenses[i].sum,
                );
              },
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
                  _monthInfo.accumulationPercentage.toString(),
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
      constraints: BoxConstraints.expand(height: height + 50),
    );
  }
}
