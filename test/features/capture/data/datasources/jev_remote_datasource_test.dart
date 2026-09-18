import 'dart:convert';

import 'package:capture/core/data/secrets/secrets_local_datasource.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/capture/data/datasources/jev_remote_datasource.dart';
import 'package:capture/features/capture/data/services/jev_http_service.dart';
import 'package:capture/features/capture/domain/jev/jev_protocol.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/test_fakes.dart';

const _key = 'test-key';

final _questions = <String, JevQuestion>{
  'q': const .noul('Is it?'),
  'c': .choice('Which?', const {'a': 'A', 'b': 'B'}),
};

Map<String, Object?> _answers({String picked = 'a'}) => {
  'model': jevModel,
  'answers': {
    'q': {'type': 'noul', 'noul': 0.8},
    'c': {
      'type': 'choice',
      'choice': picked,
      'confidence': 0.6,
      'probabilities': {'a': 0.8, 'b': 0.2},
    },
  },
  'usage': {'input_tokens': 120, 'output_tokens': 3},
};

/// A request as sent; [body] is null for a GET.
typedef _Request = ({String path, String? body, String apiKey});

/// Records requests and answers each with [reply].
class _FakeHttp implements IJevHttpService {
  _FakeHttp(this.reply);
  final JevOutcome<JevHttpReply> reply;
  final requests = <_Request>[];

  @override
  Future<JevOutcome<JevHttpReply>> get(String path, {required String apiKey}) async {
    requests.add((path: path, body: null, apiKey: apiKey));
    return reply;
  }

  @override
  Future<JevOutcome<JevHttpReply>> post(String path, String body, {required String apiKey}) async {
    requests.add((path: path, body: body, apiKey: apiKey));
    return reply;
  }
}

JevRemoteDatasource _jev(_FakeHttp http, {bool hasKey = true}) =>
    .new(FakeSecrets({if (hasKey) Secret.typesafeKey: _key}), http);

JevFailure? _failure<T>(JevOutcome<T> outcome) => switch (outcome) {
  Err(:final failure) => failure,
  Ok() => null,
};

void main() {
  test('ask sends the pinned model with the Keychain key and decodes answers', () async {
    final http = _FakeHttp(.ok((json: _answers(), requestId: 'req-1')));
    final outcome = await _jev(http).ask('state', _questions);

    expect(http.requests, hasLength(1));
    final request = http.requests.firstOrNull;
    expect(request?.path, equals('/v1/systemone'));
    expect(request?.apiKey, equals(_key));
    expect(
      jsonDecode(request?.body ?? ''),
      allOf(containsPair('model', jevModel), containsPair('state', 'state')),
    );
    final reply = outcome.valueOrNull;
    expect(reply?.result.answers['q'], equals(const JevAnswer.noul(0.8)));
    expect(reply?.result.answers['c'], isA<ChoiceAnswer>().having((a) => a.choice, 'choice', 'a'));
    expect(reply?.metrics.inputTokens, equals(120));
    expect(reply?.metrics.questions, equals(2));
    expect(reply?.metrics.requestId, equals('req-1'));
  });

  test('ask without a saved key fails as an invalid key and sends nothing', () async {
    final http = _FakeHttp(.ok((json: _answers(), requestId: null)));
    final outcome = await _jev(http, hasKey: false).ask('state', _questions);
    expect(_failure(outcome), equals(JevFailure.invalidKey));
    expect(http.requests, isEmpty);
  });

  test('an answer outside the offered options is an invalid response', () async {
    final http = _FakeHttp(.ok((json: _answers(picked: 'z'), requestId: null)));
    final outcome = await _jev(http).ask('state', _questions);
    expect(_failure(outcome), equals(JevFailure.invalidResponse));
  });

  test('transport failures pass through unchanged', () async {
    final http = _FakeHttp(const .err(.rateLimited));
    final outcome = await _jev(http).ask('state', _questions);
    expect(_failure(outcome), equals(JevFailure.rateLimited));
  });

  test('validateKey lists models with the key being checked', () async {
    final http = _FakeHttp(const .ok((json: {'data': <Object?>[]}, requestId: null)));
    final outcome = await _jev(http, hasKey: false).validateKey('new-key');
    expect(outcome, isA<Ok<void, JevFailure>>());
    expect(http.requests, equals([(path: '/v1/models', body: null, apiKey: 'new-key')]));
  });
}
