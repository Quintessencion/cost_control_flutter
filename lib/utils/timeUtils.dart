import 'package:intl/intl.dart';

class TimeUtils {
  static const int MONTH_IN_YEAR = 12;
  static const String LOCALE = "ru_RUS";
  static const String M_FORMAT = "MMMM";
  static const String SHORT_M_FORMAT = "MMM";
  static const String CALC_SCREEN_FORMAT = "d MMMM, EEEEE";

  static bool dayEquals(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static int getDaysCountByDate(DateTime day) {
    return day.month < MONTH_IN_YEAR
        ? DateTime(day.year, day.month + 1, 0).day
        : DateTime(day.year + 1, 1, 0).day;
  }

  static String getMonthNameByNumber(int month) {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, month, 1);
    String res = dateToString(M_FORMAT, date);
    return _firstLetterUpperCase(res);
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

  static String getCalcFormat(DateTime date) {
    return dateToString(CALC_SCREEN_FORMAT, date)
        .split(' ')
        .map(_firstLetterUpperCase)
        .join(' ');
  }

  static String dateToString(String format, DateTime date) {
    return new DateFormat(format, LOCALE).format(date);
  }

  static String _firstLetterUpperCase(String str) {
    return str.substring(0, 1).toUpperCase() + str.substring(1);
  }
}
