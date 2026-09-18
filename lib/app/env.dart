import 'package:capture/features/capture/data/datasources/jev_remote_datasource.dart';
import 'package:capture/core/data/database/local_store.dart';
import 'package:capture/features/settings/data/datasources/speech_model_datasource.dart';
import 'package:capture/core/data/native/native_bridge.dart';
import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/data/reminders/reminder_datasource.dart';
import 'package:capture/features/settings/data/datasources/secrets_local_datasource.dart';

/// Local speech-to-text (Parakeet in production).
abstract interface class SpeechToText {
  Future<String> transcribe(String pcmPath);
}

/// Everything the controllers touch outside Dart. Production wiring lives
/// in `main.dart`; tests substitute fakes.
class AppEnv {
  AppEnv({
    required this.native,
    required this.secrets,
    required this.store,
    required this.model,
    required this.speech,
    required this.jev,
    required this.notion,
    required this.reminders,
    required this.capturesDir,
    required this.timeZone,
    DateTime Function()? now,
    String Function()? newId,
  }) : now = now ?? DateTime.now,
       newId = newId ?? _randomId;

  final NativeApi native;
  final SecretStore secrets;
  final LocalStore store;
  final ModelStore model;
  final SpeechToText speech;
  final JevClient Function(String apiKey) jev;
  final NotionClient Function(String token) notion;
  final ReminderScheduler reminders;

  /// Directory for PCM and M4A files.
  final String capturesDir;

  /// Current IANA time zone of the Mac.
  final Future<String> Function() timeZone;
  final DateTime Function() now;
  final String Function() newId;
}

var _counter = 0;

/// Sortable, collision-resistant id: time + counter + random.
String _randomId() {
  final t = DateTime.now().toUtc().microsecondsSinceEpoch.toRadixString(36);
  final c = (_counter++ % 1296).toRadixString(36).padLeft(2, '0');
  final r = (DateTime.now().microsecond * 7919 % 46656).toRadixString(36).padLeft(3, '0');
  return '$t$c$r';
}
