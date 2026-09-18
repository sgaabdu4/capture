// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LibraryNotifier)
final libraryProvider = LibraryNotifierProvider._();

final class LibraryNotifierProvider extends $NotifierProvider<LibraryNotifier, LibraryState> {
  LibraryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'libraryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryNotifierHash();

  @$internal
  @override
  LibraryNotifier create() => LibraryNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LibraryState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LibraryState>(value),
    );
  }
}

String _$libraryNotifierHash() => r'9590a709770888e31029fc60bbe0e9a4134036f8';

abstract class _$LibraryNotifier extends $Notifier<LibraryState> {
  LibraryState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LibraryState, LibraryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LibraryState, LibraryState>,
              LibraryState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
