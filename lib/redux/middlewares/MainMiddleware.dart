import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';
import 'package:cost_control/redux/states/appState.dart';
import 'package:cost_control/redux/actions/mainActions.dart';
import 'package:cost_control/entities/month.dart';

class MainMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    //TODO: Здесь должна быть довольно сложная логика с начальной инициализацией базы даннных с использованием данных из json
    //Но пока просто загрузка из json
    String data = await rootBundle.loadString("assets/jsons/months_init.json");
    List<Month> months = Month.fromJsonArray(new JsonDecoder().convert(data)["data"]);
    next(new OnMonthsLoaded(months: months));
  }
}
