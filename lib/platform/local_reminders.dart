import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../data/session_service.dart';

/// Parking reminders through the OS notification scheduler.
class LocalReminders implements ReminderScheduler {
  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
  }

  /// Asks only when the rider starts a session, where the reason is obvious.
  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      return await _android?.requestNotificationsPermission() ?? false;
    }
    return await _plugin
            .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(alert: true, sound: true) ??
        false;
  }

  AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'parking_reminders',
      'Parking reminders',
      channelDescription: 'When to head back to your vehicle',
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(interruptionLevel: InterruptionLevel.timeSensitive),
  );

  @override
  Future<void> schedule({required int id, required DateTime at, required String title, required String body}) async {
    await _plugin.zonedSchedule(
      id: id,
      scheduledDate: tz.TZDateTime.from(at, tz.local),
      notificationDetails: _details,
      androidScheduleMode:
          await exactAllowed() ? AndroidScheduleMode.exactAllowWhileIdle : AndroidScheduleMode.inexactAllowWhileIdle,
      title: title,
      body: body,
    );
  }

  @override
  Future<void> cancel(int id) => _plugin.cancel(id: id);

  @override
  Future<Set<int>> pendingIds() async => {for (final r in await _plugin.pendingNotificationRequests()) r.id};

  @override
  Future<bool> exactAllowed() async {
    if (!Platform.isAndroid) return true;
    return await _android?.canScheduleExactNotifications() ?? false;
  }

  Future<void> requestExactAlarms() async => _android?.requestExactAlarmsPermission();
}
