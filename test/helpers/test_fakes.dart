import 'package:capture/core/data/reminders/reminder_datasource.dart';
import 'package:capture/core/data/secrets/secrets_local_datasource.dart';
import 'package:capture/core/data/system/system_datasource.dart';
import 'package:timezone/timezone.dart' as tz;

/// In-memory credential store.
class FakeSecrets implements ISecretsLocalDatasource {
  FakeSecrets([Map<Secret, String> values = const {}]) : _values = {...values};
  final Map<Secret, String> _values;

  @override
  Future<String?> read(Secret secret) async => _values[secret];

  @override
  Future<void> write(Secret secret, String value) async => _values[secret] = value;

  @override
  Future<void> delete(Secret secret) async => _values.remove(secret);
}

/// A notification's text.
typedef ShownNotification = ({String title, String body});

/// Notifications that are never shown; records what would have been shown
/// and whether all were cancelled.
class FakeReminders implements IReminderDatasource {
  bool cancelledAll = false;

  /// Title and body of each notification shown now.
  final shown = <ShownNotification>[];

  @override
  Future<void> show({required String id, required String title, required String body}) async =>
      shown.add((title: title, body: body));

  @override
  Future<bool> schedule({
    required String itemId,
    required String title,
    required tz.TZDateTime at,
  }) async => true;

  @override
  Future<void> cancel(String itemId) async {}

  @override
  Future<void> cancelAll() async => cancelledAll = true;
}

/// Fixed clock (2026-09-17 19:09 UTC, Europe/London) and sequential ids:
/// `item-1`, `item-2`, …
class FakeSystem implements ISystemDatasource {
  int _next = 0;

  static final now = DateTime.utc(2026, 9, 17, 19, 9);
  static const zone = 'Europe/London';

  @override
  DateTime nowUtc() => now;

  @override
  Future<String> timeZone() async => zone;

  @override
  String newId() => 'item-${++_next}';
}
