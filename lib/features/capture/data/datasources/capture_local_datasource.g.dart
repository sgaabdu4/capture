// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capture_local_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(captureLocalDatasource)
final captureLocalDatasourceProvider = CaptureLocalDatasourceProvider._();

final class CaptureLocalDatasourceProvider
    extends
        $FunctionalProvider<
          ICaptureLocalDatasource,
          ICaptureLocalDatasource,
          ICaptureLocalDatasource
        >
    with $Provider<ICaptureLocalDatasource> {
  CaptureLocalDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'captureLocalDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$captureLocalDatasourceHash();

  @$internal
  @override
  $ProviderElement<ICaptureLocalDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ICaptureLocalDatasource create(Ref ref) {
    return captureLocalDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ICaptureLocalDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ICaptureLocalDatasource>(value),
    );
  }
}

String _$captureLocalDatasourceHash() => r'db432b1b3c090fae989f0504f672f121788e1cf8';
