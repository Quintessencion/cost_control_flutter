import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cost_control/redux/states/appState.dart';
import 'package:cost_control/redux/states/calcState.dart';
import 'package:cost_control/redux/view_models/calcViewModel.dart';
import 'package:cost_control/redux/actions/calcActions.dart';
import 'package:cost_control/entities/day.dart';
import 'package:cost_control/baseScreenState.dart';
import 'package:cost_control/utils/timeUtils.dart';

class CalcScreen extends StatefulWidget {
  final Day day;

  CalcScreen({this.day});

  @override
  _CalcScreenState createState() => _CalcScreenState();
}

class _CalcScreenState extends BaseScreenState<CalcScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CalcViewModel>(
      converter: (store) {
        return CalcViewModel(
          state: store.state.calcState,
          onAddSymbol: (symbol) => store.dispatch(AddSymbol(symbol: symbol)),
          onDeleteSymbol: () => store.dispatch(DeleteSymbol()),
        );
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
          onPressed: () => Navigator.pop(context),
        ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 8, left: 20, right: 20),
                    child: TextField(
                      style: TextStyle(
                        fontFamily: "SFPro",
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: "Добавить описание",
                        hintStyle:
                            TextStyle(color: Color.fromRGBO(122, 149, 242, 1)),
                        enabledBorder: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                                color: Color.fromRGBO(122, 149, 242, 1))),
                      ),
                    ),
                  ),
                  Text(
                    vm.state.value,
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontSize: 78,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    vm.state.expr,
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontSize: 28,
                      fontWeight: FontWeight.w100,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              constraints: BoxConstraints.expand(height: 0.5),
              color: Color.fromRGBO(122, 149, 242, 1),
            ),
            Flexible(
              child: Container(
                color: Color.fromRGBO(122, 149, 242, 1),
                child: GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    mainAxisSpacing: 0.5,
                    crossAxisSpacing: 0.5,
                    children: getButtons(vm)),
              ),
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
      getBaseButton(vm, Image.asset("assets/images/divide.png"), "/"),
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
