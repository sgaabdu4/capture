// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speech_model_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// sherpa-onnx files on the Mac, Core ML files on iPhone.

@ProviderFor(speechModelDatasource)
final speechModelDatasourceProvider = SpeechModelDatasourceProvider._();

/// sherpa-onnx files on the Mac, Core ML files on iPhone.

final class SpeechModelDatasourceProvider
    extends
        $FunctionalProvider<ISpeechModelDatasource, ISpeechModelDatasource, ISpeechModelDatasource>
    with $Provider<ISpeechModelDatasource> {
  /// sherpa-onnx files on the Mac, Core ML files on iPhone.
  SpeechModelDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'speechModelDatasourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$speechModelDatasourceHash();

  @$internal
  @override
  $ProviderElement<ISpeechModelDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ISpeechModelDatasource create(Ref ref) {
    return speechModelDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ISpeechModelDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ISpeechModelDatasource>(value),
    );
  }
}

String _$speechModelDatasourceHash() => r'2268aa6012d35b051db32121f77eac6a881ebcdf';
