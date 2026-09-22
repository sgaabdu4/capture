import 'dart:io';

import 'package:capture/core/data/reminders/reminder_datasource.dart';
import 'package:capture/core/data/secrets/secrets_local_datasource.dart';
import 'package:capture/core/data/system/local_app_directories_datasource.dart';
import 'package:capture/core/data/system/system_datasource.dart';
import 'package:capture/core/services/native_event.dart';
import 'package:capture/core/services/native_platform_service.dart';
import 'package:capture/core/theme/fonts.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'test_fakes.dart';

class _MockNative extends Mock implements INativePlatformService {}

/// The approved reference window size.
const referenceWindow = Size(1240, 860);

/// The app's bundled fonts, so text lays out as it does in the app rather
/// than in the wider test font.
const _fonts = {
  Fonts.title: 'assets/fonts/Caveat.ttf',
  Fonts.hand: 'assets/fonts/PatrickHand-Regular.ttf',
};

/// A native side with no microphone permission yet and no events.
INativePlatformService stubNative() {
  final native = _MockNative();
  when(() => native.events).thenAnswer((_) => const Stream.empty());
  when(native.installMenu).thenAnswer((_) async {});
  when(native.micPermission).thenAnswer((_) async => MicPermission.undetermined);
  when(
    () => native.setHotKey(
      keyCode: any(named: 'keyCode'),
      modifiers: any(named: 'modifiers'),
      label: any(named: 'label'),
    ),
  ).thenAnswer((_) async => true);
  when(() => native.pauseHotKey(paused: any(named: 'paused'))).thenAnswer((_) async {});
  when(native.hideOverlay).thenAnswer((_) async {});
  when(
    () => native.setMenuState(
      nextUp: any(named: 'nextUp'),
      latest: any(named: 'latest'),
      canRecord: any(named: 'canRecord'),
    ),
  ).thenAnswer((_) async {});
  return native;
}

Future<void> loadAppFonts() async {
  for (final MapEntry(key: family, value: asset) in _fonts.entries) {
    await (FontLoader(family)..addFont(rootBundle.load(asset))).load();
  }
}

/// Fakes that replace the defaults: a Keychain with keys, recorded
/// reminders, or the iPhone.
typedef AppFakes = ({FakeSecrets? secrets, FakeReminders? reminders, FakeSystem? system});

/// Fake Keychain (empty by default), reminders, clock (the Mac by default)
/// and native side, and a fresh on-disk database under [support].
List<Override> appOverrides({
  required Directory support,
  required INativePlatformService native,
  AppFakes fakes = (secrets: null, reminders: null, system: null),
}) => [
  appDirectoriesProvider.overrideWithValue((
    captures: '${support.path}/captures',
    model: '${support.path}/model',
    database: '${support.path}/capture.sqlite',
  )),
  secretsLocalDatasourceProvider.overrideWithValue(fakes.secrets ?? FakeSecrets()),
  reminderDatasourceProvider.overrideWithValue(fakes.reminders ?? FakeReminders()),
  systemDatasourceProvider.overrideWithValue(fakes.system ?? FakeSystem()),
  nativePlatformServiceProvider.overrideWithValue(native),
];
