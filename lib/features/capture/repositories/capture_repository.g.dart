// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capture_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(captureRepository)
final captureRepositoryProvider = CaptureRepositoryProvider._();

final class CaptureRepositoryProvider
    extends $FunctionalProvider<ICaptureRepository, ICaptureRepository, ICaptureRepository>
    with $Provider<ICaptureRepository> {
  CaptureRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'captureRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$captureRepositoryHash();

  @$internal
  @override
  $ProviderElement<ICaptureRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ICaptureRepository create(Ref ref) {
    return captureRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ICaptureRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ICaptureRepository>(value),
    );
  }
}

String _$captureRepositoryHash() => r'71f6eed37f9cd27a49b9319874d5919d9dd30eab';
