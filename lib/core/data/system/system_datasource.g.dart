// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(systemDatasource)
final systemDatasourceProvider = SystemDatasourceProvider._();

final class SystemDatasourceProvider
    extends $FunctionalProvider<ISystemDatasource, ISystemDatasource, ISystemDatasource>
    with $Provider<ISystemDatasource> {
  SystemDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'systemDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$systemDatasourceHash();

  @$internal
  @override
  $ProviderElement<ISystemDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ISystemDatasource create(Ref ref) {
    return systemDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ISystemDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ISystemDatasource>(value),
    );
  }
}

String _$systemDatasourceHash() => r'87ae6d5776b7c5bc55cea954fff1285e4e904f49';
