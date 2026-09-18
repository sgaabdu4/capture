// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_available_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// True once Sparkle reports a release newer than this build.

@ProviderFor(updateAvailable)
final updateAvailableProvider = UpdateAvailableProvider._();

/// True once Sparkle reports a release newer than this build.

final class UpdateAvailableProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// True once Sparkle reports a release newer than this build.
  UpdateAvailableProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateAvailableProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateAvailableHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return updateAvailable(ref);
  }
}

String _$updateAvailableHash() => r'6308cace636dac63e4510dc7595e01f37c7464aa';
