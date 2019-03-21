import 'dart:io';
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
    List<PurchasedItem> purchases = await FlutterInappPurchase.getAvailablePurchases();
    List<IAPItem> items = await FlutterInappPurchase.getProducts([NEXT_MONTH]);
    for (PurchasedItem item in purchases) {
      if (item.productId == NEXT_MONTH) {
        return true;
      }
    }
    return false;
  }

  Future<bool> buyNextMonth() async {
    PurchasedItem res = await FlutterInappPurchase.buyProduct(NEXT_MONTH);
    return res.productId == NEXT_MONTH;
  }
}
