import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:capture/core/data/system/local_app_directories_datasource.dart';
import 'package:capture/core/data/system/system_datasource.dart';
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

/// Parakeet-TDT-0.6B-v3 for iPhone: FluidInference's Core ML conversion
/// (int8 encoder), run by FluidAudio, pinned to one Hugging Face revision
/// and verified by SHA-256. Licence: CC-BY-4.0 (NVIDIA).
const parakeetCoreMlRevisionDigest = '7dd20fe6b1797d35f5e3307e8b1732d9a178edfe';
const parakeetCoreMlBaseUrl =
    'https://huggingface.co/FluidInference/parakeet-tdt-0.6b-v3-coreml/resolve/$parakeetCoreMlRevisionDigest';
const List<ModelFile> parakeetCoreMlFiles = [
  (
    name: 'Decoder.mlmodelc/analytics/coremldata.bin',
    bytes: 243,
    sha256: '4238c4e81ecd0dc94bd7dfbb60f7e2cc824107c1ffe0387b8607b72833dba350',
  ),
  (
    name: 'Decoder.mlmodelc/coremldata.bin',
    bytes: 554,
    sha256: '18647af085d87bd8f3121c8a9b4d4564c1ede038dab63d295b4e745cf2d7fb99',
  ),
  (
    name: 'Decoder.mlmodelc/metadata.json',
    bytes: 3427,
    sha256: 'a39e93cd8371b8ded92635c7804fcd0590f0d1dd9415c6d19a0484be073077d9',
  ),
  (
    name: 'Decoder.mlmodelc/model.mil',
    bytes: 13110,
    sha256: 'ef2a0a281695398a62fde86ac269c68f73d5b578d7ed3b31f2ba91a2d1ea1f35',
  ),
  (
    name: 'Decoder.mlmodelc/weights/weight.bin',
    bytes: 23604992,
    sha256: '48adf0f0d47c406c8253d4f7fef967436a39da14f5a65e66d5a4b407be355d41',
  ),
  (
    name: 'Encoder.mlmodelc/analytics/coremldata.bin',
    bytes: 243,
    sha256: '42e638870d73f26b332918a3496ce36793fbb413a81cbd3d16ba01328637a105',
  ),
  (
    name: 'Encoder.mlmodelc/coremldata.bin',
    bytes: 485,
    sha256: 'd48034a167a82e88fc3df64f60af963ab3983538271175b8319e7d5720a0fb86',
  ),
  (
    name: 'Encoder.mlmodelc/metadata.json',
    bytes: 2921,
    sha256: 'da24da9cca943fb29d7fa8e376d57fca7cb3aa08ca51b956b0b0e56813f087e9',
  ),
  (
    name: 'Encoder.mlmodelc/model.mil',
    bytes: 959769,
    sha256: 'ed7b19156ca29fa7dfd6891deb9fda4b0e8893f68597c985d135736546a43808',
  ),
  (
    name: 'Encoder.mlmodelc/weights/weight.bin',
    bytes: 445187200,
    sha256: 'e2020f323703477a5b21d7c2d282c403e371afb5962e79877e3033e73ba6f421',
  ),
  (
    name: 'JointDecisionv3.mlmodelc/analytics/coremldata.bin',
    bytes: 243,
    sha256: '26def4bf73dd56d29dee21c8ef97cb8969e62f6120ed1adc91e46828e2737b6c',
  ),
  (
    name: 'JointDecisionv3.mlmodelc/coremldata.bin',
    bytes: 521,
    sha256: 'f5fc08b741400f0088492c9e839418b1e18522f19cba28d361dd030c5f398342',
  ),
  (
    name: 'JointDecisionv3.mlmodelc/metadata.json',
    bytes: 3453,
    sha256: 'd9307211b9a37e0f0ac260c7660b1571a3de25841035cfdf9b58fd40425f890f',
  ),
  (
    name: 'JointDecisionv3.mlmodelc/model.mil',
    bytes: 11775,
    sha256: 'be60732943389a047175111a83f8839f3eb39d4803adafa828a0871b2f39818d',
  ),
  (
    name: 'JointDecisionv3.mlmodelc/weights/weight.bin',
    bytes: 12642764,
    sha256: '4e0e63d840032f7f07ddb1d64446051166281e5491bf22da8a945c41f6eedb3e',
  ),
  (
    name: 'Preprocessor.mlmodelc/analytics/coremldata.bin',
    bytes: 243,
    sha256: 'c9beeb989c8d66f8be11df59bc6df277ec76cee404f6865b46243835ef562f6d',
  ),
  (
    name: 'Preprocessor.mlmodelc/coremldata.bin',
    bytes: 486,
    sha256: 'dbde3f2300842c1fd51ef3ff948a0bcffe65ffd2dca10707f2509f32c1d65b1d',
  ),
  (
    name: 'Preprocessor.mlmodelc/metadata.json',
    bytes: 2841,
    sha256: '2a98699e22d279dd37fa1d238aeb1c6db1df0d6fad687775324157689d8f3acf',
  ),
  (
    name: 'Preprocessor.mlmodelc/model.mil',
    bytes: 28181,
    sha256: '4b8518a956450fec57f06c2a21bdffc26973f7f1fa6842fb38fe917f896b6b93',
  ),
  (
    name: 'Preprocessor.mlmodelc/weights/weight.bin',
    bytes: 491072,
    sha256: '129b76e3aeafa8afa3ea76d995b964b145fe83700d579f6ff42c4c38fa0968ea',
  ),
  (
    name: 'parakeet_vocab.json',
    bytes: 151122,
    sha256: '7ec60e05f1b24480736ec0eed40900f4626bce1fa9a60fd700ec7e2a59198735',
  ),
];

int _total(List<ModelFile> files) => files.fold(0, (s, f) => s + f.bytes);

/// The local speech model: readiness check and resumable download.
abstract interface class ISpeechModelDatasource {
  bool isReady();

  /// Download size of every file.
  int get totalBytes;

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
    this.revision = parakeetRevisionDigest,
  });
  final String dir;
  final String baseUrl;
  final List<ModelFile> files;

  /// Recorded in the marker with every file's hash.
  final String revision;

  @override
  int get totalBytes => _total(files);

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
    final job = compute(_runDownload, _ModelDownload(send: port.sendPort, model: this));
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
  const _ModelDownload({required this.send, required this.model});

  final SendPort send;
  final SpeechModelDatasource model;

  String get dir => model.dir;
  String get baseUrl => model.baseUrl;
  List<ModelFile> get files => model.files;
  String get revision => model.revision;

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
      jsonEncode({_markerRevisionKey: revision, for (final f in files) f.name: f.sha256}),
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
    // Core ML models are folders of files.
    await part.parent.create(recursive: true);
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

/// sherpa-onnx files on the Mac, Core ML files on iPhone.
@Riverpod(keepAlive: true)
ISpeechModelDatasource speechModelDatasource(Ref ref) {
  final dir = ref.read(appDirectoriesProvider).model;
  if (!ref.read(systemDatasourceProvider).isPhone) return SpeechModelDatasource(dir);
  return SpeechModelDatasource(
    dir,
    baseUrl: parakeetCoreMlBaseUrl,
    files: parakeetCoreMlFiles,
    revision: parakeetCoreMlRevisionDigest,
  );
}
