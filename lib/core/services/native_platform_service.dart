import 'dart:async';

import 'package:capture/core/crash/crash.dart';
import 'package:capture/core/services/models/review_card_payload.dart';
import 'package:capture/core/services/models/review_card_row.dart';
import 'package:capture/core/services/native_channel_keys.dart';
import 'package:capture/core/services/native_event.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'native_platform_service.g.dart';

/// A finished recording on disk.
typedef RecordingResult = ({String path, Duration duration});

/// Native hotkey/recording, overlay/menu, M4A and Sparkle; iPhone adds requests/Core ML and ignores Mac-only calls.
abstract interface class INativePlatformService {
  Stream<NativeEvent> get events;
  Future<void> installMenu();

  /// False when another app owns the hotkey; null [keyCode] fires [modifiers] alone on release.
  Future<bool> setHotKey({required int? keyCode, required int modifiers, required String label});

  /// Ignores the global shortcut while a new one is being recorded.
  Future<void> pauseHotKey({required bool paused});
  Future<MicPermission> micPermission();
  Future<bool> requestMic();
  Future<void> startRecording(String path, {required Duration limit});

  /// Null when nothing was recording.
  Future<RecordingResult?> stopRecording();
  Future<void> showWorking(String status);
  Future<void> showReview(ReviewCardPayload payload);
  Future<void> hideOverlay();
  Future<void> setMenuState({
    required String nextUp,
    required String latest,
    required bool canRecord,
  });

  /// Returns the encoded file size in bytes.
  Future<int> encodeM4a({required String input, required String output});
  Future<void> showMainWindow();

  /// Opens Sparkle's download/install offer for a newer release.
  Future<void> checkForUpdates();

  /// iPhone cold-launch request, consumed once; later requests arrive as [RecordRequested].
  Future<bool> takeRecordRequest();

  /// iPhone Core ML transcribes PCM16 mono 16 kHz, loading and freeing the model in [modelDir].
  Future<String> transcribe({required String pcmPath, required String modelDir});
}

class NativePlatformService implements INativePlatformService {
  static const _channel = MethodChannel(NativeChannelKeys.channel);

  /// Voice-quality AAC keeps five minutes near 1.2 MB, below Notion's free upload limit.
  static const _m4aBitRate = 32000;

  final _events = StreamController<NativeEvent>.broadcast();

  void _attach() => _channel.setMethodCallHandler(_onCall);

  Future<void> _onCall(MethodCall call) async {
    final event = switch (call.method) {
      'hotkey' => const HotkeyPressed(),
      'stopRequested' => const StopRequested(),
      'limitReached' => const LimitReached(),
      'recordingFailed' => const RecordingFailed(),
      'review' => _reviewEvent(call.arguments),
      'menu' => _menuEvent(call.arguments),
      'updateAvailable' => const UpdateAvailable(),
      'recordRequested' => const RecordRequested(),
      'level' => _levelEvent(call.arguments),
      _ => null,
    };
    if (event != null) _events.add(event);
  }

  NativeEvent? _reviewEvent(Object? arguments) =>
      switch (ReviewAction.values.asNameMap()[arguments]) {
        final ReviewAction action => ReviewCardAction(action),
        null => null,
      };

  NativeEvent? _levelEvent(Object? arguments) => switch (arguments) {
    {NativeChannelKeys.level: final num level, NativeChannelKeys.seconds: final num seconds} =>
      LevelChanged(
        level: level.toDouble(),
        elapsed: .new(milliseconds: (seconds * Duration.millisecondsPerSecond).round()),
      ),
    _ => null,
  };

  NativeEvent? _menuEvent(Object? arguments) => switch (MenuAction.values.asNameMap()[arguments]) {
    final MenuAction action => MenuCommand(action),
    null => null,
  };

  @override
  Stream<NativeEvent> get events => _events.stream;

  @override
  Future<void> installMenu() => _channel.invokeMethod<void>('installMenu');

  @override
  Future<bool> setHotKey({
    required int? keyCode,
    required int modifiers,
    required String label,
  }) async {
    final registered = await _channel.invokeMethod<bool>('setHotKey', {
      NativeChannelKeys.keyCode: keyCode,
      NativeChannelKeys.modifiers: modifiers,
      NativeChannelKeys.label: label,
    });
    return registered == true;
  }

  @override
  Future<void> pauseHotKey({required bool paused}) =>
      _channel.invokeMethod<void>('pauseHotKey', {NativeChannelKeys.paused: paused});

  @override
  Future<MicPermission> micPermission() async {
    final name = await _channel.invokeMethod<String>('micPermission');
    return MicPermission.values.asNameMap()[name] ?? .denied;
  }

  @override
  Future<bool> requestMic() async {
    final granted = await _channel.invokeMethod<bool>('requestMic');
    return granted == true;
  }

  @override
  Future<void> startRecording(String path, {required Duration limit}) =>
      _channel.invokeMethod<void>('startRecording', {
        NativeChannelKeys.path: path,
        NativeChannelKeys.maxSeconds: limit.inMilliseconds / Duration.millisecondsPerSecond,
      });

  @override
  Future<RecordingResult?> stopRecording() async {
    final result = await _channel.invokeMapMethod<String, Object?>('stopRecording');
    return switch (result) {
      {NativeChannelKeys.path: final String path, NativeChannelKeys.seconds: final num seconds} => (
        path: path,
        duration: Duration(milliseconds: (seconds * Duration.millisecondsPerSecond).round()),
      ),
      _ => null,
    };
  }

  @override
  Future<void> showWorking(String status) async {
    try {
      await _channel.invokeMethod<void>('showWorking', {NativeChannelKeys.status: status});
    } catch (error, stackTrace) {
      Crash.error(error, stackTrace);
    }
  }

  @override
  Future<void> showReview(ReviewCardPayload payload) async {
    try {
      final ReviewCardPayload(:countLine, :canApprove, :blockedReason, :rows) = payload;
      await _channel.invokeMethod<void>('showReview', {
        NativeChannelKeys.countLine: countLine,
        NativeChannelKeys.canApprove: canApprove,
        NativeChannelKeys.blockedReason: blockedReason,
        NativeChannelKeys.rows: [
          for (final ReviewCardRow(:id, :icon, :title, :detail) in rows)
            {
              NativeChannelKeys.id: id,
              NativeChannelKeys.icon: icon,
              NativeChannelKeys.title: title,
              NativeChannelKeys.detail: detail,
            },
        ],
      });
    } catch (error, stackTrace) {
      Crash.error(error, stackTrace);
    }
  }

  @override
  Future<void> hideOverlay() async {
    try {
      await _channel.invokeMethod<void>('hideOverlay');
    } catch (error, stackTrace) {
      Crash.error(error, stackTrace);
    }
  }

  @override
  Future<void> setMenuState({
    required String nextUp,
    required String latest,
    required bool canRecord,
  }) async {
    try {
      await _channel.invokeMethod<void>('setMenuState', {
        NativeChannelKeys.nextUp: nextUp,
        NativeChannelKeys.latest: latest,
        NativeChannelKeys.canRecord: canRecord,
      });
    } catch (error, stackTrace) {
      Crash.error(error, stackTrace);
    }
  }

  @override
  Future<int> encodeM4a({required String input, required String output}) async {
    final bytes = await _channel.invokeMethod<int>('encodeM4a', {
      NativeChannelKeys.input: input,
      NativeChannelKeys.output: output,
      NativeChannelKeys.bitRate: _m4aBitRate,
    });
    return switch (bytes) {
      final int size => size,
      null => 0,
    };
  }

  @override
  Future<void> showMainWindow() => _channel.invokeMethod<void>('showMainWindow');

  @override
  Future<void> checkForUpdates() async {
    try {
      await _channel.invokeMethod<void>('checkForUpdates');
    } catch (error, stackTrace) {
      Crash.error(error, stackTrace);
    }
  }

  @override
  Future<bool> takeRecordRequest() async =>
      await _channel.invokeMethod<bool>('takeRecordRequest') == true;

  @override
  Future<String> transcribe({required String pcmPath, required String modelDir}) async =>
      await _channel.invokeMethod<String>('transcribe', {
        NativeChannelKeys.path: pcmPath,
        NativeChannelKeys.modelDir: modelDir,
      }) ??
      '';

  Future<void> dispose() => _events.close();
}

@Riverpod(keepAlive: true)
INativePlatformService nativePlatformService(Ref ref) {
  final native = NativePlatformService().._attach();
  ref.onDispose(native.dispose);
  return native;
}
