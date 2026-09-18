// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'due_today_entries_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The first few open tasks due today or earlier, soonest first, for Home's
/// Today card.

@ProviderFor(dueTodayEntries)
final dueTodayEntriesProvider = DueTodayEntriesProvider._();

/// The first few open tasks due today or earlier, soonest first, for Home's
/// Today card.

final class DueTodayEntriesProvider
    extends $FunctionalProvider<List<DueEntry>, List<DueEntry>, List<DueEntry>>
    with $Provider<List<DueEntry>> {
  /// The first few open tasks due today or earlier, soonest first, for Home's
  /// Today card.
  DueTodayEntriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dueTodayEntriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dueTodayEntriesHash();

  @$internal
  @override
  $ProviderElement<List<DueEntry>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<DueEntry> create(Ref ref) {
    return dueTodayEntries(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DueEntry> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DueEntry>>(value),
    );
  }
}

String _$dueTodayEntriesHash() => r'd15351f24b5c32d53926eb406567bd7b8aa67ba5';
