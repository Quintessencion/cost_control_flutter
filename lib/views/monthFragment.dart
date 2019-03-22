import 'package:flutter/material.dart';
import 'package:cost_control/utils/moneyUtils.dart';
import 'package:cost_control/views/dayView.dart';
import 'package:cost_control/entities/month.dart';
import 'package:cost_control/entities/day.dart';
import 'package:cost_control/baseScreenState.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cost_control/redux/actions/mainActions.dart';
import 'package:cost_control/utils/purchasesManager.dart';

class MonthFragment extends StatefulWidget {
  final Month month;
  final bool isCurrent;
  final Function(Day day) onDayClick;

  MonthFragment({this.month, this.isCurrent, this.onDayClick});

  @override
  _MonthFragmentState createState() => _MonthFragmentState();
}

class _MonthFragmentState extends BaseScreenState<MonthFragment> {
  ScrollController _scrollController;

  @override
  void initState() {
    DateTime now = DateTime.now();
    if (now.year == widget.month.yearNumber &&
        now.month == widget.month.number) {
      int index = now.day - 1;
      double offset = DayView.HEIGHT * index + (16 * index - 1);
      _scrollController = new ScrollController(initialScrollOffset: offset);
    } else {
      _scrollController = new ScrollController();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.month.isAvailable ? _getView() : _getOfferPurchase();
  }

  Widget _getView() {
    return Container(
      color: Theme.of(context).primaryColor,
      constraints: BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20, top: 26),
            child: Text(
              _getTitle(),
              style: TextStyle(
                fontFamily: "SFPro",
                fontSize: 18,
                color: Color.fromRGBO(122, 149, 242, 1),
              ),
            ),
          ),
          _getHeader(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(91, 122, 229, 1),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                                    MoneyUtils.standard(
                                        widget.month.expensesSum),
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
                                    MoneyUtils.standard(
                                        widget.month.generalBalance),
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
                      controller: _scrollController,
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

  Widget _getOfferPurchase() {
    return Container(
      color: Theme.of(context).primaryColor,
      constraints: BoxConstraints.expand(),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "В бесплатной версии доступен только один месяц.",
              style: TextStyle(
                fontFamily: "SFPro",
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              constraints: BoxConstraints.expand(height: 52),
              child: RaisedButton(
                child: Text(
                  "Купить",
                  style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(91, 122, 229, 1),
                  ),
                ),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                onPressed: () async {
                  try {
                    PurchasesManager manager = await PurchasesManager.instance;
                    manager.buyNextMonth();
                  } catch (error) {
                    int a = 0;
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getHeader() {
    List<Widget> elements = new List();

    elements.add(Flexible(
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: AutoSizeText.rich(
            TextSpan(children: <TextSpan>[
              TextSpan(
                text: MoneyUtils.standard(widget.month.balanceToCurrentDay),
                style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 78,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              ),
              TextSpan(
                text: " ₽",
                style: TextStyle(
                    fontFamily: "SFPro",
                    fontSize: 78,
                    color: Colors.white,
                    fontWeight: FontWeight.w100),
              ),
            ]),
            maxLines: 1,
            minFontSize: 1,
          ),
        )));

    if (widget.isCurrent) {
      int currentDayIndex = DateTime.now().day - 1;
      Day currentDay = widget.month.days[currentDayIndex];
      elements.add(Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          width: 40,
          height: 40,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            foregroundColor: Color.fromRGBO(244, 93, 1, 1),
            child: Icon(Icons.add),
            onPressed: () => widget.onDayClick(currentDay),
          ),
        ),
      ));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: elements,
    );
  }

  String _getTitle() {
    if (widget.isCurrent) {
      return "Остаток на сегодня:";
    } else {
      return "Остаток на ${widget.month.name} ${widget.month.yearNumber}:";
    }
  }
}
