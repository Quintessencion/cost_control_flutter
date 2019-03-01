import 'package:flutter/material.dart';
import 'package:cost_control/views/dayView.dart';
import 'package:cost_control/entities/month.dart';
import 'package:cost_control/entities/day.dart';
import 'package:cost_control/baseScreenState.dart';

class MonthFragment extends StatefulWidget {
  final Month month;
  final bool isCurrent;
  final Function(Day day) onDayClick;

  MonthFragment({this.month, this.isCurrent, this.onDayClick});

  @override
  _MonthFragmentState createState() => _MonthFragmentState();
}

class _MonthFragmentState extends BaseScreenState<MonthFragment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      constraints: BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20, top: 26),
            child: Text(
              getTitle(),
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
                  widget.month.balanceToCurrentDay.round().toString(),
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 78,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                " ₽",
                style: TextStyle(
                  fontFamily: "SFPro",
                  fontSize: 78,
                  fontWeight: FontWeight.w100,
                  color: Colors.white,
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
                    onPressed: () => widget.onDayClick(widget.month.days[0]),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: Container(
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
                    padding: EdgeInsets.symmetric(vertical: 16),
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
                              Row(
                                children: <Widget>[
                                  Text(
                                    widget.month.expensesSum.round().toString(),
                                    style: TextStyle(
                                      fontFamily: "SFPro",
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    " ₽",
                                    style: TextStyle(
                                      fontFamily: "SFPro",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
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
                              Row(
                                children: <Widget>[
                                  Text(
                                    widget.month.generalBalance
                                        .round()
                                        .toString(),
                                    style: TextStyle(
                                      fontFamily: "SFPro",
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    " ₽",
                                    style: TextStyle(
                                      fontFamily: "SFPro",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.only(bottom: 16),
                      itemCount: widget.month.days.length,
                      separatorBuilder: (BuildContext context, int i) {
                        return Divider(height: 16, color: Colors.transparent);
                      },
                      itemBuilder: (context, index) {
                        return DayView(
                          day: widget.month.days[index],
                          onClick: () => widget.onDayClick(
                                widget.month.days[index],
                              ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getTitle() {
    if (widget.isCurrent) {
      return "Остаток на сегодня:";
    } else {
      return "Остаток на ${widget.month.name} ${widget.month.yearNumber}:";
    }
  }
}
