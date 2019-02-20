import 'package:flutter/material.dart';
import 'package:cost_control/views/IncomesFragment.dart';
import 'package:cost_control/views/expensesFragment.dart';
import 'package:cost_control/entities/monthInfo.dart';
import 'package:cost_control/entities/monthMovement.dart';

class MonthInfoScreen extends StatefulWidget {
  @override
  _MonthInfoScreenState createState() => _MonthInfoScreenState();
}

class _MonthInfoScreenState extends State<MonthInfoScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  MonthInfo _monthInfo;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    //Заглушка:
    _monthInfo = MonthInfo(
      [
        MonthMovement(0, "Зарплата", 15500),
        MonthMovement(0, "Сдача в аренду", 517),
        MonthMovement(0, "Бизнес", 42500),
        MonthMovement(0, "Накопления", 510000),
      ],
      [
        MonthMovement(0, "Квартира", 15500),
        MonthMovement(0, "Стоянка", 517),
        MonthMovement(0, "Спорт", 42500),
      ],
      15,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Январь 2019",
            style: TextStyle(
              fontFamily: "SFPro",
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            )),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Image.asset("assets/images/calendar.png",
                width: 20.0, height: 20.0),
          ),
        ],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(91, 122, 229, 1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 4,
                separatorBuilder: (BuildContext context, int i) {
                  return Container(
                    constraints: BoxConstraints.expand(height: 0.5),
                    color: Color.fromRGBO(122, 149, 242, 1),
                  );
                },
                itemBuilder: (context, index) {
                  return [
                    getLine("Доход", "15 500"),
                    getLine("Бюджет на день", "517"),
                    getLine("Накопление в месяц", "42 500"),
                    getLine("Накопление в год", "510 000")
                  ][index];
                },
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 36),
                constraints: BoxConstraints.expand(
                    height: 50.0 * _monthInfo.incomes.length + 153),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    TabBar(
                      controller: _tabController,
                      indicatorColor: Color.fromRGBO(244, 93, 1, 1),
                      indicatorWeight: 2.0,
                      labelStyle: TextStyle(
                        fontFamily: "SFPro",
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      labelColor: Color.fromRGBO(244, 93, 1, 1),
                      unselectedLabelColor: Color.fromRGBO(205, 205, 205, 1),
                      tabs: <Widget>[
                        Tab(text: "ДОХОД"),
                        Tab(text: "РАСХОД"),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          IncomesFragment(_monthInfo),
                          ExpensesFragment(_monthInfo),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        "Добавить",
                        style: TextStyle(
                          fontFamily: "SFPro",
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  Widget getLine(String header, String text) {
    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 16, left: 20, right: 20),
      child: Row(
        children: <Widget>[
          Text(
            header,
            style: TextStyle(
              fontFamily: "SFPro",
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          Expanded(child: Container()),
          Text(
            text,
            style: TextStyle(
              fontFamily: "SFPro",
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          Text(
            " ₽",
            style: TextStyle(
              fontFamily: "SFPro",
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
