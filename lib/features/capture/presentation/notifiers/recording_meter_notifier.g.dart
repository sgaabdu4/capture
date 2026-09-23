// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recording_meter_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Follows the recorder's level events. A new recording (its time going
/// back) starts from a silent waveform.

@ProviderFor(RecordingMeterNotifier)
final recordingMeterProvider = RecordingMeterNotifierProvider._();

/// Follows the recorder's level events. A new recording (its time going
/// back) starts from a silent waveform.
final class RecordingMeterNotifierProvider
    extends $NotifierProvider<RecordingMeterNotifier, RecordingMeter> {
  /// Follows the recorder's level events. A new recording (its time going
  /// back) starts from a silent waveform.
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

String _$recordingMeterNotifierHash() => r'3e093a6eed5afea227b0eea4a5d36274e03c18ae';

/// Follows the recorder's level events. A new recording (its time going
/// back) starts from a silent waveform.

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
