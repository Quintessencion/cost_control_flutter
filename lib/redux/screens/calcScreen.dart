import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cost_control/redux/states/appState.dart';
import 'package:cost_control/redux/view_models/calcViewModel.dart';
import 'package:cost_control/redux/actions/calcActions.dart';
import 'package:cost_control/entities/day.dart';
import 'package:cost_control/baseScreenState.dart';
import 'package:cost_control/utils/timeUtils.dart';
import 'package:cost_control/views/calcItem.dart';

class CalcScreen extends StatefulWidget {
  final Day day;

  CalcScreen({this.day});

  @override
  _CalcScreenState createState() => _CalcScreenState();
}

class _CalcScreenState extends BaseScreenState<CalcScreen>
    with TickerProviderStateMixin {
  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CalcViewModel>(
      onInit: (store) {
        store.dispatch(InitState(day: widget.day));
        _tabController = TabController(
          length: 100,
          vsync: this,
        );
        _tabController.addListener(() =>
            store.dispatch(SetCurrentPage(currentPage: _tabController.index)));
      },
      converter: (store) {
        return CalcViewModel(
            state: store.state.calcState,
            onAddSymbol: (symbol) => store.dispatch(AddSymbol(symbol: symbol)),
            onDeleteSymbol: () => store.dispatch(DeleteSymbol()),
            onPageChange: (index) =>
                store.dispatch(SetCurrentPage(currentPage: index)),
            onChangeDescription: (str) =>
                store.dispatch(ChangeDescription(description: str)),
            onDeleteItem: () {
              store.dispatch(DeleteCurrentPage(onComplete: (index) {
                _tabController.animateTo(index);
              }));
            },
            onSave: () {
              store.dispatch(SaveDay(
                day: widget.day,
                onComplete: () => Navigator.pop(context),
                onError: showToast,
              ));
            });
      },
      builder: (BuildContext context, CalcViewModel vm) {
        return getView(context, vm);
      },
    );
  }

  Widget getView(BuildContext context, CalcViewModel vm) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: vm.onSave,
        ),
        actions: <Widget>[
          IconButton(
            icon: Image.asset("assets/images/delete.png",
                width: 20.0, height: 20.0),
            onPressed: vm.onDeleteItem,
          ),
        ],
        titleSpacing: 0,
        title: Text(
            TimeUtils.getCalcFormat(DateTime(
              widget.day.parent.yearNumber,
              widget.day.parent.number,
              widget.day.number,
            )),
            style: TextStyle(
              fontFamily: "SFPro",
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            )),
        elevation: 0,
      ),
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(91, 122, 229, 1),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  Container(
                    child: TabBarView(
                        controller: _tabController,
                        children: vm.state.expenses.map((exp) {
                          return CalcItemView(
                            item: exp,
                            onChangeDescription: vm.onChangeDescription,
                          );
                        }).toList()),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: 12),
                    child: Container(
                      height: 8,
                      child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: vm.state.currentPage == index
                                    ? Color.fromRGBO(62, 92, 193, 1)
                                    : Color.fromRGBO(111, 140, 237, 1),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Container(width: 8);
                          },
                          itemCount: vm.state.expenses.length),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              constraints: BoxConstraints.expand(height: 0.5),
              color: Color.fromRGBO(122, 149, 242, 1),
            ),
            Container(
              color: Color.fromRGBO(122, 149, 242, 1),
              child: GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  mainAxisSpacing: 0.5,
                  crossAxisSpacing: 0.5,
                  children: getButtons(vm)),
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  List<Widget> getButtons(CalcViewModel vm) {
    return [
      getNymericButton(vm, "1"),
      getNymericButton(vm, "2"),
      getNymericButton(vm, "3"),
      getBaseButton(
          vm,
          Image.asset(
            "assets/images/divide.png",
            width: 25,
            height: 25,
          ),
          "/"),
      getNymericButton(vm, "4"),
      getNymericButton(vm, "5"),
      getNymericButton(vm, "6"),
      getBaseButton(
        vm,
        Icon(
          Icons.close,
          color: Color.fromRGBO(176, 193, 251, 1),
        ),
        "*",
      ),
      getNymericButton(vm, "7"),
      getNymericButton(vm, "8"),
      getNymericButton(vm, "9"),
      getMathButton(vm, "-"),
      getNymericButton(vm, "."),
      getNymericButton(vm, "0"),
      GestureDetector(
        child: Container(
          alignment: Alignment.center,
          color: Theme.of(context).primaryColor,
          child: Icon(
            Icons.backspace,
            color: Color.fromRGBO(176, 193, 251, 1),
          ),
        ),
        onTap: vm.onDeleteSymbol,
      ),
      getMathButton(vm, "+"),
    ];
  }

  Widget getNymericButton(CalcViewModel vm, String text) {
    return getBaseButton(
        vm,
        Text(
          text,
          style: TextStyle(
            fontFamily: "SFPro",
            fontSize: 28,
            color: Colors.white,
          ),
        ),
        text);
  }

  Widget getMathButton(CalcViewModel vm, String text) {
    return getBaseButton(
        vm,
        Text(text,
            style: TextStyle(
              fontFamily: "SFPro",
              fontSize: 32,
              fontWeight: FontWeight.w300,
              color: Color.fromRGBO(176, 193, 251, 1),
            )),
        text);
  }

  Widget getBaseButton(CalcViewModel vm, Widget icon, String symbol) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        color: Theme.of(context).primaryColor,
        child: icon,
      ),
      onTap: () => vm.onAddSymbol(symbol),
    );
  }
}
