import 'dart:io';

/// Speaks [text] with macOS `say` into [wav] as a 16 kHz mono WAV file; returns the process error text, or null on success.
Future<String?> speakToWav(String text, File wav) async {
  final said = await Process.run('say', [
    '-o',
    wav.path,
    '--file-format=WAVE',
    '--data-format=LEI16@16000',
    text,
  ]);
  return said.exitCode == 0 ? null : '${said.stderr}';
}

Future<void> compressToAac(File wav, String output) async {
  await Process.run('afconvert', ['-f', 'm4af', '-d', 'aac', wav.path, output]);
}
