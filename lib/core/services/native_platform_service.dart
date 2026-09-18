import 'dart:async';

import 'package:capture/core/services/models/review_card_payload.dart';
import 'package:capture/core/services/native_channel_keys.dart';
import 'package:capture/core/services/native_event.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'native_platform_service.g.dart';

/// A finished recording on disk.
typedef RecordingResult = ({String path, Duration duration});

/// What the app needs from the native side (`macos/Runner/Native`): global hotkey,
/// recorder, overlay panel, menu-bar popover and M4A encoding.
abstract interface class INativePlatformService {
  Stream<NativeEvent> get events;
  Future<void> installMenu();

  /// False when another app already owns the combination. A null [keyCode]
  /// fires when [modifiers] alone are pressed together and released.
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
}

class NativePlatformService implements INativePlatformService {
  static const _channel = MethodChannel(NativeChannelKeys.channel);

  /// Voice-quality AAC; keeps 5 minutes around 1.2 MB, under Notion's free
  /// upload limit.
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
      _ => null,
    };
    if (event != null) _events.add(event);
  }

  NativeEvent? _reviewEvent(Object? arguments) =>
      switch (ReviewAction.values.asNameMap()[arguments]) {
        final ReviewAction action => ReviewCardAction(action),
        null => null,
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
  Future<void> showWorking(String status) =>
      _channel.invokeMethod<void>('showWorking', {NativeChannelKeys.status: status});

  @override
  Future<void> showReview(ReviewCardPayload payload) => _channel.invokeMethod<void>('showReview', {
    NativeChannelKeys.countLine: payload.countLine,
    NativeChannelKeys.canApprove: payload.canApprove,
    NativeChannelKeys.blockedReason: payload.blockedReason,
    NativeChannelKeys.rows: [
      for (final r in payload.rows)
        {
          NativeChannelKeys.id: r.id,
          NativeChannelKeys.icon: r.icon,
          NativeChannelKeys.title: r.title,
          NativeChannelKeys.detail: r.detail,
        },
    ],
  });

  @override
  Future<void> hideOverlay() => _channel.invokeMethod<void>('hideOverlay');

  @override
  Future<void> setMenuState({
    required String nextUp,
    required String latest,
    required bool canRecord,
  }) => _channel.invokeMethod<void>('setMenuState', {
    NativeChannelKeys.nextUp: nextUp,
    NativeChannelKeys.latest: latest,
    NativeChannelKeys.canRecord: canRecord,
  });

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

  Future<void> dispose() => _events.close();
}

@Riverpod(keepAlive: true)
INativePlatformService nativePlatformService(Ref ref) {
  final native = NativePlatformService().._attach();
  ref.onDispose(native.dispose);
  return native;
}
