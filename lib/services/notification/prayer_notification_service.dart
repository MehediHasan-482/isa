import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class PrayerNotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// Initialize notification plugin
  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(android: androidSettings);
    await _notifications.initialize(settings);
  }

  /// Schedule a prayer notification
  Future<void> schedulePrayerNotification({
    required String prayer,
    required tz.TZDateTime scheduledTime,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'prayer_channel',
      'Prayer Notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    // ✅ zonedSchedule in v17+
    await _notifications.zonedSchedule(
      prayer.hashCode, // unique id
      '$prayer Prayer',
      'Time for $prayer prayer',
      scheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
