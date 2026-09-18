import 'dart:typed_data';

const sampleRate = 16000;

/// Converts little-endian PCM16 bytes to Float32 samples in [-1, 1]. A
/// trailing odd byte (a crash mid-write) is ignored.
Float32List pcm16ToFloat(Uint8List bytes) {
  final count = bytes.length ~/ 2;
  final data = ByteData.sublistView(bytes);
  final out = Float32List(count);
  for (var i = 0; i < count; i++) {
    out[i] = data.getInt16(i * 2, Endian.little) / 32768.0;
  }
  return out;
}

/// Splits long audio into chunks of at most [maxSeconds], cutting at the
/// quietest 100 ms window within the last [searchSeconds] of each chunk so
/// words are not cut in half. Returns half-open sample ranges covering all
/// samples exactly once.
List<(int, int)> chunkRanges(Float32List samples, {int maxSeconds = 45, int searchSeconds = 8}) {
  final max = maxSeconds * sampleRate;
  final search = searchSeconds * sampleRate;
  const window = sampleRate ~/ 10;
  final out = <(int, int)>[];
  var start = 0;
  while (samples.length - start > max) {
    final hardEnd = start + max;
    var best = hardEnd;
    var bestEnergy = double.infinity;
    for (var w = hardEnd - search; w + window <= hardEnd; w += window ~/ 2) {
      var energy = 0.0;
      for (var i = w; i < w + window; i++) {
        energy += samples[i] * samples[i];
      }
      if (energy < bestEnergy) {
        bestEnergy = energy;
        best = w + window ~/ 2;
      }
    }
    out.add((start, best));
    start = best;
  }
  if (start < samples.length) out.add((start, samples.length));
  return out;
}

/// Joins chunk transcripts with single spaces, dropping empty chunks.
String joinTranscripts(Iterable<String> parts) =>
    parts.map((p) => p.trim()).where((p) => p.isNotEmpty).join(' ');
