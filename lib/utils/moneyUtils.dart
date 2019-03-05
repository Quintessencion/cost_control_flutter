import 'package:intl/intl.dart';

class MoneyUtils {
  static const String LOCALE = 'ru';
  static final NumberFormat _standard = NumberFormat("###,###,###", LOCALE);
  static final NumberFormat _twoDigits = NumberFormat("0.##");

  static String standard(double money) {
    return _standard.format(money);
  }

  static String twoDigits(double money) {
    return _twoDigits.format(money);
  }
}
