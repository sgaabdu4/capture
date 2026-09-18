import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:capture/core/data/system/local_app_directories_datasource.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/settings/domain/entities/speech_model_failure.dart';
import 'package:capture/features/settings/domain/values/speech_model_event.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'speech_model_datasource.g.dart';

/// One pinned model file: name, size in bytes and SHA-256.
typedef ModelFile = ({String name, int bytes, String sha256});

/// Parakeet-TDT-0.6B-v3 int8 (sherpa-onnx export), pinned to one Hugging
/// Face revision and verified by SHA-256. Licence: CC-BY-4.0 (NVIDIA).
const parakeetRevisionDigest = '2bda32ec70b097a55adaa07d9a7173915b43cc78';
const parakeetBaseUrl =
    'https://huggingface.co/csukuangfj/sherpa-onnx-nemo-parakeet-tdt-0.6b-v3-int8/resolve/$parakeetRevisionDigest';
const List<ModelFile> parakeetFiles = [
  (
    name: 'encoder.int8.onnx',
    bytes: 652184281,
    sha256: 'acfc2b4456377e15d04f0243af540b7fe7c992f8d898d751cf134c3a55fd2247',
  ),
  (
    name: 'decoder.int8.onnx',
    bytes: 11845275,
    sha256: '179e50c43d1a9de79c8a24149a2f9bac6eb5981823f2a2ed88d655b24248db4e',
  ),
  (
    name: 'joiner.int8.onnx',
    bytes: 6355277,
    sha256: '3164c13fc2821009440d20fcb5fdc78bff28b4db2f8d0f0b329101719c0948b3',
  ),
  (
    name: 'tokens.txt',
    bytes: 93939,
    sha256: 'd58544679ea4bc6ac563d1f545eb7d474bd6cfa467f0a6e2c1dc1c7d37e3c35d',
  ),
];

const modelAttribution =
    'Speech recognition: Parakeet-TDT-0.6B-v3 by NVIDIA, licensed CC BY 4.0 (huggingface.co/nvidia/parakeet-tdt-0.6b-v3); ONNX int8 conversion by the k2-fsa sherpa-onnx project. Runs entirely on this Mac.';

int get parakeetTotalBytes => parakeetFiles.fold(0, (s, f) => s + f.bytes);

/// The local speech model: readiness check and resumable download.
abstract interface class ISpeechModelDatasource {
  bool isReady();

  /// Runs in a background isolate. Ends with a ready or failed event for
  /// expected failures (HTTP status, checksum); network and disk exceptions
  /// arrive as the stream's error.
  Stream<SpeechModelEvent> download();
}

/// Downloads the model into [dir] with resume (`.part` files and HTTP
/// Range), checks size and SHA-256 of every file, and only then writes a
/// `verified.json` marker. [isReady] checks the marker and sizes only.
class SpeechModelDatasource implements ISpeechModelDatasource {
  const SpeechModelDatasource(
    this.dir, {
    this.baseUrl = parakeetBaseUrl,
    this.files = parakeetFiles,
  });
  final String dir;
  final String baseUrl;
  final List<ModelFile> files;

  @override
  bool isReady() {
    if (!File(_modelPath(dir, _marker)).existsSync()) return false;
    return files.every((f) {
      final file = File(_modelPath(dir, f.name));
      return file.existsSync() && file.lengthSync() == f.bytes;
    });
  }

  @override
  Stream<SpeechModelEvent> download() async* {
    final port = ReceivePort();
    final job = compute(
      _runDownload,
      _ModelDownload(send: port.sendPort, dir: dir, baseUrl: baseUrl, files: files),
    );
    // The worker's messages are queued before its result, so this marks the
    // end of them. The result itself, or its error, is read from [job].
    final self = port.sendPort;
    unawaited(
      job.then<void>((_) => self.send(_Msg.done), onError: (Object _) => self.send(_Msg.done)),
    );
    await for (final message in port.takeWhile((m) => m != _Msg.done)) {
      if (_decodeEvent(message) case final SpeechModelEvent event) yield event;
    }
    port.close();
    yield switch (await job) {
      Ok() => const .ready(),
      Err(:final failure) => .failed(failure),
    };
  }
}

String _modelPath(String dir, String name) => '$dir/$name';

const _marker = 'verified.json';
const _markerRevisionKey = 'revision';

/// Isolate message tags.
abstract final class _Msg {
  static const progress = 'progress';
  static const verifying = 'verifying';
  static const done = 'done';
}

SpeechModelEvent? _decodeEvent(Object? message) => switch (message) {
  [_Msg.progress, final int received, final int total] => .progress(
    received: received,
    total: total,
  ),
  [_Msg.verifying, final String file] => .verifying(file),
  _ => null,
};

/// Library exceptions (network, disk) propagate to the caller of [compute].
Future<Result<void, SpeechModelFailure>> _runDownload(_ModelDownload download) => download.run();

/// Report progress about once per MiB.
const _progressStep = 1 << 20;

/// One download run; sent to and executed in the worker isolate.
final class _ModelDownload {
  const _ModelDownload({
    required this.send,
    required this.dir,
    required this.baseUrl,
    required this.files,
  });

  final SendPort send;
  final String dir;
  final String baseUrl;
  final List<ModelFile> files;

  String _partPath(ModelFile f) => '${_modelPath(dir, f.name)}.part';

  Future<Result<void, SpeechModelFailure>> run() async {
    final client = http.Client();
    final result = await _downloadAll(client);
    client.close();
    return result;
  }

  Future<Result<void, SpeechModelFailure>> _downloadAll(http.Client client) async {
    await Directory(dir).create(recursive: true);
    final marker = File(_modelPath(dir, _marker));
    if (marker.existsSync()) marker.deleteSync();
    final total = files.fold(0, (s, f) => s + f.bytes);
    int done = 0;
    for (final f in files) {
      final fetched = await _fetch(client, f, (n) => send.send([_Msg.progress, done + n, total]));
      if (fetched case Err()) return fetched;
      done += f.bytes;
      send.send([_Msg.verifying, f.name]);
      final verified = await _verify(f);
      if (verified case Err()) return verified;
    }
    marker.writeAsStringSync(
      jsonEncode({
        _markerRevisionKey: parakeetRevisionDigest,
        for (final f in files) f.name: f.sha256,
      }),
    );
    return const .ok(null);
  }

  Future<Result<void, SpeechModelFailure>> _fetch(
    http.Client client,
    ModelFile f,
    void Function(int) progress,
  ) async {
    final done = File(_modelPath(dir, f.name));
    if (done.existsSync() && done.lengthSync() == f.bytes) {
      progress(f.bytes);
      return const .ok(null);
    }
    final part = File(_partPath(f));
    final have = _resumableBytes(part, f);
    if (have < f.bytes) {
      final streamed = await _stream(client, f, have, progress);
      if (streamed case Err()) return streamed;
    }
    if (part.lengthSync() != f.bytes) return const .err(.network);
    part.renameSync(done.path);
    progress(f.bytes);
    return const .ok(null);
  }

  /// Bytes already saved in [part]; a part larger than [f] is discarded.
  int _resumableBytes(File part, ModelFile f) {
    final existing = part.existsSync() ? part.lengthSync() : 0;
    if (existing <= f.bytes) return existing;
    part.deleteSync();
    return 0;
  }

  /// Downloads [f] into its `.part` file, continuing after [have] bytes
  /// when the server honours Range.
  Future<Result<void, SpeechModelFailure>> _stream(
    http.Client client,
    ModelFile f,
    int have,
    void Function(int) progress,
  ) async {
    final request = http.Request('GET', .parse('$baseUrl/${f.name}'));
    if (have > 0) request.headers[HttpHeaders.rangeHeader] = 'bytes=$have-';
    final response = await client.send(request);
    final status = response.statusCode;
    if (status != HttpStatus.partialContent && status != HttpStatus.ok) {
      return const .err(.network);
    }
    // A plain 200 means the server ignored Range: start over.
    final resume = status == HttpStatus.partialContent && have > 0;
    final sink = File(_partPath(f)).openWrite(mode: resume ? .append : .write);
    int received = resume ? have : 0;
    int lastReport = 0;
    await for (final chunk in response.stream) {
      sink.add(chunk);
      received += chunk.length;
      if (received - lastReport > _progressStep) {
        lastReport = received;
        progress(received);
      }
    }
    await sink.close();
    return const .ok(null);
  }

  Future<Result<void, SpeechModelFailure>> _verify(ModelFile f) async {
    final file = File(_modelPath(dir, f.name));
    final digest = await sha256.bind(file.openRead()).first;
    if (digest.toString() == f.sha256) return const .ok(null);
    file.deleteSync();
    return const .err(.checksum);
  }
}

@Riverpod(keepAlive: true)
ISpeechModelDatasource speechModelDatasource(Ref ref) =>
    SpeechModelDatasource(ref.read(appDirectoriesProvider).model);
