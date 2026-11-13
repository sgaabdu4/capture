// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recording_meter_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// A recording timestamp moving backwards resets the waveform to silence.

@ProviderFor(RecordingMeterNotifier)
final recordingMeterProvider = RecordingMeterNotifierProvider._();

/// A recording timestamp moving backwards resets the waveform to silence.
final class RecordingMeterNotifierProvider
    extends $NotifierProvider<RecordingMeterNotifier, RecordingMeter> {
  /// A recording timestamp moving backwards resets the waveform to silence.
  RecordingMeterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordingMeterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordingMeterNotifierHash();

  @$internal
  @override
  RecordingMeterNotifier create() => RecordingMeterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecordingMeter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecordingMeter>(value),
    );
  }
}

String _$recordingMeterNotifierHash() => r'c7287641209edef4f9d511ccba38c7e878e6fa32';

/// A recording timestamp moving backwards resets the waveform to silence.

abstract class _$RecordingMeterNotifier extends $Notifier<RecordingMeter> {
  RecordingMeter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RecordingMeter, RecordingMeter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RecordingMeter, RecordingMeter>,
              RecordingMeter,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
