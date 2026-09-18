// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groups_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(groupsRepository)
final groupsRepositoryProvider = GroupsRepositoryProvider._();

final class GroupsRepositoryProvider
    extends $FunctionalProvider<IGroupsRepository, IGroupsRepository, IGroupsRepository>
    with $Provider<IGroupsRepository> {
  GroupsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groupsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groupsRepositoryHash();

  @$internal
  @override
  $ProviderElement<IGroupsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IGroupsRepository create(Ref ref) {
    return groupsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IGroupsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IGroupsRepository>(value),
    );
  }
}

String _$groupsRepositoryHash() => r'6825865e5e51aac624fc3214309e95ee3373a25e';
