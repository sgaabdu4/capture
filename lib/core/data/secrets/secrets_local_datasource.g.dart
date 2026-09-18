// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secrets_local_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(secretsLocalDatasource)
final secretsLocalDatasourceProvider = SecretsLocalDatasourceProvider._();

final class SecretsLocalDatasourceProvider
    extends
        $FunctionalProvider<
          ISecretsLocalDatasource,
          ISecretsLocalDatasource,
          ISecretsLocalDatasource
        >
    with $Provider<ISecretsLocalDatasource> {
  SecretsLocalDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secretsLocalDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secretsLocalDatasourceHash();

  @$internal
  @override
  $ProviderElement<ISecretsLocalDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ISecretsLocalDatasource create(Ref ref) {
    return secretsLocalDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ISecretsLocalDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ISecretsLocalDatasource>(value),
    );
  }
}

String _$secretsLocalDatasourceHash() => r'302af85813643c7bada90075ceb937c5a931a5b8';
