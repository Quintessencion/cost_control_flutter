import 'package:flutter/material.dart';
import 'package:cost_control/entities/day.dart';
import 'package:cost_control/utils/timeUtils.dart';

class DayView extends StatelessWidget {
  static const double HEIGHT = 68;
  final Day day;
  final Function onClick;

  DayView({this.day, this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        height: HEIGHT,
        child: Stack(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _getDay(),
                Container(
                  constraints: BoxConstraints.expand(width: 0.5),
                  color: Colors.grey,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
                    child: _getDescription(),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.topRight,
              child: Stack(
                alignment: Alignment.topRight,
                children: _getRightPanel(),
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }

  List<Widget> _getRightPanel() {
    if (_isCurrentDay()) {
      return <Widget>[
        Container(
            width: 132,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _getCoinsText(day.budget.round()),
                Expanded(child: Container()),
                Text(
                  "ДЕНЬ",
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 10,
                    color: Color.fromRGBO(187, 187, 187, 1),
                  ),
                ),
              ],
            )),
        Container(
            width: 68,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _getCoinsText(day.balance.round()),
                Expanded(child: Container()),
                Text(
                  "САЛЬДО",
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 10,
                    color: Color.fromRGBO(187, 187, 187, 1),
                  ),
                ),
              ],
            ))
      ];
    } else {
      return <Widget>[
        Container(width: 132, child: _getCoinsText(day.budget.round())),
        Container(width: 68, child: _getCoinsText(day.balance.round())),
      ];
    }
  }

  Widget _getDescription() {
    if (day.expenses.isNotEmpty) {
      return Column(
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
          Expanded(child: Container()),
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
      return Text(
        "Трат пока нет :)",
        style: TextStyle(
          fontFamily: "SFPro",
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(187, 187, 187, 1),
        ),
      );
    }
  }

  Widget _getCoinsText(int coins) {
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

  Widget _getDay() {
    if (_isCurrentDay()) {
      return _getCurrentDay();
    } else {
      if (day.expenses.isNotEmpty) {
        return _getBaseDay(Color.fromRGBO(91, 122, 229, 1));
      } else {
        return _getBaseDay(Color.fromRGBO(187, 187, 187, 1));
      }
    }
  }

  Widget _getCurrentDay() {
    return IntrinsicWidth(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(40, 90, 255, 1),
              borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
            ),
          ),
          _getBaseDay(Colors.white),
        ],
      ),
    );
  }

  Widget _getBaseDay(Color textColor) {
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
          Expanded(child: Container()),
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

  bool _isCurrentDay() {
    return TimeUtils.dayEquals(
        DateTime(day.parent.yearNumber, day.parent.number, day.number),
        DateTime.now());
  }
}
