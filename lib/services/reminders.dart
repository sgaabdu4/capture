import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// Schedules macOS notifications for approved, saved tasks only.
abstract interface class ReminderScheduler {
  /// Returns false when notifications are not permitted.
  Future<bool> schedule({
    required String itemId,
    required String title,
    required tz.TZDateTime at,
  });
  Future<void> cancel(String itemId);
}

/// Stable 31-bit notification id for an item id (FNV-1a).
int notificationId(String itemId) {
  var hash = 0x811c9dc5;
  for (final unit in itemId.codeUnits) {
    hash = ((hash ^ unit) * 0x01000193) & 0xffffffff;
  }
  return hash & 0x7fffffff;
}

class LocalReminders implements ReminderScheduler {
  final _plugin = FlutterLocalNotificationsPlugin();
  var _initialised = false;

  Future<bool> _ensure() async {
    if (!_initialised) {
      await _plugin.initialize(
        settings: const InitializationSettings(
          macOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestSoundPermission: false,
            requestBadgePermission: false,
          ),
        ),
      );
      _initialised = true;
    }
    final mac = _plugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >();
    return await mac?.requestPermissions(alert: true, sound: true) ?? false;
  }

  @override
  Future<bool> schedule({
    required String itemId,
    required String title,
    required tz.TZDateTime at,
  }) async {
    if (!await _ensure()) return false;
    await _plugin.zonedSchedule(
      id: notificationId(itemId),
      title: title,
      body: 'Reminder from Capture',
      scheduledDate: at,
      notificationDetails: const NotificationDetails(
        macOS: DarwinNotificationDetails(presentSound: true),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: itemId,
    );
    return true;
  }

  @override
  Future<void> cancel(String itemId) async {
    if (!_initialised) await _ensure();
    await _plugin.cancel(id: notificationId(itemId));
  }
}
