import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class ModelFile {
  const ModelFile(this.name, this.bytes, this.sha256);
  final String name;
  final int bytes;
  final String sha256;
}

/// Parakeet-TDT-0.6B-v3 int8 (sherpa-onnx export), pinned to one Hugging
/// Face revision and verified by SHA-256. Licence: CC-BY-4.0 (NVIDIA).
const parakeetRevision = '2bda32ec70b097a55adaa07d9a7173915b43cc78';
const parakeetBaseUrl =
    'https://huggingface.co/csukuangfj/sherpa-onnx-nemo-parakeet-tdt-0.6b-v3-int8/resolve/$parakeetRevision';
const parakeetFiles = [
  ModelFile(
    'encoder.int8.onnx',
    652184281,
    'acfc2b4456377e15d04f0243af540b7fe7c992f8d898d751cf134c3a55fd2247',
  ),
  ModelFile(
    'decoder.int8.onnx',
    11845275,
    '179e50c43d1a9de79c8a24149a2f9bac6eb5981823f2a2ed88d655b24248db4e',
  ),
  ModelFile(
    'joiner.int8.onnx',
    6355277,
    '3164c13fc2821009440d20fcb5fdc78bff28b4db2f8d0f0b329101719c0948b3',
  ),
  ModelFile(
    'tokens.txt',
    93939,
    'd58544679ea4bc6ac563d1f545eb7d474bd6cfa467f0a6e2c1dc1c7d37e3c35d',
  ),
];

const modelAttribution =
    'Speech recognition: Parakeet-TDT-0.6B-v3 by NVIDIA, licensed CC BY 4.0 '
    '(huggingface.co/nvidia/parakeet-tdt-0.6b-v3); ONNX int8 conversion by '
    'the k2-fsa sherpa-onnx project. Runs entirely on this Mac.';

int get parakeetTotalBytes => parakeetFiles.fold(0, (s, f) => s + f.bytes);

sealed class ModelEvent {
  const ModelEvent();
}

class ModelProgress extends ModelEvent {
  const ModelProgress(this.received, this.total);
  final int received;
  final int total;
  double get fraction => total == 0 ? 0 : received / total;
}

class ModelVerifying extends ModelEvent {
  const ModelVerifying(this.file);
  final String file;
}

class ModelReady extends ModelEvent {
  const ModelReady();
}

class ModelFailed extends ModelEvent {
  const ModelFailed(this.message);
  final String message;
}

/// Downloads the model into [dir] with resume (`.part` files and HTTP
/// Range), checks size and SHA-256 of every file, and only then writes a
/// `verified.json` marker. [isReady] checks the marker and sizes only.
class ModelStore {
  const ModelStore(this.dir, {this.baseUrl = parakeetBaseUrl});
  final String dir;
  final String baseUrl;

  bool get isReady {
    final marker = File('$dir/verified.json');
    if (!marker.existsSync()) return false;
    return parakeetFiles.every((f) {
      final file = File('$dir/${f.name}');
      return file.existsSync() && file.lengthSync() == f.bytes;
    });
  }

  /// Runs in a background isolate; events arrive on the returned stream.
  Stream<ModelEvent> download({List<ModelFile> files = parakeetFiles}) {
    final port = ReceivePort();
    final controller = StreamController<ModelEvent>();
    final target = dir;
    final base = baseUrl;
    port.listen((message) {
      final event = _decodeEvent(message! as List<Object?>);
      controller.add(event);
      if (event is ModelReady || event is ModelFailed) {
        port.close();
        unawaited(controller.close());
      }
    });
    unawaited(
      Isolate.spawn(_downloadMain, [
        port.sendPort,
        target,
        base,
        _encode(files),
      ], onError: port.sendPort),
    );
    return controller.stream;
  }
}

List<List<Object>> _encode(List<ModelFile> files) => [
  for (final f in files) [f.name, f.bytes, f.sha256],
];

ModelEvent _decodeEvent(List<Object?> m) => switch (m.first) {
  'progress' => ModelProgress(m[1]! as int, m[2]! as int),
  'verifying' => ModelVerifying(m[1]! as String),
  'ready' => const ModelReady(),
  'failed' => ModelFailed(m[1]! as String),
  // Uncaught isolate error: [message, stack].
  _ => ModelFailed('${m.first}'),
};

Future<void> _downloadMain(List<Object?> args) async {
  final send = args[0]! as SendPort;
  final dir = args[1]! as String;
  final base = args[2]! as String;
  final files = [
    for (final f in (args[3]! as List<Object?>).cast<List<Object?>>())
      ModelFile(f[0]! as String, f[1]! as int, f[2]! as String),
  ];
  final client = http.Client();
  try {
    await Directory(dir).create(recursive: true);
    final marker = File('$dir/verified.json');
    if (marker.existsSync()) marker.deleteSync();
    final total = files.fold(0, (s, f) => s + f.bytes);
    var done = 0;
    for (final f in files) {
      await _fetch(
        client,
        base,
        dir,
        f,
        (n) => send.send(['progress', done + n, total]),
      );
      done += f.bytes;
      send.send(['verifying', f.name]);
      await _verify(dir, f);
    }
    File('$dir/verified.json').writeAsStringSync(
      jsonEncode({
        'revision': parakeetRevision,
        for (final f in files) f.name: f.sha256,
      }),
    );
    send.send(['ready']);
  } on Object catch (e) {
    send.send(['failed', _message(e)]);
  } finally {
    client.close();
  }
}

String _message(Object e) => switch (e) {
  SocketException() || http.ClientException() =>
    "Couldn't download the speech model. Check your connection and retry; "
        'the download resumes where it stopped.',
  FileSystemException() => 'Not enough disk space for the speech model.',
  _ => e.toString(),
};

Future<void> _fetch(
  http.Client client,
  String base,
  String dir,
  ModelFile f,
  void Function(int) progress,
) async {
  final done = File('$dir/${f.name}');
  if (done.existsSync() && done.lengthSync() == f.bytes) {
    progress(f.bytes);
    return;
  }
  final part = File('$dir/${f.name}.part');
  var have = part.existsSync() ? part.lengthSync() : 0;
  if (have > f.bytes) {
    part.deleteSync();
    have = 0;
  }
  if (have < f.bytes) {
    final request = http.Request('GET', Uri.parse('$base/${f.name}'));
    if (have > 0) request.headers['Range'] = 'bytes=$have-';
    final response = await client.send(request);
    if (response.statusCode == 200 && have > 0) {
      have = 0; // Server ignored Range: start over.
    } else if (response.statusCode != 206 && response.statusCode != 200) {
      throw http.ClientException('HTTP ${response.statusCode}');
    }
    final sink = part.openWrite(
      mode: have == 0 ? FileMode.write : FileMode.append,
    );
    var received = have;
    var lastReport = 0;
    await for (final chunk in response.stream) {
      sink.add(chunk);
      received += chunk.length;
      if (received - lastReport > 1 << 20) {
        lastReport = received;
        progress(received);
      }
    }
    await sink.close();
  }
  if (part.lengthSync() != f.bytes) {
    throw http.ClientException('incomplete download of ${f.name}');
  }
  part.renameSync(done.path);
  progress(f.bytes);
}

Future<void> _verify(String dir, ModelFile f) async {
  final file = File('$dir/${f.name}');
  final digest = await sha256.bind(file.openRead()).first;
  if (digest.toString() != f.sha256) {
    file.deleteSync();
    throw StateError(
      '${f.name} failed its checksum and was deleted. Retry the download.',
    );
  }
}
