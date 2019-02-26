import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cost_control/entities/monthMovement.dart';
import 'package:cost_control/views/baseMonthInfoFragment.dart';
import 'package:cost_control/entities/month.dart';

class IncomesFragment extends BaseMonthInfoFragment {
  final Month _month;
  final void Function(MonthMovement) onEditIncome;

  IncomesFragment(this._month, {this.onEditIncome});

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
              height: ITEM_HEIGHT * _month.incomes.length,
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                itemCount: _month.incomes.length,
                separatorBuilder: (BuildContext context, int i) {
                  return getDivider();
                },
                itemBuilder: (context, i) {
                  return InkWell(
                      child: getContainerLine(
                        _month.incomes[i].name,
                        _month.incomes[i].sum,
                      ),
                      onTap: () => onEditIncome(_month.incomes[i]));
                },
              ),
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
                  _month.monthIncomesSum.round().toString(),
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
