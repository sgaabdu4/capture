import 'package:capture/core/data/system/local_app_directories_datasource.dart';
import 'package:capture/core/data/system/system_datasource.dart';
import 'package:capture/core/services/native_platform_service.dart';
import 'package:capture/features/capture/data/services/parakeet_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transcription_datasource.g.dart';

/// Local Parakeet-TDT-0.6B-v3: int8 through sherpa-onnx on the Mac, Core ML
/// through FluidAudio on iPhone. Audio never leaves the device.
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

/// Runs in a fresh background isolate per capture: the recogniser (~1.4 GB)
/// is loaded, used and freed, so it holds no memory while idle.
class SherpaTranscriptionDatasource implements ITranscriptionDatasource {
  const SherpaTranscriptionDatasource(this.modelDir);
  final String modelDir;

  @override
  Future<String> transcribe(String pcmPath) =>
      compute(transcribePcm, (dir: modelDir, pcmPath: pcmPath));
}

/// iPhone: FluidAudio in the Swift bridge (`ios/Runner/Native`) loads the
/// Core ML model, transcribes on the Neural Engine and frees it again. A
/// native failure surfaces as an exception, so the capture stays retryable.
class NativeTranscriptionDatasource implements ITranscriptionDatasource {
  const NativeTranscriptionDatasource(this._native, this.modelDir);
  final INativePlatformService _native;
  final String modelDir;

  @override
  Future<String> transcribe(String pcmPath) =>
      _native.transcribe(pcmPath: pcmPath, modelDir: modelDir);
}
