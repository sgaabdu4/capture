import 'dart:async';

import 'package:capture/app/app_model.dart';
import 'package:capture/app/env.dart';
import 'package:capture/features/capture/data/datasources/jev_remote_datasource.dart';
import 'package:capture/core/data/database/local_store.dart';
import 'package:capture/features/settings/data/datasources/speech_model_datasource.dart';
import 'package:capture/core/data/native/native_bridge.dart';
import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/data/reminders/reminder_datasource.dart';
import 'package:capture/features/settings/data/datasources/secrets_local_datasource.dart';
import 'package:capture/features/capture/data/datasources/transcription_datasource.dart';
import 'package:capture/ui/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest.dart' as tzdata;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tzdata.initializeTimeZones();
  final support = (await getApplicationSupportDirectory()).path;
  final modelDir = '$support/models/parakeet-tdt-0.6b-v3-int8';
  final env = AppEnv(
    native: NativeBridge(),
    secrets: const KeychainSecrets(),
    store: LocalStore.open('$support/capture.sqlite'),
    model: ModelStore(modelDir),
    speech: _Parakeet(Transcriber(modelDir)),
    jev: JevClient.new,
    notion: NotionClient.new,
    reminders: LocalReminders(),
    capturesDir: '$support/captures',
    timeZone: () async => (await FlutterTimezone.getLocalTimezone()).identifier,
  );
  final model = AppModel(env);
  runApp(CaptureApp(model: model));
  unawaited(model.start());
}

class _Parakeet implements SpeechToText {
  const _Parakeet(this._transcriber);
  final Transcriber _transcriber;

  @override
  Future<String> transcribe(String pcmPath) => _transcriber.transcribe(pcmPath);
}
