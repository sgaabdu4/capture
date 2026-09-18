import 'package:capture/core/data/system/local_app_directories_datasource.dart';
import 'package:capture/features/capture/data/services/parakeet_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transcription_datasource.g.dart';

/// Local Parakeet-TDT-0.6B-v3 (int8) through sherpa-onnx. Audio never
/// leaves the Mac.
abstract interface class ITranscriptionDatasource {
  /// Transcript of a PCM16 16 kHz mono file; empty for silence.
  Future<String> transcribe(String pcmPath);
}

@Riverpod(keepAlive: true)
ITranscriptionDatasource transcriptionDatasource(Ref ref) =>
    SherpaTranscriptionDatasource(ref.read(appDirectoriesProvider).model);

/// Runs in a fresh background isolate per capture: the recogniser (~1.4 GB)
/// is loaded, used and freed, so it holds no memory while idle.
class SherpaTranscriptionDatasource implements ITranscriptionDatasource {
  const SherpaTranscriptionDatasource(this.modelDir);
  final String modelDir;

  @override
  Future<String> transcribe(String pcmPath) =>
      compute(transcribePcm, (dir: modelDir, pcmPath: pcmPath));
}
