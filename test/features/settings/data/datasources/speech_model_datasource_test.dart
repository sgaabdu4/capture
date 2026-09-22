import 'dart:io';
import 'dart:typed_data';

import 'package:capture/features/settings/data/datasources/speech_model_datasource.dart';
import 'package:capture/features/settings/domain/values/speech_model_event.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

const _name = 'model.bin';
const _size = 4096;
const _resumeAt = 1000;

/// Synthetic model bytes.
final _bytes = Uint8List.fromList([for (int i = 0; i < _size; i++) i % 251]);

/// A local model host and, once it is closed, the Range header of each
/// request it answered.
typedef _Host = ({HttpServer server, Future<List<String?>> ranges});

/// Serves [body]; with [honourRange] a Range request gets only the tail, as
/// 206.
Future<_Host> _serve(Uint8List body, {bool honourRange = true}) async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  addTearDown(server.close);
  return (server: server, ranges: _answerAll(server, body, honourRange: honourRange));
}

Future<List<String?>> _answerAll(
  HttpServer server,
  Uint8List body, {
  required bool honourRange,
}) async {
  final ranges = <String?>[];
  await for (final request in server) {
    final range = request.headers.value(HttpHeaders.rangeHeader);
    ranges.add(range);
    final from = switch (range) {
      final String r when honourRange => int.parse(r.substring('bytes='.length, r.length - 1)),
      _ => 0,
    };
    request.response.statusCode = from > 0 ? HttpStatus.partialContent : HttpStatus.ok;
    request.response.add(body.sublist(from));
    await request.response.close();
  }
  return ranges;
}

SpeechModelDatasource _model(Directory dir, HttpServer server, {String name = _name}) => .new(
  dir.path,
  baseUrl: 'http://${server.address.host}:${server.port}',
  files: [(name: name, bytes: _size, sha256: sha256.convert(_bytes).toString())],
);

void main() {
  late Directory dir;

  setUp(() => dir = .systemTemp.createTempSync('speech_model_test'));
  tearDown(() => dir.deleteSync(recursive: true));

  test('an interrupted download resumes after the saved bytes and ends ready', () async {
    final (:server, :ranges) = await _serve(_bytes);
    File('${dir.path}/$_name.part').writeAsBytesSync(_bytes.sublist(0, _resumeAt));
    final model = _model(dir, server);

    final events = await model.download().toList();

    await server.close();
    expect(await ranges, equals(['bytes=$_resumeAt-']));
    expect(events.lastOrNull, equals(const SpeechModelEvent.ready()));
    expect(File('${dir.path}/$_name').readAsBytesSync(), equals(_bytes));
    expect(model.isReady(), isTrue);
  });

  test('a server that ignores Range restarts the file from the beginning', () async {
    final (:server, ranges: _) = await _serve(_bytes, honourRange: false);
    File('${dir.path}/$_name.part').writeAsBytesSync(_bytes.sublist(0, _resumeAt));

    final events = await _model(dir, server).download().toList();

    expect(events.lastOrNull, equals(const SpeechModelEvent.ready()));
    expect(File('${dir.path}/$_name').readAsBytesSync(), equals(_bytes));
  });

  test('a file that fails its SHA-256 check is deleted and the model is not ready', () async {
    final corrupt = Uint8List.fromList([for (final b in _bytes) b ^ 1]);
    final (:server, ranges: _) = await _serve(corrupt);
    final model = _model(dir, server);

    final events = await model.download().toList();

    expect(events.lastOrNull, equals(const SpeechModelEvent.failed(.checksum)));
    expect(File('${dir.path}/$_name').existsSync(), isFalse);
    expect(model.isReady(), isFalse);
  });

  test('a file inside a Core ML model folder downloads into that folder', () async {
    const nested = 'Encoder.mlmodelc/weights/weight.bin';
    final (:server, ranges: _) = await _serve(_bytes);
    final model = _model(dir, server, name: nested);

    final events = await model.download().toList();

    expect(events.lastOrNull, equals(const SpeechModelEvent.ready()));
    expect(File('${dir.path}/$nested').readAsBytesSync(), equals(_bytes));
    expect(model.isReady(), isTrue);
  });
}
