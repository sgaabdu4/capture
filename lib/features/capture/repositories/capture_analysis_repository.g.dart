// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capture_analysis_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(captureAnalysisRepository)
final captureAnalysisRepositoryProvider = CaptureAnalysisRepositoryProvider._();

final class CaptureAnalysisRepositoryProvider
    extends
        $FunctionalProvider<
          ICaptureAnalysisRepository,
          ICaptureAnalysisRepository,
          ICaptureAnalysisRepository
        >
    with $Provider<ICaptureAnalysisRepository> {
  CaptureAnalysisRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'captureAnalysisRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$captureAnalysisRepositoryHash();

  @$internal
  @override
  $ProviderElement<ICaptureAnalysisRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ICaptureAnalysisRepository create(Ref ref) {
    return captureAnalysisRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ICaptureAnalysisRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ICaptureAnalysisRepository>(value),
    );
  }
}

String _$captureAnalysisRepositoryHash() => r'3eef6c3e56bb84e12b66bd268389818aec1e4268';
