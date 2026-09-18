// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_app_directories_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Application Support inside the sandbox container (`$HOME` is the
/// container's Data folder), matching `NSApplicationSupportDirectory`.

@ProviderFor(appDirectories)
final appDirectoriesProvider = AppDirectoriesProvider._();

/// Application Support inside the sandbox container (`$HOME` is the
/// container's Data folder), matching `NSApplicationSupportDirectory`.

final class AppDirectoriesProvider
    extends $FunctionalProvider<AppDirectories, AppDirectories, AppDirectories>
    with $Provider<AppDirectories> {
  /// Application Support inside the sandbox container (`$HOME` is the
  /// container's Data folder), matching `NSApplicationSupportDirectory`.
  AppDirectoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDirectoriesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDirectoriesHash();

  @$internal
  @override
  $ProviderElement<AppDirectories> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDirectories create(Ref ref) {
    return appDirectories(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDirectories value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDirectories>(value),
    );
  }
}

String _$appDirectoriesHash() => r'fe8bb7104751a420a947fa81cdac731112f9a9ed';
