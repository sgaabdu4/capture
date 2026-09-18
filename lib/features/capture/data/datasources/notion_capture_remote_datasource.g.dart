// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notion_capture_remote_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notionCaptureRemoteDatasource)
final notionCaptureRemoteDatasourceProvider = NotionCaptureRemoteDatasourceProvider._();

final class NotionCaptureRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          INotionCaptureRemoteDatasource,
          INotionCaptureRemoteDatasource,
          INotionCaptureRemoteDatasource
        >
    with $Provider<INotionCaptureRemoteDatasource> {
  NotionCaptureRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notionCaptureRemoteDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notionCaptureRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<INotionCaptureRemoteDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  INotionCaptureRemoteDatasource create(Ref ref) {
    return notionCaptureRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(INotionCaptureRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<INotionCaptureRemoteDatasource>(value),
    );
  }
}

String _$notionCaptureRemoteDatasourceHash() => r'31916c2462fd64a0e2d1226aaf63aa5a6fd4a288';
