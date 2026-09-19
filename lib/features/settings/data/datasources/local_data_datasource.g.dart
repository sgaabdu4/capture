// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_data_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localDataDatasource)
final localDataDatasourceProvider = LocalDataDatasourceProvider._();

final class LocalDataDatasourceProvider
    extends $FunctionalProvider<ILocalDataDatasource, ILocalDataDatasource, ILocalDataDatasource>
    with $Provider<ILocalDataDatasource> {
  LocalDataDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localDataDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localDataDatasourceHash();

  @$internal
  @override
  $ProviderElement<ILocalDataDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ILocalDataDatasource create(Ref ref) {
    return localDataDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ILocalDataDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ILocalDataDatasource>(value),
    );
  }
}

String _$localDataDatasourceHash() => r'8bb55433f4b436e80ae6e748283962aee8e0b195';
