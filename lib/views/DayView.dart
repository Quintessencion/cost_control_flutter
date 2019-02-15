import 'package:flutter/material.dart';
import 'package:cost_control/entities/month.dart';
import 'package:cost_control/entities/day.dart';

class DayView extends StatelessWidget {
  final Month month;
  final Day day;

  DayView(this.month, this.day);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16, left: 16, right: 16),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  Text(
                    month.shortName,
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(91, 122, 229, 1),
                    ),
                  ),
                  Text(
                    day.number.toString(),
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(91, 122, 229, 1),
                    ),
                  )
                ],
              ),
            ),
            Container(
              constraints: BoxConstraints.expand(width: 1),
              color: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "700 ₽",
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(61, 61, 61, 1),
                    ),
                  ),
                  Text(
                    "Кино, бургеры",
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Color.fromRGBO(101, 101, 101, 1),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: Container()),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Stack(
                alignment: Alignment.topRight,
                children: <Widget>[
                  Container(
                    width: 132,
                    child: Text(
                      "-104",
                      style: TextStyle(
                        fontFamily: "SFPro",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(255, 70, 70, 1),
                      ),
                    ),
                  ),
                  Container(
                    width: 68,
                    child: Text(
                      "-804",
                      style: TextStyle(
                        fontFamily: "SFPro",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(255, 70, 70, 1),
                      ),
                    ),
                  ),
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
    );
  }
}
