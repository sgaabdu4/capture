import 'dart:io';

import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/capture/data/services/jev_http_service.dart';
import 'package:capture/features/capture/domain/jev/jev_failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _key = 'test-key';
const _path = '/v1/systemone';

typedef _Run = ({JevOutcome<JevHttpReply> outcome, int calls, List<Duration> sleeps});

/// Posts once through a service whose responses come from [respond], called
/// with the 1-based attempt number.
Future<_Run> _post(Future<http.Response> Function(int attempt) respond) async {
  int calls = 0;
  final sleeps = <Duration>[];
  final service = JevHttpService(
    client: MockClient((_) => respond(++calls)),
    sleep: (d) async => sleeps.add(d),
  );
  final outcome = await service.post(_path, '{}', apiKey: _key);
  service.close();
  return (outcome: outcome, calls: calls, sleeps: sleeps);
}

JevFailure? _failure(JevOutcome<JevHttpReply> outcome) => switch (outcome) {
  Err(:final failure) => failure,
  Ok() => null,
};

void main() {
  test('a 200 returns the decoded body and the request id', () async {
    final sent = <http.Request>[];
    final service = JevHttpService(
      client: MockClient((r) async {
        sent.add(r);
        return http.Response(
          '{"answers":{}}',
          HttpStatus.ok,
          headers: {'x-typesafe-request-id': 'req-1'},
        );
      }),
    );
    final outcome = await service.post(_path, '{"state":"s"}', apiKey: _key);
    expect(sent.firstOrNull?.url.toString(), equals('${JevHttpService.baseUrl}$_path'));
    expect(sent.firstOrNull?.headers[HttpHeaders.authorizationHeader], equals('Bearer $_key'));
    expect(sent.firstOrNull?.url.toString(), isNot(contains(_key)));
    expect(outcome.valueOrNull?.json, equals({'answers': <String, Object?>{}}));
    expect(outcome.valueOrNull?.requestId, equals('req-1'));
  });

  test('429 is retried after the Retry-After delay, then succeeds', () async {
    final run = await _post(
      (attempt) async => attempt == 1
          ? http.Response('', HttpStatus.tooManyRequests, headers: {'retry-after': '2'})
          : http.Response('{}', HttpStatus.ok),
    );
    expect(run.calls, equals(2));
    expect(run.sleeps, equals([const Duration(seconds: 2)]));
    expect(run.outcome, isA<Ok<JevHttpReply, JevFailure>>());
  });

  test('Retry-After above 60 s is capped at 60 s', () async {
    final run = await _post(
      (attempt) async => attempt == 1
          ? http.Response('', HttpStatus.serviceUnavailable, headers: {'retry-after': '600'})
          : http.Response('{}', HttpStatus.ok),
    );
    expect(run.sleeps, equals([const Duration(seconds: 60)]));
  });

  test('overload is retried twice with capped backoff, then unavailable', () async {
    final run = await _post((_) async => http.Response('', 529));
    expect(run.calls, equals(3));
    expect(run.sleeps, hasLength(2));
    expect(run.sleeps.every((d) => d <= const Duration(seconds: 5)), isTrue);
    expect(_failure(run.outcome), equals(JevFailure.unavailable));
  });

  test('401 and 403 are an invalid key and are not retried', () async {
    for (final status in [HttpStatus.unauthorized, HttpStatus.forbidden]) {
      final run = await _post((_) async => http.Response('', status));
      expect(run.calls, equals(1));
      expect(_failure(run.outcome), equals(JevFailure.invalidKey));
    }
  });

  test('a 429 that persists ends as rate limited', () async {
    final run = await _post((_) async => http.Response('', HttpStatus.tooManyRequests));
    expect(run.calls, equals(3));
    expect(_failure(run.outcome), equals(JevFailure.rateLimited));
  });

  test('transport errors are retried and end as a network failure', () async {
    final run = await _post((_) => Future.error(http.ClientException('offline')));
    expect(run.calls, equals(3));
    expect(_failure(run.outcome), equals(JevFailure.network));
  });

  test('a 200 with a body that is not JSON is an invalid response', () async {
    final run = await _post((_) async => http.Response('<html>', HttpStatus.ok));
    expect(_failure(run.outcome), equals(JevFailure.invalidResponse));
  });

  test('other client errors are an invalid response and are not retried', () async {
    final run = await _post((_) async => http.Response('', HttpStatus.badRequest));
    expect(run.calls, equals(1));
    expect(_failure(run.outcome), equals(JevFailure.invalidResponse));
  });
}
