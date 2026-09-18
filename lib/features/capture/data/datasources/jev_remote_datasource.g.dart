// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jev_remote_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(jevRemoteDatasource)
final jevRemoteDatasourceProvider = JevRemoteDatasourceProvider._();

final class JevRemoteDatasourceProvider
    extends $FunctionalProvider<IJevRemoteDatasource, IJevRemoteDatasource, IJevRemoteDatasource>
    with $Provider<IJevRemoteDatasource> {
  JevRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jevRemoteDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jevRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<IJevRemoteDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IJevRemoteDatasource create(Ref ref) {
    return jevRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IJevRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IJevRemoteDatasource>(value),
    );
  }
}

String _$jevRemoteDatasourceHash() => r'e92b29733605a84e2ea3c832890cb74f5951e993';
