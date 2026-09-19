// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_save_local_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(autoSaveLocalDatasource)
final autoSaveLocalDatasourceProvider = AutoSaveLocalDatasourceProvider._();

final class AutoSaveLocalDatasourceProvider
    extends
        $FunctionalProvider<
          IAutoSaveLocalDatasource,
          IAutoSaveLocalDatasource,
          IAutoSaveLocalDatasource
        >
    with $Provider<IAutoSaveLocalDatasource> {
  AutoSaveLocalDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoSaveLocalDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoSaveLocalDatasourceHash();

  @$internal
  @override
  $ProviderElement<IAutoSaveLocalDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IAutoSaveLocalDatasource create(Ref ref) {
    return autoSaveLocalDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IAutoSaveLocalDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IAutoSaveLocalDatasource>(value),
    );
  }
}

String _$autoSaveLocalDatasourceHash() => r'0b7637f05ee9641bdad6c53fd8706c05db7f59f6';
