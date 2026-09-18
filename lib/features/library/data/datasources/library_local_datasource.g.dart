// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_local_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(libraryLocalDatasource)
final libraryLocalDatasourceProvider = LibraryLocalDatasourceProvider._();

final class LibraryLocalDatasourceProvider
    extends
        $FunctionalProvider<
          ILibraryLocalDatasource,
          ILibraryLocalDatasource,
          ILibraryLocalDatasource
        >
    with $Provider<ILibraryLocalDatasource> {
  LibraryLocalDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'libraryLocalDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryLocalDatasourceHash();

  @$internal
  @override
  $ProviderElement<ILibraryLocalDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ILibraryLocalDatasource create(Ref ref) {
    return libraryLocalDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ILibraryLocalDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ILibraryLocalDatasource>(value),
    );
  }
}

String _$libraryLocalDatasourceHash() => r'3ddc1a409c17f4c304ccb2a3bd648da5c6cc9197';
