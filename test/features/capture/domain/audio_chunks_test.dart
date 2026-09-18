import 'dart:typed_data';

import 'package:capture/features/capture/domain/audio_chunks.dart';
import 'package:test/test.dart';

void main() {
  test('pcm16ToFloat maps full scale into [-1, 1] and ignores a trailing odd byte', () {
    final samples = pcm16ToFloat(.fromList([0x00, 0x80, 0xFF, 0x7F, 0x01]));
    expect(samples, equals([-1.0, 32767 / 32768]));
  });

  test('chunkRanges covers every sample once and cuts at the quietest window', () {
    const seconds = 10;
    final samples = Float32List(seconds * sampleRate)..fillRange(0, seconds * sampleRate, 0.5);
    // 100 ms of silence starting at 2.5 s, inside the first chunk's search range.
    const quietStart = 40000;
    samples.fillRange(quietStart, quietStart + sampleRate ~/ 10, 0);

    final ranges = chunkRanges(samples, maxSeconds: 3, searchSeconds: 1);

    expect(
      ranges.map((r) => r.start),
      equals([0, ...ranges.map((r) => r.end).take(ranges.length - 1)]),
    );
    expect(ranges.last.end, equals(samples.length));
    expect(ranges.every((r) => r.end - r.start <= 3 * sampleRate), isTrue);
    expect(ranges.firstOrNull?.end, equals(quietStart + sampleRate ~/ 20));
  });

  test('chunkRanges keeps short audio as one range and empty audio as none', () {
    expect(chunkRanges(.new(sampleRate)), equals([(start: 0, end: sampleRate)]));
    expect(chunkRanges(.new(0)), isEmpty);
  });

  test('joinTranscripts joins chunk texts with single spaces and drops empty chunks', () {
    expect(joinTranscripts([' Buy milk ', '', '  ', 'and bread']), equals('Buy milk and bread'));
  });
}
