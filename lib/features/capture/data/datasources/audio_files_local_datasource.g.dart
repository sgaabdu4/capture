// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_files_local_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(audioFilesLocalDatasource)
final audioFilesLocalDatasourceProvider = AudioFilesLocalDatasourceProvider._();

final class AudioFilesLocalDatasourceProvider
    extends
        $FunctionalProvider<
          IAudioFilesLocalDatasource,
          IAudioFilesLocalDatasource,
          IAudioFilesLocalDatasource
        >
    with $Provider<IAudioFilesLocalDatasource> {
  AudioFilesLocalDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audioFilesLocalDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioFilesLocalDatasourceHash();

  @$internal
  @override
  $ProviderElement<IAudioFilesLocalDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IAudioFilesLocalDatasource create(Ref ref) {
    return audioFilesLocalDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IAudioFilesLocalDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IAudioFilesLocalDatasource>(value),
    );
  }
}

String _$audioFilesLocalDatasourceHash() => r'cf9dfbea3f1c4b38d9160951072cda1797199fdb';
