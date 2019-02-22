import 'dart:math';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cost_control/baseScreenState.dart';
import 'package:cost_control/redux/states/appState.dart';
import 'package:cost_control/redux/view_models/monthInfoViewModel.dart';
import 'package:cost_control/redux/states/monthInfoState.dart';
import 'package:cost_control/redux/actions/monthInfoActions.dart';
import 'package:cost_control/views/incomesFragment.dart';
import 'package:cost_control/views/expensesFragment.dart';
import 'package:cost_control/entities/month.dart';
import 'package:cost_control/entities/monthMovement.dart';
import 'package:cost_control/redux/screens/editScreen.dart';

class MonthInfoScreen extends StatefulWidget {
  final Month month;

  MonthInfoScreen({this.month});

  @override
  _MonthInfoScreenState createState() => _MonthInfoScreenState();
}

class _MonthInfoScreenState extends BaseScreenState<MonthInfoScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MonthInfoViewModel>(
      onInit: (store) {
        _tabController = TabController(length: 2, vsync: this);
        store.dispatch(new SetMonth(month: widget.month));
      },
      converter: (store) {
        return MonthInfoViewModel(
          state: store.state.monthInfoState,
          onAdd: () => openEditScreenAsCreate(store),
          onEdit: (movement) => openEditScreenAsEdit(store, movement),
        );
      },
      builder: (BuildContext context, MonthInfoViewModel vm) {
        return getView(context, vm);
      },
    );
  }

  Widget getView(BuildContext context, MonthInfoViewModel vm) {
    double height = 50.0 *
        max(vm.state.month.incomes.length + 1,
            vm.state.month.expenses.length + 2);
    height += 99;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("${vm.state.month.name} ${vm.state.month.yearNumber}",
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
                constraints: BoxConstraints.expand(height: height),
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
                          IncomesFragment(vm.state.month,
                              onEditIncome: vm.onEdit),
                          ExpensesFragment(vm.state.month,
                              onEditExpense: vm.onEdit),
                        ],
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        child: Container(
                          width: double.maxFinite,
                          alignment: Alignment.center,
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
                        ),
                        onTap: vm.onAdd,
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

  void openEditScreenAsEdit(Store<AppState> store, MonthMovement movement) {
    openScreen(new EditScreen(
      mode: EditScreenMode.EDIT,
      movement: movement,
    )).then((res) {
      store.dispatch(new ReloadMonth(month: store.state.monthInfoState.month));
    });
  }

  void openEditScreenAsCreate(Store<AppState> store) {
    int direction = 1 - _tabController.index * 2;
    openScreen(new EditScreen(
      mode: EditScreenMode.CREATE,
      month: store.state.monthInfoState.month,
      direction: direction,
    )).then((res) {
      store.dispatch(new ReloadMonth(month: store.state.monthInfoState.month));
    });
  }
}
