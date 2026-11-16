import 'package:capture/core/data/system/local_app_directories_datasource.dart';
import 'package:capture/core/data/system/system_datasource.dart';
import 'package:capture/core/services/native_platform_service.dart';
import 'package:capture/features/capture/data/services/parakeet_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transcription_datasource.g.dart';

abstract interface class ITranscriptionDatasource {
  /// Transcript of a PCM16 16 kHz mono file; empty for silence.
  Future<String> transcribe(String pcmPath);
}

@Riverpod(keepAlive: true)
ITranscriptionDatasource transcriptionDatasource(Ref ref) {
  final model = ref.read(appDirectoriesProvider).model;
  if (!ref.read(systemDatasourceProvider).isPhone) return SherpaTranscriptionDatasource(model);
  return NativeTranscriptionDatasource(ref.read(nativePlatformServiceProvider), model);
}

class SherpaTranscriptionDatasource implements ITranscriptionDatasource {
  const SherpaTranscriptionDatasource(this.modelDir);
  final String modelDir;

  @override
  Future<String> transcribe(String pcmPath) =>
      compute(transcribePcm, (dir: modelDir, pcmPath: pcmPath));
}

class NativeTranscriptionDatasource implements ITranscriptionDatasource {
  const NativeTranscriptionDatasource(this._native, this.modelDir);
  final INativePlatformService _native;
  final String modelDir;

  @override
  Future<String> transcribe(String pcmPath) =>
      _native.transcribe(pcmPath: pcmPath, modelDir: modelDir);
}
