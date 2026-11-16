import 'package:capture/core/services/native_channel_keys.dart';
import 'package:capture/core/services/native_event.dart';
import 'package:capture/core/services/native_platform_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<List<NativeEvent>> _eventsFor(String method, [Object? arguments]) async {
  final container = ProviderContainer.test();
  addTearDown(container.dispose);
  final events = <NativeEvent>[];
  final subscription = container.read(nativePlatformServiceProvider).events.listen(events.add);
  addTearDown(subscription.cancel);
  await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
    NativeChannelKeys.channel,
    const StandardMethodCodec().encodeMethodCall(MethodCall(method, arguments)),
    (_) {},
  );
  await pumpEventQueue();
  return events;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('a call from the native side becomes an event', () {
    final plain = {
      'hotkey': isA<HotkeyPressed>(),
      'stopRequested': isA<StopRequested>(),
      'limitReached': isA<LimitReached>(),
      'recordingFailed': isA<RecordingFailed>(),
      'updateAvailable': isA<UpdateAvailable>(),
      'recordRequested': isA<RecordRequested>(),
    };
    for (final MapEntry(key: method, value: matcher) in plain.entries) {
      test(method, () async {
        expect(await _eventsFor(method), [matcher]);
      });
    }

    test('an unknown call makes no event', () async {
      expect(await _eventsFor('somethingElse'), isEmpty);
    });

    test('a review button press carries its action', () async {
      final events = await _eventsFor('review', 'edit');

      expect(
        events.single,
        isA<ReviewCardAction>().having((e) => e.action, 'action', ReviewAction.edit),
      );
    });

    test('a review press with an unknown action makes no event', () async {
      expect(await _eventsFor('review', 'explode'), isEmpty);
    });

    test('a menu command carries its action', () async {
      final events = await _eventsFor('menu', 'settings');

      expect(
        events.single,
        isA<MenuCommand>().having((e) => e.action, 'action', MenuAction.settings),
      );
    });

    test('a menu command with an unknown action makes no event', () async {
      expect(await _eventsFor('menu', 'explode'), isEmpty);
    });

    test('a level reading carries the level and the elapsed time', () async {
      final events = await _eventsFor('level', {
        NativeChannelKeys.level: 0.5,
        NativeChannelKeys.seconds: 1.5,
      });

      expect(
        events.single,
        isA<LevelChanged>()
            .having((e) => e.level, 'level', 0.5)
            .having((e) => e.elapsed, 'elapsed', const Duration(milliseconds: 1500)),
      );
    });

    test('a level reading with a missing field makes no event', () async {
      expect(await _eventsFor('level', {NativeChannelKeys.level: 0.5}), isEmpty);
    });
  });
}
