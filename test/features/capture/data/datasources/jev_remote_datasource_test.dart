import 'dart:convert';

import 'package:capture/features/capture/domain/jev/jev_protocol.dart';
import 'package:capture/features/capture/data/datasources/jev_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

final _questions = <String, JevQuestion>{
  'q': const NoulQuestion('Is it?'),
  'c': ChoiceQuestion('Which?', const {'a': 'A', 'b': 'B'}),
};

String _ok() => jsonEncode({
  'model': jevModel,
  'answers': {
    'q': {'type': 'noul', 'noul': 0.8},
    'c': {
      'type': 'choice',
      'choice': 'a',
      'confidence': 0.6,
      'probabilities': {'a': 0.8, 'b': 0.2},
    },
  },
  'usage': {'input_tokens': 120, 'output_tokens': 3},
});

JevClient _client(Future<http.Response> Function(http.Request) handler, {List<Duration>? sleeps}) =>
    JevClient('test-key', client: MockClient(handler), sleep: (d) async => sleeps?.add(d));

void main() {
  test('ask sends the pinned model and decodes answers and usage', () async {
    late http.Request sent;
    final jev = _client((r) async {
      sent = r;
      return http.Response(_ok(), 200, headers: {'x-typesafe-request-id': 'req-1'});
    });
    final (result, metrics) = await jev.ask('state', _questions);
    expect(sent.url.path, '/v1/systemone');
    expect(sent.headers['Authorization'], 'Bearer test-key');
    final body = jsonDecode(sent.body) as Map<String, Object?>;
    expect(body['model'], jevModel);
    expect(body['state'], 'state');
    expect((result.answers['q']! as NoulAnswer).yes, 0.8);
    expect((result.answers['c']! as ChoiceAnswer).choice, 'a');
    expect(metrics.inputTokens, 120);
    expect(metrics.questions, 2);
    expect(metrics.requestId, 'req-1');
  });

  test('retries 429 honouring Retry-After, then succeeds', () async {
    var calls = 0;
    final sleeps = <Duration>[];
    final jev = _client((r) async {
      calls++;
      return calls == 1
          ? http.Response('', 429, headers: {'retry-after': '2'})
          : http.Response(_ok(), 200);
    }, sleeps: sleeps);
    await jev.ask('state', _questions);
    expect(calls, 2);
    expect(sleeps, [const Duration(seconds: 2)]);
  });

  test('bounded retries on overload end in unavailable', () async {
    var calls = 0;
    final sleeps = <Duration>[];
    final jev = _client((r) async {
      calls++;
      return http.Response('', 529);
    }, sleeps: sleeps);
    await expectLater(
      jev.ask('state', _questions),
      throwsA(isA<JevException>().having((e) => e.failure, 'failure', JevFailure.unavailable)),
    );
    expect(calls, 3);
    expect(sleeps.every((d) => d <= const Duration(seconds: 5)), isTrue);
  });

  test('401 is an invalid key and is not retried', () async {
    var calls = 0;
    final jev = _client((r) async {
      calls++;
      return http.Response('', 401);
    });
    await expectLater(
      jev.validateKey(),
      throwsA(isA<JevException>().having((e) => e.userMessage, 'message', contains('rejected'))),
    );
    expect(calls, 1);
  });

  test('transport errors become network failures', () async {
    final jev = _client((r) async => throw http.ClientException('offline'));
    await expectLater(
      jev.ask('state', _questions),
      throwsA(isA<JevException>().having((e) => e.failure, 'failure', JevFailure.network)),
    );
  });

  test('answers outside the asked options are rejected', () async {
    final jev = _client(
      (r) async => http.Response(
        jsonEncode({
          'answers': {
            'q': {'type': 'noul', 'noul': 0.8},
            'c': {'type': 'choice', 'choice': 'z', 'confidence': 1},
          },
        }),
        200,
      ),
    );
    await expectLater(
      jev.ask('state', _questions),
      throwsA(isA<JevException>().having((e) => e.failure, 'failure', JevFailure.invalidResponse)),
    );
  });

  test('validateKey succeeds on 200 and the key is never in the URL', () async {
    final jev = _client((r) async {
      expect(r.url.toString(), isNot(contains('test-key')));
      return http.Response('{"data":[]}', 200);
    });
    await jev.validateKey();
    jev.close();
  });
}
