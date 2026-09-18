// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shortcut_local_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(shortcutLocalDatasource)
final shortcutLocalDatasourceProvider = ShortcutLocalDatasourceProvider._();

final class ShortcutLocalDatasourceProvider
    extends
        $FunctionalProvider<
          IShortcutLocalDatasource,
          IShortcutLocalDatasource,
          IShortcutLocalDatasource
        >
    with $Provider<IShortcutLocalDatasource> {
  ShortcutLocalDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shortcutLocalDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shortcutLocalDatasourceHash();

  @$internal
  @override
  $ProviderElement<IShortcutLocalDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IShortcutLocalDatasource create(Ref ref) {
    return shortcutLocalDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IShortcutLocalDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IShortcutLocalDatasource>(value),
    );
  }
}

String _$shortcutLocalDatasourceHash() => r'4dbcb0a726a6558e336c0bec484b3505243644e3';
