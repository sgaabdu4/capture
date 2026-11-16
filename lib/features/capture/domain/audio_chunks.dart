import 'dart:typed_data';

const sampleRate = 16000;

/// Bytes per little-endian PCM16 sample.
const _bytesPerSample = 2;

const _pcm16FullScale = 32768.0;

/// Cut-search windows are 100 ms long.
const _windowsPerSecond = 10;

/// A half-open `[start, end)` range of sample indexes.
typedef SampleRange = ({int start, int end});

Float32List pcm16ToFloat(Uint8List bytes) {
  final count = bytes.length ~/ _bytesPerSample;
  final data = ByteData.sublistView(bytes);
  final out = Float32List(count);
  for (int i = 0; i < count; i++) {
    out[i] = data.getInt16(i * _bytesPerSample, .little) / _pcm16FullScale;
  }
  return out;
}

List<SampleRange> chunkRanges(Float32List samples, {int maxSeconds = 45, int searchSeconds = 8}) {
  final max = maxSeconds * sampleRate;
  final search = searchSeconds * sampleRate;
  final out = <SampleRange>[];
  int start = 0;
  while (samples.length - start > max) {
    final cut = _quietestCut(samples, start + max, search);
    out.add((start: start, end: cut));
    start = cut;
  }
  if (start < samples.length) out.add((start: start, end: samples.length));
  return out;
}

/// A candidate cut and the energy of the window around it.
typedef _Window = ({int cut, double energy});

int _quietestCut(Float32List samples, int hardEnd, int search) {
  const window = sampleRate ~/ _windowsPerSecond;
  const step = window ~/ 2;
  final starts = [for (int w = hardEnd - search; w + window <= hardEnd; w += step) w];
  final quietest = starts.fold<_Window>((cut: hardEnd, energy: double.infinity), (best, w) {
    final energy = _energy(samples, w, w + window);
    return energy < best.energy ? (cut: w + step, energy: energy) : best;
  });
  return quietest.cut;
}

double _energy(Float32List samples, int from, int to) {
  double energy = 0;
  for (int i = from; i < to; i++) {
    energy += samples[i] * samples[i];
  }
  return energy;
}

/// Joins chunk transcripts with single spaces, dropping empty chunks.
String joinTranscripts(Iterable<String> parts) =>
    parts.map((p) => p.trim()).where((p) => p.isNotEmpty).join(' ');
