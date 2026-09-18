// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groups_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Groups editor state. Groups are archived, never deleted, so existing
/// library relations stay valid.

@ProviderFor(GroupsNotifier)
final groupsProvider = GroupsNotifierProvider._();

/// Groups editor state. Groups are archived, never deleted, so existing
/// library relations stay valid.
final class GroupsNotifierProvider extends $NotifierProvider<GroupsNotifier, GroupsState> {
  /// Groups editor state. Groups are archived, never deleted, so existing
  /// library relations stay valid.
  GroupsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groupsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groupsNotifierHash();

  @$internal
  @override
  GroupsNotifier create() => GroupsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GroupsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GroupsState>(value),
    );
  }
}

String _$groupsNotifierHash() => r'802a35d71094ab9c76ba278286924e39a64fe208';

/// Groups editor state. Groups are archived, never deleted, so existing
/// library relations stay valid.

abstract class _$GroupsNotifier extends $Notifier<GroupsState> {
  GroupsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<GroupsState, GroupsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GroupsState, GroupsState>,
              GroupsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
