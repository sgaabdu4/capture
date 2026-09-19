import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/timezone.dart' as tz;

part 'reminder_datasource.g.dart';

/// macOS notifications for approved, saved tasks, and for captures saved
/// without the review card.
abstract interface class IReminderDatasource {
  /// False when notifications are not permitted.
  Future<bool> schedule({required String itemId, required String title, required tz.TZDateTime at});
  Future<void> cancel(String itemId);

  /// Shows a notification now; nothing when notifications are not permitted.
  Future<void> show({required String id, required String title, required String body});

  /// Every scheduled and shown reminder.
  Future<void> cancelAll();
}

/// Stable 31-bit notification id for an item id (FNV-1a).
int notificationId(String itemId) {
  const offsetBasis = 0x811c9dc5;
  const prime = 0x01000193;
  const mask32 = 0xffffffff;
  const mask31 = 0x7fffffff;
  final hash = itemId.codeUnits.fold(offsetBasis, (h, unit) => ((h ^ unit) * prime) & mask32);
  return hash & mask31;
}

class LocalNotificationsReminderDatasource implements IReminderDatasource {
  LocalNotificationsReminderDatasource(this._plugin);
  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialised = false;

  Future<void> _initialise() async {
    if (_initialised) return;
    await _plugin.initialize(
      settings: const .new(
        macOS: .new(
          requestAlertPermission: false,
          requestSoundPermission: false,
          requestBadgePermission: false,
        ),
      ),
    );
    _initialised = true;
  }

  /// Permission is requested on the first reminder, never at launch.
  Future<bool> _ensure() async {
    await _initialise();
    final mac = _plugin
        .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>();
    if (mac == null) return false;
    return await mac.requestPermissions(alert: true, sound: true) == true;
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
      scheduledDate: at,
      notificationDetails: const .new(macOS: .new(presentSound: true)),
      androidScheduleMode: .inexactAllowWhileIdle,
      payload: itemId,
    );
    return true;
  }

  @override
  Future<void> show({required String id, required String title, required String body}) async {
    if (!await _ensure()) return;
    await _plugin.show(
      id: notificationId(id),
      title: title,
      body: body,
      notificationDetails: const .new(macOS: .new()),
    );
  }

  @override
  Future<void> cancel(String itemId) async {
    if (!_initialised) await _ensure();
    await _plugin.cancel(id: notificationId(itemId));
  }

  /// Never asks for permission: there is nothing to cancel without it.
  @override
  Future<void> cancelAll() async {
    await _initialise();
    await _plugin.cancelAll();
  }
}

@Riverpod(keepAlive: true)
IReminderDatasource reminderDatasource(Ref ref) => LocalNotificationsReminderDatasource(.new());
