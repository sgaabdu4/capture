// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'native_platform_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(nativePlatformService)
final nativePlatformServiceProvider = NativePlatformServiceProvider._();

final class NativePlatformServiceProvider
    extends
        $FunctionalProvider<INativePlatformService, INativePlatformService, INativePlatformService>
    with $Provider<INativePlatformService> {
  NativePlatformServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nativePlatformServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nativePlatformServiceHash();

  @$internal
  @override
  $ProviderElement<INativePlatformService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  INativePlatformService create(Ref ref) {
    return nativePlatformService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(INativePlatformService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<INativePlatformService>(value),
    );
  }
}

String _$nativePlatformServiceHash() => r'057fa2c613cdbb9940f7c2568a11344cc361c41e';
