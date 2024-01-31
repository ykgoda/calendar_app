import 'package:calendar_app/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

tz.TZDateTime _timeSetting(
    int year, int month, int day, int hour, int minutes) {
  tz.TZDateTime scheduledDate =
      tz.TZDateTime(tz.local, year, month, day, hour, minutes);

  return scheduledDate;
}

Future<void> notificationSchedule({
  required int id,
  required String body,
  required int year,
  required int month,
  required int day,
  required int hour,
  required int minutes,
}) async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    '予定の時間です',
    body,
    _timeSetting(year, month, day, hour, minutes),
    const NotificationDetails(
      iOS: DarwinNotificationDetails(
        badgeNumber: 1,
      ),
    ),
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}
