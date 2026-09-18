import 'dart:io';

import 'package:capture/features/capture/domain/audio_chunks.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa;

/// Model directory and PCM16 16 kHz mono file for one transcription.
typedef TranscriptionJob = ({String dir, String pcmPath});

/// Shorter audio than this is treated as silence.
const _minSamples = sampleRate ~/ 4;
const _threads = 4;
const _modelType = 'nemo_transducer';

/// Isolate entry point: loads the recogniser, transcribes, frees it.
String transcribePcm(TranscriptionJob job) {
  final (:dir, :pcmPath) = job;
  sherpa.initBindings();
  final samples = pcm16ToFloat(File(pcmPath).readAsBytesSync());
  if (samples.length < _minSamples) return '';
  final recognizer = sherpa.OfflineRecognizer(
    .new(
      model: .new(
        transducer: .new(
          encoder: '$dir/encoder.int8.onnx',
          decoder: '$dir/decoder.int8.onnx',
          joiner: '$dir/joiner.int8.onnx',
        ),
        tokens: '$dir/tokens.txt',
        modelType: _modelType,
        numThreads: _threads,
        debug: false,
      ),
    ),
  );
  try {
    final parts = <String>[];
    for (final (:start, :end) in chunkRanges(samples)) {
      final stream = recognizer.createStream()
        ..acceptWaveform(samples: samples.sublist(start, end), sampleRate: sampleRate);
      recognizer.decode(stream);
      parts.add(recognizer.getResult(stream).text);
      stream.free();
    }
    return joinTranscripts(parts);
  } finally {
    recognizer.free();
  }
}
