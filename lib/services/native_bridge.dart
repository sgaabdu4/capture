import 'dart:async';

import 'package:capture_native/capture_native.dart';
import 'package:flutter/services.dart';

sealed class NativeEvent {
  const NativeEvent();
}

class HotkeyPressed extends NativeEvent {
  const HotkeyPressed();
}

/// The stop button on the recording pill.
class StopRequested extends NativeEvent {
  const StopRequested();
}

class LimitReached extends NativeEvent {
  const LimitReached();
}

class RecordingFailed extends NativeEvent {
  const RecordingFailed(this.message);
  final String message;
}

/// `yes`, `no`, `edit` or `later` from the review card.
class ReviewAction extends NativeEvent {
  const ReviewAction(this.action);
  final String action;
}

/// `record`, `open`, `settings`, `upcoming` or `recordings` from the menu.
class MenuAction extends NativeEvent {
  const MenuAction(this.action);
  final String action;
}

class RecordingResult {
  const RecordingResult(this.path, this.seconds);
  final String path;
  final double seconds;
}

class ReviewCardRow {
  const ReviewCardRow(this.id, this.icon, this.title, this.detail);
  final String id;

  /// SF Symbol name.
  final String icon;
  final String title;
  final String detail;
}

/// What the app needs from the native side. The real implementation talks
/// to the `capture_native` plugin; tests use a fake.
abstract interface class NativeApi {
  Stream<NativeEvent> get events;
  Future<void> installMenu();
  Future<bool> setHotKey(int keyCode, int modifiers, String label);
  Future<String> micPermission();
  Future<bool> requestMic();
  Future<void> startRecording(String path, {double maxSeconds});
  Future<RecordingResult?> stopRecording();
  Future<void> showWorking(String status);
  Future<void> showReview({
    required String countLine,
    required List<ReviewCardRow> rows,
    required bool canApprove,
    String? blockedReason,
  });
  Future<void> hideOverlay();
  Future<void> setMenuState({String? nextUp, String? latest, bool? canRecord});
  Future<int> encodeM4a(String input, String output, {int bitRate});
  Future<void> showMainWindow();
}

class NativeBridge implements NativeApi {
  NativeBridge() {
    _channel.setMethodCallHandler((call) async {
      final event = switch (call.method) {
        'hotkey' => const HotkeyPressed(),
        'stopRequested' => const StopRequested(),
        'limitReached' => const LimitReached(),
        'recordingFailed' => RecordingFailed(call.arguments as String? ?? ''),
        'review' => ReviewAction(call.arguments as String? ?? ''),
        'menu' => MenuAction(call.arguments as String? ?? ''),
        _ => null,
      };
      if (event != null) _events.add(event);
    });
  }

  static const _channel = MethodChannel(captureNativeChannel);
  final _events = StreamController<NativeEvent>.broadcast();

  @override
  Stream<NativeEvent> get events => _events.stream;

  @override
  Future<void> installMenu() => _channel.invokeMethod('installMenu');

  @override
  Future<bool> setHotKey(int keyCode, int modifiers, String label) async =>
      await _channel.invokeMethod<bool>('setHotKey', {
        'keyCode': keyCode,
        'modifiers': modifiers,
        'label': label,
      }) ??
      false;

  @override
  Future<String> micPermission() async =>
      await _channel.invokeMethod<String>('micPermission') ?? 'denied';

  @override
  Future<bool> requestMic() async =>
      await _channel.invokeMethod<bool>('requestMic') ?? false;

  @override
  Future<void> startRecording(String path, {double maxSeconds = 300}) =>
      _channel.invokeMethod('startRecording', {
        'path': path,
        'maxSeconds': maxSeconds,
      });

  @override
  Future<RecordingResult?> stopRecording() async {
    final result = await _channel.invokeMapMethod<String, Object?>(
      'stopRecording',
    );
    if (result == null) return null;
    return RecordingResult(
      result['path']! as String,
      (result['seconds']! as num).toDouble(),
    );
  }

  @override
  Future<void> showWorking(String status) =>
      _channel.invokeMethod('showWorking', {'status': status});

  @override
  Future<void> showReview({
    required String countLine,
    required List<ReviewCardRow> rows,
    required bool canApprove,
    String? blockedReason,
  }) => _channel.invokeMethod('showReview', {
    'countLine': countLine,
    'canApprove': canApprove,
    'blockedReason': blockedReason,
    'rows': [
      for (final r in rows)
        {'id': r.id, 'icon': r.icon, 'title': r.title, 'detail': r.detail},
    ],
  });

  @override
  Future<void> hideOverlay() => _channel.invokeMethod('hideOverlay');

  @override
  Future<void> setMenuState({
    String? nextUp,
    String? latest,
    bool? canRecord,
  }) => _channel.invokeMethod('setMenuState', {
    'nextUp': ?nextUp,
    'latest': ?latest,
    'canRecord': ?canRecord,
  });

  @override
  Future<int> encodeM4a(
    String input,
    String output, {
    int bitRate = 32000,
  }) async =>
      await _channel.invokeMethod<int>('encodeM4a', {
        'input': input,
        'output': output,
        'bitRate': bitRate,
      }) ??
      0;

  @override
  Future<void> showMainWindow() => _channel.invokeMethod('showMainWindow');
}
