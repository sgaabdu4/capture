// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localDatabase)
final localDatabaseProvider = LocalDatabaseProvider._();

final class LocalDatabaseProvider extends $FunctionalProvider<Database, Database, Database>
    with $Provider<Database> {
  LocalDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localDatabaseHash();

  @$internal
  @override
  $ProviderElement<Database> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Database create(Ref ref) {
    return localDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Database value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Database>(value));
  }
}

String _$localDatabaseHash() => r'1e38c75cc3085a12b6d84c7326c8e71cd04d12b1';

@ProviderFor(keyValueLocalDatasource)
final keyValueLocalDatasourceProvider = KeyValueLocalDatasourceProvider._();

final class KeyValueLocalDatasourceProvider
    extends
        $FunctionalProvider<
          IKeyValueLocalDatasource,
          IKeyValueLocalDatasource,
          IKeyValueLocalDatasource
        >
    with $Provider<IKeyValueLocalDatasource> {
  KeyValueLocalDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keyValueLocalDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keyValueLocalDatasourceHash();

  @$internal
  @override
  $ProviderElement<IKeyValueLocalDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IKeyValueLocalDatasource create(Ref ref) {
    return keyValueLocalDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IKeyValueLocalDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IKeyValueLocalDatasource>(value),
    );
  }
}

String _$keyValueLocalDatasourceHash() => r'c4e30ec28d77c04f71eb74fd58ae537ae107a7e1';
