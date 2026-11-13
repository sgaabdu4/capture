// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capture_flow_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Persist milestones before advancing; approval is the only path to Notion writes and reminders.

@ProviderFor(CaptureFlowNotifier)
final captureFlowProvider = CaptureFlowNotifierProvider._();

/// Persist milestones before advancing; approval is the only path to Notion writes and reminders.
final class CaptureFlowNotifierProvider
    extends $NotifierProvider<CaptureFlowNotifier, CaptureFlowState> {
  /// Persist milestones before advancing; approval is the only path to Notion writes and reminders.
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

String _$captureFlowNotifierHash() => r'93e8a14d636ee44d93a6228d010709371b4fc43b';

/// Persist milestones before advancing; approval is the only path to Notion writes and reminders.

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
