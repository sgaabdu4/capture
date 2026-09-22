// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_app_directories_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Application Support inside the sandbox container (`$HOME` is the
/// container's Data folder), matching `NSApplicationSupportDirectory` on the
/// Mac and iPhone.

@ProviderFor(appDirectories)
final appDirectoriesProvider = AppDirectoriesProvider._();

/// Application Support inside the sandbox container (`$HOME` is the
/// container's Data folder), matching `NSApplicationSupportDirectory` on the
/// Mac and iPhone.

final class AppDirectoriesProvider
    extends $FunctionalProvider<AppDirectories, AppDirectories, AppDirectories>
    with $Provider<AppDirectories> {
  /// Application Support inside the sandbox container (`$HOME` is the
  /// container's Data folder), matching `NSApplicationSupportDirectory` on the
  /// Mac and iPhone.
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

String _$appDirectoriesHash() => r'0e1eb558630ffede93ee50d16b78879d84a66ba6';
