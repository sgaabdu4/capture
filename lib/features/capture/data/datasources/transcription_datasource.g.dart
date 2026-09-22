// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcription_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(transcriptionDatasource)
final transcriptionDatasourceProvider = TranscriptionDatasourceProvider._();

final class TranscriptionDatasourceProvider
    extends
        $FunctionalProvider<
          ITranscriptionDatasource,
          ITranscriptionDatasource,
          ITranscriptionDatasource
        >
    with $Provider<ITranscriptionDatasource> {
  TranscriptionDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transcriptionDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transcriptionDatasourceHash();

  @$internal
  @override
  $ProviderElement<ITranscriptionDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ITranscriptionDatasource create(Ref ref) {
    return transcriptionDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ITranscriptionDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ITranscriptionDatasource>(value),
    );
  }
}

String _$transcriptionDatasourceHash() => r'efdd1ea3f8738f55dcb280ac44ef0e636402943a';
