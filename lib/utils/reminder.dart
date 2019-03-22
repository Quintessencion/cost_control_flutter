import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cost_control/utils/sharedPref.dart';

class Reminder {
  static FlutterLocalNotificationsPlugin _init() {
    FlutterLocalNotificationsPlugin res = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('app_icon');
    var ios = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(android, ios);
    res.initialize(initializationSettings);
    return res;
  }

  static void _setupNotification(
    FlutterLocalNotificationsPlugin plugin,
    NotificationDetails platformChannelSpecifics,
    int days,
  ) {
    DateTime now = DateTime.now();
    DateTime time = DateTime(now.year, now.month, now.day, 18);
    time = time.add(new Duration(days: days));
    SharedPref.internal().isEditedDay(time.day).then((edited) {
      if (!edited) {
        plugin.schedule(
          time.day,
          'Напоминание',
          'Не забыли заполнить свои расходы?',
          time,
          platformChannelSpecifics,
        );
      }
    });
  }

  static void cancelCurrentDayRemind() {
    FlutterLocalNotificationsPlugin plugin = _init();
    plugin.cancel(DateTime.now().day);
    SharedPref.internal().setLastEditedDay(DateTime.now().day);
  }

  static void setRemind() {
    FlutterLocalNotificationsPlugin plugin = _init();

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        '659',
        'Напоминания',
        'В 18 часов будет приходить напоминание о заполнении расходов');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    _setupNotification(plugin, platformChannelSpecifics, 0);
    _setupNotification(plugin, platformChannelSpecifics, 1);
    _setupNotification(plugin, platformChannelSpecifics, 2);
  }
}
