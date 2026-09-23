// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capture_flow_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The capture state machine. Every milestone is persisted before the next
/// step (see [CaptureStage]); approval, by the user or by auto-save, is the
/// only path to Notion and to reminders. Native events (hotkey, pill, review
/// card, menu, iPhone record requests) land here. Recording needs only the
/// microphone; a capture made before setup waits, recorded, for a Retry.

@ProviderFor(CaptureFlowNotifier)
final captureFlowProvider = CaptureFlowNotifierProvider._();

/// The capture state machine. Every milestone is persisted before the next
/// step (see [CaptureStage]); approval, by the user or by auto-save, is the
/// only path to Notion and to reminders. Native events (hotkey, pill, review
/// card, menu, iPhone record requests) land here. Recording needs only the
/// microphone; a capture made before setup waits, recorded, for a Retry.
final class CaptureFlowNotifierProvider
    extends $NotifierProvider<CaptureFlowNotifier, CaptureFlowState> {
  /// The capture state machine. Every milestone is persisted before the next
  /// step (see [CaptureStage]); approval, by the user or by auto-save, is the
  /// only path to Notion and to reminders. Native events (hotkey, pill, review
  /// card, menu, iPhone record requests) land here. Recording needs only the
  /// microphone; a capture made before setup waits, recorded, for a Retry.
  CaptureFlowNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'captureFlowProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$captureFlowNotifierHash();

  @$internal
  @override
  CaptureFlowNotifier create() => CaptureFlowNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CaptureFlowState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CaptureFlowState>(value),
    );
  }
}

String _$captureFlowNotifierHash() => r'5f604ecb2bab8ea1d2a52700beb39819e89b4cf1';

/// The capture state machine. Every milestone is persisted before the next
/// step (see [CaptureStage]); approval, by the user or by auto-save, is the
/// only path to Notion and to reminders. Native events (hotkey, pill, review
/// card, menu, iPhone record requests) land here. Recording needs only the
/// microphone; a capture made before setup waits, recorded, for a Retry.

abstract class _$CaptureFlowNotifier extends $Notifier<CaptureFlowState> {
  CaptureFlowState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CaptureFlowState, CaptureFlowState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CaptureFlowState, CaptureFlowState>,
              CaptureFlowState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
