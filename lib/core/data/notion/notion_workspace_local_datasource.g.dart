// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notion_workspace_local_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notionWorkspaceLocalDatasource)
final notionWorkspaceLocalDatasourceProvider = NotionWorkspaceLocalDatasourceProvider._();

final class NotionWorkspaceLocalDatasourceProvider
    extends
        $FunctionalProvider<
          INotionWorkspaceLocalDatasource,
          INotionWorkspaceLocalDatasource,
          INotionWorkspaceLocalDatasource
        >
    with $Provider<INotionWorkspaceLocalDatasource> {
  NotionWorkspaceLocalDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notionWorkspaceLocalDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notionWorkspaceLocalDatasourceHash();

  @$internal
  @override
  $ProviderElement<INotionWorkspaceLocalDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  INotionWorkspaceLocalDatasource create(Ref ref) {
    return notionWorkspaceLocalDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(INotionWorkspaceLocalDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<INotionWorkspaceLocalDatasource>(value),
    );
  }
}

String _$notionWorkspaceLocalDatasourceHash() => r'ffb41dce1b6794c8eb5de32bfb4217089be7e301';
