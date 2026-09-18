import 'dart:io';
import 'dart:isolate';

import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa;

import '../domain/audio.dart';

class TranscriptionException implements Exception {
  const TranscriptionException(this.message);
  final String message;

  @override
  String toString() => 'TranscriptionException($message)';
}

/// Local Parakeet-TDT-0.6B-v3 (int8) through sherpa-onnx. Runs in a fresh
/// background isolate per capture: the recogniser (~1.4 GB) is loaded,
/// used and freed, so it holds no memory while idle. Audio never leaves the
/// Mac.
class Transcriber {
  const Transcriber(this.modelDir);
  final String modelDir;

  Future<String> transcribe(String pcmPath) {
    final dir = modelDir;
    return Isolate.run(() => _run(dir, pcmPath));
  }
}

String _run(String dir, String pcmPath) {
  sherpa.initBindings();
  final samples = pcm16ToFloat(File(pcmPath).readAsBytesSync());
  if (samples.length < sampleRate ~/ 4) return '';
  final recognizer = sherpa.OfflineRecognizer(
    sherpa.OfflineRecognizerConfig(
      feat: const sherpa.FeatureConfig(sampleRate: sampleRate, featureDim: 80),
      model: sherpa.OfflineModelConfig(
        transducer: sherpa.OfflineTransducerModelConfig(
          encoder: '$dir/encoder.int8.onnx',
          decoder: '$dir/decoder.int8.onnx',
          joiner: '$dir/joiner.int8.onnx',
        ),
        tokens: '$dir/tokens.txt',
        modelType: 'nemo_transducer',
        numThreads: 4,
        debug: false,
      ),
    ),
  );
  try {
    final parts = <String>[];
    for (final (start, end) in chunkRanges(samples)) {
      final stream = recognizer.createStream();
      stream.acceptWaveform(
        samples: samples.sublist(start, end),
        sampleRate: sampleRate,
      );
      recognizer.decode(stream);
      parts.add(recognizer.getResult(stream).text);
      stream.free();
    }
    return joinTranscripts(parts);
  } finally {
    recognizer.free();
  }
}
