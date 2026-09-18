// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groups_remote_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(groupsRemoteDatasource)
final groupsRemoteDatasourceProvider = GroupsRemoteDatasourceProvider._();

final class GroupsRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          IGroupsRemoteDatasource,
          IGroupsRemoteDatasource,
          IGroupsRemoteDatasource
        >
    with $Provider<IGroupsRemoteDatasource> {
  GroupsRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groupsRemoteDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groupsRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<IGroupsRemoteDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IGroupsRemoteDatasource create(Ref ref) {
    return groupsRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IGroupsRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IGroupsRemoteDatasource>(value),
    );
  }
}

String _$groupsRemoteDatasourceHash() => r'6e194fc9ace4fc6d7657c06d4d8f2b297ec05823';
