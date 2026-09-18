import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import 'app/app_model.dart';
import 'app/env.dart';
import 'services/jev_client.dart';
import 'services/local_store.dart';
import 'services/model_store.dart';
import 'services/native_bridge.dart';
import 'services/notion_client.dart';
import 'services/reminders.dart';
import 'services/secrets.dart';
import 'services/transcriber.dart';
import 'ui/shell.dart';

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
