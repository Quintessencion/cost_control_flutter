import 'package:intl/intl.dart';

class TimeUtils {
  static const int MONTH_IN_YEAR = 12;
  static const String LOCALE = "ru_RUS";
  static const String M_FORMAT = "MMMM";
  static const String SHORT_M_FORMAT = "MMM";

  static bool dayEquals(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  static int getDaysCountByMonth(int month) {
    DateTime now = DateTime.now();
    return month < MONTH_IN_YEAR ? DateTime(now.year, month + 1, 0).day : DateTime(now.year + 1, 1, 0).day;
  }

  static String getMonthNameByNumber(int month) {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, month, 1);
    String res = dateToString(M_FORMAT, date);
    return res.substring(0, 1).toUpperCase() + res.substring(1);
  }

  static String getMonthShortNameByNumber(int month) {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, month, 1);
    String res = dateToString(SHORT_M_FORMAT, date);
    if (res.substring(res.length - 1) == ".") {
      res = res.substring(0, res.length - 1);
    }
    return res.toUpperCase();
  }

  static String dateToString(String format, DateTime date) {
    return new DateFormat(format, LOCALE).format(date);
  }
}