// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_startup.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Once per launch: menu-bar item, saved settings and hotkey, crash
/// recovery of unfinished recordings and owed reminders, then a library sync when connected.

@ProviderFor(appStartup)
final appStartupProvider = AppStartupProvider._();

/// Once per launch: menu-bar item, saved settings and hotkey, crash
/// recovery of unfinished recordings and owed reminders, then a library sync when connected.

final class AppStartupProvider extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Once per launch: menu-bar item, saved settings and hotkey, crash
  /// recovery of unfinished recordings and owed reminders, then a library sync when connected.
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

String _$appStartupHash() => r'30318f487220203199b438edb9ffda74ae713e89';
