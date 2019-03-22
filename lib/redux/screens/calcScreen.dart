import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cost_control/main.dart';
import 'package:cost_control/redux/states/appState.dart';
import 'package:cost_control/redux/view_models/calcViewModel.dart';
import 'package:cost_control/redux/actions/calcActions.dart';
import 'package:cost_control/redux/actions/mainActions.dart';
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
    with TickerProviderStateMixin, WidgetsBindingObserver, RouteAware {
  void Function() onClose;
  PageController _tabController;
  bool isPageChanged = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didPop() {
    if (onClose != null) {
      onClose();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive && onClose != null) {
      onClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CalcViewModel>(
      onInit: (store) {
        WidgetsBinding.instance.addObserver(this);
        store.dispatch(InitState(day: widget.day));
        _tabController = PageController();
        onClose = () {
          store.dispatch(SaveDay(
            day: widget.day,
            onComplete: () => store.dispatch(LoadMonths()),
            onError: showToast,
          ));
        };
      },
      converter: (store) {
        return CalcViewModel(
          state: store.state.calcState,
          onAddSymbol: (symbol) => store.dispatch(AddSymbol(
              symbol: symbol,
              onChangeTab: (index) {
                isPageChanged = true;
                _tabController.jumpToPage(index);
              })),
          onDeleteSymbol: () => store.dispatch(DeleteSymbol()),
          onPageChange: (index) {
            store.dispatch(SetCurrentTab(currentTab: index));
            if (!isPageChanged) {
              store.dispatch(ClearFocus());
              FocusScope.of(context).requestFocus(FocusNode());
            }
            isPageChanged = false;
          },
          onChangeDescription: (str) => store.dispatch(ChangeDescription(
              description: str,
              onChangeTab: (index) {
                isPageChanged = true;
                _tabController.jumpToPage(index);
              })),
          onDeleteItem: () {
            store.dispatch(DeleteCurrentTab(onComplete: (index) {
              isPageChanged = true;
              _tabController.jumpToPage(index);
            }));
          },
          onSave: () {
            store.dispatch(SaveDay(
              day: widget.day,
              onComplete: () => Navigator.pop(context),
              onError: showToast,
            ));
          },
          onDismiss: () {
            store.dispatch(ClearFocus());
            FocusScope.of(context).requestFocus(FocusNode());
          },
        );
      },
      builder: (BuildContext context, CalcViewModel vm) {
        return _getView(context, vm);
      },
    );
  }

  Widget _getView(BuildContext context, CalcViewModel vm) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
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
          ),
        ),
        elevation: 0,
      ),
      resizeToAvoidBottomPadding: false,
      body: GestureDetector(
        onTap: vm.onDismiss,
        child: _getBody(vm),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  Widget _getBody(CalcViewModel vm) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(91, 122, 229, 1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                _getTabs(vm),
                _getTabIndicator(vm),
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
                children: _getButtons(vm)),
          ),
        ],
      ),
    );
  }

  Widget _getTabs(CalcViewModel vm) {
    return Container(
      child: PageView(
          controller: _tabController,
          onPageChanged: vm.onPageChange,
          children: vm.state.expenses.map((exp) {
            return CalcItemView(
              item: exp,
              onChangeDescription: vm.onChangeDescription,
            );
          }).toList()),
    );
  }

  Widget _getTabIndicator(CalcViewModel vm) {
    return Container(
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
    );
  }

  List<Widget> _getButtons(CalcViewModel vm) {
    return [
      _getNumericButton(vm, "1"),
      _getNumericButton(vm, "2"),
      _getNumericButton(vm, "3"),
      _getBaseButton(
          vm,
          Image.asset(
            "assets/images/divide.png",
            width: 25,
            height: 25,
          ),
          "/"),
      _getNumericButton(vm, "4"),
      _getNumericButton(vm, "5"),
      _getNumericButton(vm, "6"),
      _getBaseButton(
        vm,
        Icon(
          Icons.close,
          color: Color.fromRGBO(176, 193, 251, 1),
        ),
        "*",
      ),
      _getNumericButton(vm, "7"),
      _getNumericButton(vm, "8"),
      _getNumericButton(vm, "9"),
      _getMathButton(vm, "-"),
      _getNumericButton(vm, "."),
      _getNumericButton(vm, "0"),
      GestureDetector(
        child: Container(
          alignment: Alignment.center,
          color: Theme.of(context).primaryColor,
          child: Icon(
            Icons.backspace,
            color: Color.fromRGBO(176, 193, 251, 1),
          ),
        ),
        onTap: () {
          vm.onDismiss();
          vm.onDeleteSymbol();
        },
      ),
      _getMathButton(vm, "+"),
    ];
  }

  Widget _getNumericButton(CalcViewModel vm, String text) {
    return _getBaseButton(
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

  Widget _getMathButton(CalcViewModel vm, String text) {
    return _getBaseButton(
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

  Widget _getBaseButton(CalcViewModel vm, Widget icon, String symbol) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        color: Theme.of(context).primaryColor,
        child: icon,
      ),
      onTap: () {
        vm.onDismiss();
        vm.onAddSymbol(symbol);
      },
    );
  }
}
