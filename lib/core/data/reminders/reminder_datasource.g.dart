// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(reminderDatasource)
final reminderDatasourceProvider = ReminderDatasourceProvider._();

final class ReminderDatasourceProvider
    extends $FunctionalProvider<IReminderDatasource, IReminderDatasource, IReminderDatasource>
    with $Provider<IReminderDatasource> {
  ReminderDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderDatasourceHash();

  @$internal
  @override
  $ProviderElement<IReminderDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IReminderDatasource create(Ref ref) {
    return reminderDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IReminderDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IReminderDatasource>(value),
    );
  }
}

String _$reminderDatasourceHash() => r'82c4d5407c73756e660b9edf51df025a17031311';
