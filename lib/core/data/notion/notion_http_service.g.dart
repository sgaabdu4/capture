// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notion_http_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notionHttpService)
final notionHttpServiceProvider = NotionHttpServiceProvider._();

final class NotionHttpServiceProvider
    extends $FunctionalProvider<INotionHttpService, INotionHttpService, INotionHttpService>
    with $Provider<INotionHttpService> {
  NotionHttpServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notionHttpServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notionHttpServiceHash();

  @$internal
  @override
  $ProviderElement<INotionHttpService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  INotionHttpService create(Ref ref) {
    return notionHttpService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(INotionHttpService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<INotionHttpService>(value),
    );
  }
}

String _$notionHttpServiceHash() => r'c238eeb7b952fd503e12bee204cbf0837e32a13b';
