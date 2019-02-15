import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cost_control/redux/states/appState.dart';
import 'package:cost_control/redux/view_models/mainViewModel.dart';
import 'package:cost_control/redux/actions/mainActions.dart';
import 'package:cost_control/utils/timeUtils.dart';
import 'package:cost_control/views/MonthFragment.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(vsync: this, length: TimeUtils.MONTH_IN_YEAR);
  }

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
        );
      },
      builder: (BuildContext context, MainViewModel vm) {
        return getView(context, vm);
      },
    );
  }

  Widget getView(BuildContext context, MainViewModel vm) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Image.asset("assets/images/dollar.png",
                width: 26.0, height: 26.0),
            onPressed: null),
        titleSpacing: 0,
        title: getTabBar(vm),
        bottom: getBottomBarLine(),
      ),
      body: getTabView(vm),
    );
  }

  Widget getTabView(MainViewModel vm) {
    if (vm.state.months == null) {
      return null;
    }
    return TabBarView(
      controller: _tabController,
      children: vm.state.months.map((month) => MonthFragment(month)).toList(),
    );
  }

  Widget getTabBar(MainViewModel vm) {
    if (vm.state.months == null) {
      return null;
    }
    return TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: Color.fromRGBO(244, 93, 1, 1),
        indicatorWeight: 3.0,
        tabs: vm.state.months.map((month) {
          return SizedBox(
            child: Center(
              child: Text(month.name),
              widthFactor: 1.0,
            ),
            height: 60.0,
          );
        }).toList());
  }

  Widget getBottomBarLine() {
    return PreferredSize(
        child: Container(
          color: Color.fromRGBO(178, 194, 250, 1),
          height: 0.5,
        ),
        preferredSize: Size.fromHeight(0.5));
  }
}
