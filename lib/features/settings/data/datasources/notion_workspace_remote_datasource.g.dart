// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notion_workspace_remote_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notionWorkspaceRemoteDatasource)
final notionWorkspaceRemoteDatasourceProvider = NotionWorkspaceRemoteDatasourceProvider._();

final class NotionWorkspaceRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          INotionWorkspaceRemoteDatasource,
          INotionWorkspaceRemoteDatasource,
          INotionWorkspaceRemoteDatasource
        >
    with $Provider<INotionWorkspaceRemoteDatasource> {
  NotionWorkspaceRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notionWorkspaceRemoteDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notionWorkspaceRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<INotionWorkspaceRemoteDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  INotionWorkspaceRemoteDatasource create(Ref ref) {
    return notionWorkspaceRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(INotionWorkspaceRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<INotionWorkspaceRemoteDatasource>(value),
    );
  }
}

String _$notionWorkspaceRemoteDatasourceHash() => r'7b3f74d807c06f515bfe7fbfcb4cb7c2ff355dea';
