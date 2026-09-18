// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(libraryRepository)
final libraryRepositoryProvider = LibraryRepositoryProvider._();

final class LibraryRepositoryProvider
    extends $FunctionalProvider<ILibraryRepository, ILibraryRepository, ILibraryRepository>
    with $Provider<ILibraryRepository> {
  LibraryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'libraryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryRepositoryHash();

  @$internal
  @override
  $ProviderElement<ILibraryRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ILibraryRepository create(Ref ref) {
    return libraryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ILibraryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ILibraryRepository>(value),
    );
  }
}

String _$libraryRepositoryHash() => r'8a1d7cfda7eb05b79863159e2eb8c91ab623a6eb';
