// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capture_save_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(captureSaveRepository)
final captureSaveRepositoryProvider = CaptureSaveRepositoryProvider._();

final class CaptureSaveRepositoryProvider
    extends
        $FunctionalProvider<ICaptureSaveRepository, ICaptureSaveRepository, ICaptureSaveRepository>
    with $Provider<ICaptureSaveRepository> {
  CaptureSaveRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'captureSaveRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$captureSaveRepositoryHash();

  @$internal
  @override
  $ProviderElement<ICaptureSaveRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ICaptureSaveRepository create(Ref ref) {
    return captureSaveRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ICaptureSaveRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ICaptureSaveRepository>(value),
    );
  }
}

String _$captureSaveRepositoryHash() => r'de9f2f67606f8422145efe92c16c0005ac8c8891';
