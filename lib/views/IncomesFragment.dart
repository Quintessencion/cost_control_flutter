import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cost_control/views/baseMonthInfoFragment.dart';
import 'package:cost_control/entities/monthInfo.dart';

class IncomesFragment extends BaseMonthInfoFragment {
  final MonthInfo _monthInfo;

  IncomesFragment(this._monthInfo);

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
            height: 50.0 * _monthInfo.incomes.length,
            child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              itemCount: _monthInfo.incomes.length,
              separatorBuilder: (BuildContext context, int i) {
                return getDivider();
              },
              itemBuilder: (context, i) {
                return getContainerLine(
                  _monthInfo.incomes[i].name,
                  _monthInfo.incomes[i].sum,
                );
              },
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
                  "87 300",
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
