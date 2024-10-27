import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hamad_corporation_task/presentation/screens/login_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> resetNotificationChannel() async {
  const channelId = 'account_renewal_channel';
  final androidPlatformChannel =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  await androidPlatformChannel?.deleteNotificationChannel(channelId);

  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initializationSettings =
      InitializationSettings(android: androidSettings);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Re-create the notification channel
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    channelId,
    'Account Renewal Notifications',
    description: 'Notifications to remind users about account renewal',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  await androidPlatformChannel?.createNotificationChannel(channel);
}

Future<void> showNotification(String message) async {
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    'account_renewal_channel',
    'Account Renewal Notifications',
    channelDescription: 'Notifications to remind users about account renewal',
    importance: Importance.max,
    priority: Priority.high,
    enableVibration: true,
    playSound: true,
  );

  var platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    'Reminder',
    message,
    // 'Your account will expire in 1 minute. Please renew it.',
    platformChannelSpecifics,
    payload: 'item x',
  );
}

// Future<void> showAccountExpirationNotification() async {
//   const androidPlatformChannelSpecifics = AndroidNotificationDetails(
//     'account_renewal_channel',
//     'Account Expiration',
//     channelDescription: 'Notifies about account expiration',
//     importance: Importance.max,
//     priority: Priority.high,
//   );
//   const platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);
//   await flutterLocalNotificationsPlugin.show(
//     0,
//     'Reminder',
//     'Your account will expire in 1 minute. Please renew it.',
//     platformChannelSpecifics,
//     payload: 'item x',
//   );
// }

// Future<void> showLogoutNotification() async {
//   const androidPlatformChannelSpecifics = AndroidNotificationDetails(
//     'account_renewal_channel',
//     'Auto Logout',
//     channelDescription: 'Notifies about automatic logout due to inactivity',
//     importance: Importance.max,
//     priority: Priority.high,
//   );
//   const platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);
//   await flutterLocalNotificationsPlugin.show(
//     1,
//     'Auto Logout',
//     'You have been logged out due to inactivity.',
//     platformChannelSpecifics,
//   );
// }

// Show account expiration notification
Future<void> showAccountExpirationNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'account_renewal_channel',
    'Account Expiration',
    channelDescription: 'Notification for account expiration',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    'Account Expiring Soon',
    'Your account will expire in 1 minute.',
    platformChannelSpecifics,
  );
}

// Show logout notification
Future<void> showLogoutNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'account_renewal_channel',
    'Logout Notification',
    channelDescription: 'Notification for logout',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    1,
    'Logged Out Due to Inactivity',
    'You have been logged out due to inactivity.',
    platformChannelSpecifics,
  );
}
