import 'dart:io';
import 'package:cost_control/utils/sharedPref.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class PurchasesManager {
  static const String NEXT_MONTH = "ru.mycostcontrol.app.test";

  PurchasesManager._();

  static PurchasesManager _instance;

  static Future<PurchasesManager> get instance async {
    if (_instance != null) return _instance;
    _instance = await _init();
    return _instance;
  }

  static Future<PurchasesManager> _init() async {
    String res = await FlutterInappPurchase.initConnection;
    if (res == "true") {
      return PurchasesManager._();
    } else {
      return Future.error(res);
    }
  }

  Future<bool> isPurchasedNextMonth() async {
    return SharedPref.internal().isPurchasedNextMonth();
  }

  Future<bool> restorePurchases() async {
    List<PurchasedItem> purchases = await FlutterInappPurchase.getAvailablePurchases();
    List<IAPItem> items = await FlutterInappPurchase.getProducts([NEXT_MONTH]);
    for (PurchasedItem item in purchases) {
      if (item.productId == NEXT_MONTH) {
        await SharedPref.internal().purchasedNextMonth();
      }
    }
    return true;
  }

  Future<bool> buyNextMonth() async {
    List<IAPItem> items = await FlutterInappPurchase.getProducts([NEXT_MONTH]);
    PurchasedItem res = await FlutterInappPurchase.buyProduct(NEXT_MONTH);
    if (res.productId == NEXT_MONTH) {
      await SharedPref.internal().purchasedNextMonth();
      return true;
    } else {
      return false;
    }
  }
}
