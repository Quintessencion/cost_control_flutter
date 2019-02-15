import 'package:flutter/material.dart';
import 'package:cost_control/views/DayView.dart';
import 'package:cost_control/entities/month.dart';
import 'package:cost_control/entities/day.dart';

class MonthFragment extends StatefulWidget {
  final Month month;

  MonthFragment(this.month);

  @override
  _MonthFragmentState createState() => _MonthFragmentState();
}

class _MonthFragmentState extends State<MonthFragment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      constraints: BoxConstraints.expand(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20, top: 26),
              child: Text(
                "Остаток на сегодня:",
                style: TextStyle(
                  fontFamily: "SFPro",
                  fontSize: 18,
                  color: Color.fromRGBO(122, 149, 242, 1),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "518 ₽",
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontSize: 78,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, top: 16),
                  child: Container(
                    width: 40,
                    height: 40,
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      foregroundColor: Color.fromRGBO(244, 93, 1, 1),
                      child: Icon(Icons.add),
                      onPressed: null,
                    ),
                  ),
                )
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(91, 122, 229, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 86),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "ОБЩИЕ ТРАТЫ:",
                                style: TextStyle(
                                  fontFamily: "SFPro",
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(top: 4)),
                              Text(
                                "300 ₽",
                                style: TextStyle(
                                  fontFamily: "SFPro",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(child: Container()),
                        Container(
                          width: 152,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "ОБЩЕЕ САЛЬДО:",
                                style: TextStyle(
                                  fontFamily: "SFPro",
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(top: 4)),
                              Text(
                                "8 700 ₽",
                                style: TextStyle(
                                  fontFamily: "SFPro",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: widget.month.days
                        .map((day) => DayView(widget.month, day))
                        .toList(),
                  ),
                  Padding(padding: EdgeInsets.only(top: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
