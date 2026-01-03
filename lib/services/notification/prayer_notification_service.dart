import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class PrayerNotificationService {
  final _notifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(android: androidSettings);
    await _notifications.initialize(settings);
  }

  Future<void> showNotification(String prayer, DateTime dateTime) async {
    final scheduledTime = tz.TZDateTime.from(dateTime, tz.local);

    await _notifications.zonedSchedule(
      prayer.hashCode,
      '$prayer Prayer',
      'Time for $prayer prayer',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_channel',
          'Prayer Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
