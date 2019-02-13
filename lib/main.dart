import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:cost_control/redux/store.dart';
import 'package:cost_control/redux/states/appState.dart';
import 'package:cost_control/redux/screens/mainScreen.dart';

void main() => runApp(MyApp(prepareStore()));

class MyApp extends StatelessWidget {
  Store<AppState> store;

  MyApp(this.store);

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Cost Control',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color.fromRGBO(70, 110, 220, 1),
        ),
        home: MainScreen(),
      ),
    );
  }
}
