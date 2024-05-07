import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

import 'databases/sessions.dart';

class Alarmy {
  static final _notification = FlutterLocalNotificationsPlugin();

  static init() {
    _notification.initialize(const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings()));

    tz.initializeTimeZones();
  }

  static ScheduledNotification(
      Sessions session, String body, DateTime time) async {
    var androidDetails = AndroidNotificationDetails(
        'important_notification', 'My channel',
        importance: Importance.max, priority: Priority.high);

    var iosDetails = const DarwinNotificationDetails();

    var notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notification.zonedSchedule(
        session.id,
        session.title,
        body,
        tz.TZDateTime(tz.local, time.year, time.month, time.day, time.hour,
            time.minute - 10),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  }

  static DateTime datify(String date, String time) {
    List<String> dateParts =
        date.split('-'); // Split the string into year, month, and day parts
    List<String> timeParts = time.split(" ");

// Ensure that the dateParts list contains exactly 3 parts
    if (dateParts.length == 3) {
      int? hour = int.tryParse(timeParts[0]);
      int? minutes = int.tryParse(timeParts[1]);
      int? year = int.tryParse(dateParts[0]); // Parse year part
      int? month = int.tryParse(dateParts[1]); // Parse month part
      int? day = int.tryParse(dateParts[2]); // Parse day part

      // Check if parsing was successful for all parts
      if (year != null &&
          month != null &&
          day != null &&
          hour != null &&
          minutes != null) {
        DateTime dateTime =
            DateTime(year, month, day, hour, minutes); // Create DateTime object
        return dateTime;
      } else {
        Fluttertoast.showToast(msg: 'Invalid date format');
        return DateTime.now().add(Duration(seconds: 10));
      }
    } else {
      Fluttertoast.showToast(msg: 'Invalid date format2');
      return DateTime.now().add(Duration(seconds: 10));
    }
  }

  static notify(Sessions session) async {
    await ScheduledNotification(session, 'Session at ${session.startHour}',
        datify(session.date, session.startHour));
  }

  static cancelNotify(Sessions session) async {
    await _notification.cancel(session.id);
  }
}
