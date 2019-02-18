import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cost_control/redux/states/appState.dart';
import 'package:cost_control/redux/view_models/mainViewModel.dart';
import 'package:cost_control/redux/actions/mainActions.dart';
import 'package:cost_control/views/monthFragment.dart';

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
          onPageChange: (index) {
            store.dispatch(new SetCurrentPage(currentPage: index));
          },
        );
      },
      builder: (BuildContext context, MainViewModel vm) {
        return getView(context, vm);
      },
    );
  }

  Widget getView(BuildContext context, MainViewModel vm) {
    if (vm.state.months != null && _tabController == null) {
      _tabController = TabController(
        length: vm.state.months.length,
        initialIndex: vm.state.currentPage,
        vsync: this,
      );
      _tabController.addListener(() => vm.onPageChange(_tabController.index));
    }

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
    List<MonthFragment> tabs = new List();
    for (int i = 0; i < vm.state.months.length; i++) {
      tabs.add(MonthFragment(
        vm.state.months[i],
        vm.state.months[i].isBelong(DateTime.now()),
      ));
    }
    return TabBarView(
      controller: _tabController,
      children: tabs,
    );
  }

  Widget getTabBar(MainViewModel vm) {
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

  Widget getBottomBarLine() {
    return PreferredSize(
        child: Container(
          color: Color.fromRGBO(178, 194, 250, 1),
          height: 0.5,
        ),
        preferredSize: Size.fromHeight(0.5));
  }
}
