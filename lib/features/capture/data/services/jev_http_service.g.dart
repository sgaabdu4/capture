// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jev_http_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(jevHttpService)
final jevHttpServiceProvider = JevHttpServiceProvider._();

final class JevHttpServiceProvider
    extends $FunctionalProvider<IJevHttpService, IJevHttpService, IJevHttpService>
    with $Provider<IJevHttpService> {
  JevHttpServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jevHttpServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jevHttpServiceHash();

  @$internal
  @override
  $ProviderElement<IJevHttpService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IJevHttpService create(Ref ref) {
    return jevHttpService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IJevHttpService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IJevHttpService>(value),
    );
  }
}

String _$jevHttpServiceHash() => r'21d4ab172966012a5b105eed2297b1bc6bb90cfd';
