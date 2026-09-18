// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(settingsRepository)
final settingsRepositoryProvider = SettingsRepositoryProvider._();

final class SettingsRepositoryProvider
    extends $FunctionalProvider<ISettingsRepository, ISettingsRepository, ISettingsRepository>
    with $Provider<ISettingsRepository> {
  SettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ISettingsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ISettingsRepository create(Ref ref) {
    return settingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ISettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ISettingsRepository>(value),
    );
  }
}

String _$settingsRepositoryHash() => r'56d1e75e8b0ba1026d1374e1b46a3bff3d31bbb8';
