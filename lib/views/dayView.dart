import 'package:flutter/material.dart';
import 'package:cost_control/entities/day.dart';
import 'package:cost_control/utils/timeUtils.dart';

class DayView extends StatelessWidget {
  final Day day;
  final Function onClick;

  DayView({this.day, this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: IntrinsicHeight(
          child: Stack(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  getDay(),
                  Container(
                    constraints: BoxConstraints.expand(width: 0.5),
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: getDescription(),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 16),
                alignment: Alignment.topRight,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    Container(
                        width: 132, child: getCoinsText(day.budget.round())),
                    Container(
                        width: 68, child: getCoinsText(day.balance.round())),
                  ],
                ),
              )
            ],
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }

  Widget getDescription() {
    if (day.expenses.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                day.expensesSum.round().toString(),
                style: TextStyle(
                  fontFamily: "SFPro",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(61, 61, 61, 1),
                ),
              ),
              Text(
                " ₽",
                style: TextStyle(
                  fontFamily: "SFPro",
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Color.fromRGBO(61, 61, 61, 1),
                ),
              )
            ],
          ),
          Text(
            day.description,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: "SFPro",
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: Color.fromRGBO(101, 101, 101, 1),
            ),
          ),
        ],
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text(
          "Трат пока нет :)",
          style: TextStyle(
            fontFamily: "SFPro",
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(187, 187, 187, 1),
          ),
        ),
      );
    }
  }

  Widget getCoinsText(int coins) {
    Color color;
    if (coins > 0) {
      color = Color.fromRGBO(80, 190, 50, 1);
    } else {
      color = Color.fromRGBO(255, 70, 70, 1);
    }
    return Text(
      coins.toString(),
      style: TextStyle(
        fontFamily: "SFPro",
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }

  Widget getDay() {
    if (TimeUtils.dayEquals(
        DateTime(day.parent.yearNumber, day.parent.number, day.number),
        DateTime.now())) {
      return getCurrentDay();
    } else {
      if (day.expenses.isNotEmpty) {
        return getBaseDay(Color.fromRGBO(91, 122, 229, 1));
      } else {
        return getBaseDay(Color.fromRGBO(187, 187, 187, 1));
      }
    }
  }

  Widget getCurrentDay() {
    return IntrinsicWidth(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(40, 90, 255, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          getBaseDay(Colors.white),
        ],
      ),
    );
  }

  Widget getBaseDay(Color textColor) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Text(
            day.parent.shortName,
            style: TextStyle(
              fontFamily: "SFPro",
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            day.number.toString(),
            style: TextStyle(
              fontFamily: "SFPro",
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          )
        ],
      ),
    );
  }
}
