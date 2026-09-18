// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groups_local_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(groupsLocalDatasource)
final groupsLocalDatasourceProvider = GroupsLocalDatasourceProvider._();

final class GroupsLocalDatasourceProvider
    extends
        $FunctionalProvider<IGroupsLocalDatasource, IGroupsLocalDatasource, IGroupsLocalDatasource>
    with $Provider<IGroupsLocalDatasource> {
  GroupsLocalDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groupsLocalDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groupsLocalDatasourceHash();

  @$internal
  @override
  $ProviderElement<IGroupsLocalDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IGroupsLocalDatasource create(Ref ref) {
    return groupsLocalDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IGroupsLocalDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IGroupsLocalDatasource>(value),
    );
  }
}

String _$groupsLocalDatasourceHash() => r'51dcdb8366bb8ccaac2c02d0c6bb52fc4c060354';
