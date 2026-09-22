import 'dart:math';

import 'package:capture/core/services/native_event.dart';
import 'package:capture/core/services/native_platform_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recording_meter_notifier.g.dart';

/// The iPhone pill's waveform bars (0 to 1, newest last) and timer.
typedef RecordingMeter = ({List<double> levels, Duration elapsed});

/// Follows the recorder's level events. A new recording (its time going
/// back) starts from a silent waveform.
@Riverpod(keepAlive: true)
class RecordingMeterNotifier extends _$RecordingMeterNotifier {
  /// Bars in the waveform, as in the Mac overlay (`Overlay.swift`).
  static const bars = 18;

  static final RecordingMeter silent = (
    levels: List<double>.filled(bars, 0),
    elapsed: Duration.zero,
  );

  // The Mac overlay's curve: RMS (about 0.001 to 0.3) in dB, -50 to -10 dB
  // mapped onto 0 to 1, so speech is visible.
  static const _floorRms = 0.0001;
  static const _dbPerDecade = 20;
  static const _silentDb = 50;
  static const _rangeDb = 40;

  static double scaled(double rms) {
    final db = _dbPerDecade * log(max(rms, _floorRms)) / ln10;
    return ((db + _silentDb) / _rangeDb).clamp(0, 1);
  }

  @override
  RecordingMeter build() {
    final events = ref.read(nativePlatformServiceProvider).events.listen(_onEvent);
    ref.onDispose(events.cancel);
    return silent;
  }

  void _onEvent(NativeEvent event) {
    if (event case LevelChanged(:final level, :final elapsed)) {
      final previous = elapsed < state.elapsed ? silent.levels : state.levels;
      state = (levels: [...previous.skip(1), scaled(level)], elapsed: elapsed);
    }
  }
}
