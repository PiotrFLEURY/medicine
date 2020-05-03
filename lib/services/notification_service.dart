import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const DAILY_NOTIFICATION_CHANNEL = 'DAILY_NOTIFICATION_CHANNEL';

class NotificationService {
  BuildContext context;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void init(BuildContext context) async {
    this.context = context;
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              //
            },
          )
        ],
      ),
    );
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    // MORE STUFF HERE
  }

  void scheduleDailyNotifications(
      int id, String title, String text, TimeOfDay timeOfDay) async {
    var time = Time(timeOfDay.hour, timeOfDay.minute, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        DAILY_NOTIFICATION_CHANNEL,
        DAILY_NOTIFICATION_CHANNEL,
        DAILY_NOTIFICATION_CHANNEL);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
      id,
      title,
      text,
      time,
      platformChannelSpecifics,
    );
  }

  Future<List<PendingNotificationRequest>> getPending() async {
    return flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }
}
