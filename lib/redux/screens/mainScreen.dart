import 'dart:ui' show ImageFilter;

import 'package:cost_control/baseScreenState.dart';
import 'package:cost_control/entities/day.dart';
import 'package:cost_control/redux/actions/calcActions.dart';
import 'package:cost_control/redux/actions/mainActions.dart';
import 'package:cost_control/redux/screens/calcScreen.dart';
import 'package:cost_control/redux/screens/monthInfoScreen.dart';
import 'package:cost_control/redux/states/appState.dart';
import 'package:cost_control/redux/states/mainState.dart';
import 'package:cost_control/redux/view_models/mainViewModel.dart';
import 'package:cost_control/views/monthFragment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends BaseScreenState<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MainViewModel>(
      onInit: (store) {
        store.dispatch(new LoadMonths());
      },
      converter: (store) {
        return MainViewModel(
            state: store.state.mainState,
            onOpenInfoScreen: () => _openInfoScreen(store),
            onOpenCalcScreen: (day) => _openCalcScreen(store, day),
            onPageChange: (index) {
              store.dispatch(new SetCurrentPage(currentPage: index));
            },
            onFirstSession: () {
              store.dispatch(SetFirstScreenVisibility(visibility: false));
              _openInfoScreen(store);
            },
            onPurchaseNextMonth: () =>
                store.dispatch(PurchaseNextMonth(onResult: showToast)),
            onRestorePurchase: () =>
                store.dispatch(RestorePurchase(onResult: showToast)),
            onUpdateDay: (days) {
              store.dispatch(SaveDays(days: days,
                onComplete: () => store.dispatch(LoadMonths()),
                onError: showToast,));
            }
        );
      },
      builder: (BuildContext context, MainViewModel vm) {
        return _getView(context, vm);
      },
    );
  }

  Widget _getView(BuildContext context, MainViewModel vm) {
    if (vm.state.months != null && _tabController == null) {
      _tabController = TabController(
        length: vm.state.months.length,
        initialIndex: vm.state.currentPage,
        vsync: this,
      );
      _tabController.addListener(() => vm.onPageChange(_tabController.index));
    }

    List<Widget> layers = new List();
    layers.add(Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Image.asset("assets/images/dollar.png",
                width: 26.0, height: 26.0),
            onPressed: vm.onOpenInfoScreen),
        titleSpacing: 0,
        elevation: 0,
        title: _getTabBar(vm),
        bottom: _getBottomBarLine(),
      ),
      body: _getTabView(vm),
    ));
    if (vm.state.firstSession) {
      layers.add(_getFirstSessionScreen(vm));
    }

    return Stack(
      children: layers,
    );
  }

  Widget _getFirstSessionScreen(MainViewModel vm) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(color: Colors.transparent),
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 12, top: 8, right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 42,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(91, 122, 229, 1),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(21),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(91, 122, 229, 1),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(21),
                            bottomLeft: Radius.circular(21),
                            bottomRight: Radius.circular(21),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                              EdgeInsets.only(left: 36, top: 24, right: 36),
                              child: Text(
                                "Добро пожаловать!",
                                style: TextStyle(
                                  fontFamily: "SFPro",
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 36, top: 20, right: 36, bottom: 32),
                              child: Text(
                                "Для того, чтобы начать пользоваться нашим приложением, "
                                    "нужно заполнить свои данные о расходах и доходах.\n\n"
                                    "Нажмите на этот значок, чтобы  перейти в меню.",
                                style: TextStyle(
                                  fontFamily: "SFPro",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: vm.onFirstSession,
                  child: Container(
                    width: 44,
                    height: 44,
                    margin: EdgeInsets.only(left: 11, top: 6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Container(
                      margin: EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(91, 122, 229, 1),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "₽",
                          style: TextStyle(
                            fontFamily: "SFPro",
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(91, 122, 229, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getTabView(MainViewModel vm) {
    if (vm.state.months == null) {
      return null;
    }
    List<MonthFragment> tabs = new List();
    for (int i = 0; i < vm.state.months.length; i++) {
      tabs.add(MonthFragment(
        month: vm.state.months[i],
        isCurrent: vm.state.months[i].isBelong(DateTime.now()),
        onDayClick: vm.onOpenCalcScreen,
        purchaseNextMonth: vm.onPurchaseNextMonth,
        restorePurchases: vm.onRestorePurchase,
        onDayUpdate: vm.onUpdateDay,
      ));
    }
    return TabBarView(
      controller: _tabController,
      children: tabs,
    );
  }

  Widget _getTabBar(MainViewModel vm) {
    if (vm.state.months == null) {
      return null;
    }
    List<Widget> tabs = new List();
    for (int i = 0; i < vm.state.months.length; i++) {
      if (vm.state.months[i].isBelong(DateTime.now()) &&
          vm.state.currentPage != i) {
        tabs.add(SizedBox(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Center(
                child: Text(vm.state.months[i].name),
              ),
              Container(
                width: 4,
                height: 4,
                margin: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          height: 60.0,
        ));
      } else {
        tabs.add(SizedBox(
          child: Center(
            child: Text(vm.state.months[i].name),
            widthFactor: 1.0,
          ),
          height: 60.0,
        ));
      }
    }
    return TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: Color.fromRGBO(244, 93, 1, 1),
        indicatorWeight: 3.0,
        labelStyle: TextStyle(
          fontFamily: "SFPro",
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        unselectedLabelColor: Color.fromRGBO(122, 149, 242, 1),
        tabs: tabs);
  }

  Widget _getBottomBarLine() {
    return PreferredSize(
        child: Container(
          color: Color.fromRGBO(178, 194, 250, 1),
          height: 0.5,
        ),
        preferredSize: Size.fromHeight(0.5));
  }

  void _openCalcScreen(Store<AppState> store, Day day) async {
    await openScreen(new CalcScreen(
      day: day,
    ));
  }

  void _openInfoScreen(Store<AppState> store) async {
    MainState state = store.state.mainState;
    await openScreen(new MonthInfoScreen(
      month: state.months[state.currentPage],
    ));
    store.dispatch(LoadMonths());
  }
}
