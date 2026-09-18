// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_remote_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(libraryRemoteDatasource)
final libraryRemoteDatasourceProvider = LibraryRemoteDatasourceProvider._();

final class LibraryRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          ILibraryRemoteDatasource,
          ILibraryRemoteDatasource,
          ILibraryRemoteDatasource
        >
    with $Provider<ILibraryRemoteDatasource> {
  LibraryRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'libraryRemoteDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<ILibraryRemoteDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ILibraryRemoteDatasource create(Ref ref) {
    return libraryRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ILibraryRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ILibraryRemoteDatasource>(value),
    );
  }
}

String _$libraryRemoteDatasourceHash() => r'c60318f302aba7b6c36fce9c366a34afded31154';
