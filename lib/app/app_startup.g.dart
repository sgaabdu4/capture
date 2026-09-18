// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_startup.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Once per launch: menu-bar item, saved settings and hotkey, crash
/// recovery of unfinished recordings, then a library sync when connected.

@ProviderFor(appStartup)
final appStartupProvider = AppStartupProvider._();

/// Once per launch: menu-bar item, saved settings and hotkey, crash
/// recovery of unfinished recordings, then a library sync when connected.

final class AppStartupProvider extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Once per launch: menu-bar item, saved settings and hotkey, crash
  /// recovery of unfinished recordings, then a library sync when connected.
  AppStartupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appStartupProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appStartupHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return appStartup(ref);
  }
}

String _$appStartupHash() => r'22d83458d1ac6c12544e6eb28e6570374ee61c41';
