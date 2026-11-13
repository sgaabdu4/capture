import 'dart:convert';
import 'dart:io';

import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/data/secrets/secrets_local_datasource.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:http_parser/http_parser.dart';

import '../../../helpers/test_fakes.dart';

const _token = 'test-token';
final _png = MediaType('image', 'png');
const _bytes = [1, 2, 3, 4];

typedef _Run = ({NotionResult<String> result, List<http.Request> sent});

Future<_Run> _upload(
  http.Response Function(http.Request request) respond, {
  bool withToken = true,
}) async {
  final sent = <http.Request>[];
  final service = NotionHttpService(
    FakeSecrets({if (withToken) Secret.notionToken: _token}),
    client: MockClient((request) async {
      sent.add(request);
      return respond(request);
    }),
  );
  final result = await service.uploadFile(_bytes, filename: 'note.png', type: _png);
  service.close();
  return (result: result, sent: sent);
}

http.Response _json(Object body, [int status = HttpStatus.ok]) =>
    http.Response(jsonEncode(body), status);

NotionFailure? _failure(NotionResult<String> result) => switch (result) {
  Err(:final failure) => failure,
  Ok() => null,
};

void main() {
  test('uploadFile creates a single part upload, sends the file and returns the id', () async {
    final run = await _upload(
      (request) => request.url.path == '/v1/file_uploads' ? _json({'id': 'up-1'}) : _json({}),
    );
    expect(run.sent, hasLength(2));
    final create = run.sent.first;
    expect(create.method, equals('POST'));
    expect(create.url.toString(), equals('${NotionHttpService.baseUrl}/v1/file_uploads'));
    expect(
      jsonDecode(create.body),
      equals({'mode': 'single_part', 'filename': 'note.png', 'content_type': 'image/png'}),
    );
    final send = run.sent.last;
    final sendBody = latin1.decode(send.bodyBytes);
    expect(send.method, equals('POST'));
    expect(send.url.toString(), equals('${NotionHttpService.baseUrl}/v1/file_uploads/up-1/send'));
    expect(send.headers[HttpHeaders.authorizationHeader], equals('Bearer $_token'));
    expect(send.headers['Notion-Version'], equals(notionVersion));
    expect(send.headers[HttpHeaders.contentTypeHeader], startsWith('multipart/form-data'));
    expect(sendBody, contains('name="file"'));
    expect(sendBody, contains('filename="note.png"'));
    expect(sendBody.toLowerCase(), contains('content-type: image/png'));
    expect(send.bodyBytes.indexOfSubsequence(_bytes), isNonNegative);
    expect(run.result.valueOrNull, equals('up-1'));
  });

  test(
    'uploadFile with a create answer without an id is an invalid request and sends nothing',
    () async {
      final run = await _upload((_) => _json({'object': 'file_upload'}));
      expect(_failure(run.result), equals(NotionFailure.invalidRequest));
      expect(run.sent, hasLength(1));
    },
  );

  test('uploadFile with a rejected create call returns that failure and sends nothing', () async {
    final run = await _upload((_) => _json({}, HttpStatus.unauthorized));
    expect(_failure(run.result), equals(NotionFailure.invalidToken));
    expect(run.sent, hasLength(1));
  });

  test('uploadFile without a stored token is an invalid token and makes no request', () async {
    final run = await _upload((_) => _json({'id': 'up-1'}), withToken: false);
    expect(_failure(run.result), equals(NotionFailure.invalidToken));
    expect(run.sent, isEmpty);
  });

  test('uploadFile with a rejected send call returns that failure', () async {
    final run = await _upload(
      (request) => request.url.path == '/v1/file_uploads'
          ? _json({'id': 'up-1'})
          : _json({}, HttpStatus.notFound),
    );
    expect(_failure(run.result), equals(NotionFailure.notShared));
    expect(run.sent, hasLength(2));
  });
}

extension on List<int> {
  int indexOfSubsequence(List<int> needle) {
    for (int i = 0; i + needle.length <= length; i++) {
      if (sublist(i, i + needle.length).toString() == needle.toString()) return i;
    }
    return -1;
  }
}
