import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class BaseScreenState<T extends StatefulWidget> extends State<T> {
  Future<dynamic> openScreen(StatefulWidget screen) {
    return Navigator.push(
        context, new MaterialPageRoute(builder: (context) => screen));
  }

  void openScreenClearTop(StatefulWidget screen) {
    Navigator.pushAndRemoveUntil(
        context,
        new MaterialPageRoute(builder: (context) => screen),
        (Route<dynamic> route) => false);
  }

  void back() {
    Navigator.pop(context);
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
