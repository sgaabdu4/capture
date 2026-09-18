import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:capture/core/extensions/retry_after.dart';
import 'package:capture/features/capture/domain/jev/jev_failure.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'jev_http_service.g.dart';

/// A successful TypeSafe response: the decoded JSON body and the request id.
typedef JevHttpReply = ({Object? json, String? requestId});

/// Transport for the TypeSafe API (`https://api.typesafe.ai`). Classifies
/// statuses into [JevFailure]s; never logs request or response bodies.
abstract interface class IJevHttpService {
  Future<JevOutcome<JevHttpReply>> get(String path, {required String apiKey});
  Future<JevOutcome<JevHttpReply>> post(String path, String body, {required String apiKey});
}

/// Backoff jitter.
final _random = Random();

/// Bearer auth; retries are bounded (2 retries, 0.5 s doubling backoff
/// capped at 5 s, honours Retry-After up to 60 s) and only for
/// 408/429/5xx/529 and transport errors. Owns [_client]; call [close].
class JevHttpService implements IJevHttpService {
  JevHttpService({http.Client? client, this.maxRetries = 2, Future<void> Function(Duration)? sleep})
    : _client = client ?? http.Client(),
      _sleep = sleep ?? Future<void>.delayed;

  final http.Client _client;
  final int maxRetries;
  final Future<void> Function(Duration) _sleep;

  static const baseUrl = 'https://api.typesafe.ai';
  static const timeout = Duration(seconds: 30);
  static const _requestIdHeader = 'x-typesafe-request-id';
  static const _jsonContentType = 'application/json';
  static const _backoffBase = Duration(milliseconds: 500);
  static const _backoffCap = Duration(seconds: 5);
  static const _maxJitter = 0.25;
  static const _overloaded = 529;

  void close() => _client.close();

  @override
  Future<JevOutcome<JevHttpReply>> get(String path, {required String apiKey}) =>
      _send(() => _client.get(.parse('$baseUrl$path'), headers: _headers(apiKey)));

  @override
  Future<JevOutcome<JevHttpReply>> post(String path, String body, {required String apiKey}) =>
      _send(
        () => _client.post(
          .parse('$baseUrl$path'),
          headers: {..._headers(apiKey), HttpHeaders.contentTypeHeader: _jsonContentType},
          body: body,
        ),
      );

  Map<String, String> _headers(String apiKey) => {
    HttpHeaders.authorizationHeader: 'Bearer $apiKey',
  };

  Future<JevOutcome<JevHttpReply>> _send(Future<http.Response> Function() request) async {
    for (int attempt = 0; ; attempt++) {
      final response = await _attempt(request);
      final retryable = response == null || _retryable(response.statusCode);
      if (!retryable || attempt >= maxRetries) return _classify(response);
      await _sleep(_delay(attempt, response));
    }
  }

  Future<http.Response?> _attempt(Future<http.Response> Function() request) async {
    try {
      return await request().timeout(timeout);
    } on Exception catch (e) {
      if (e case TimeoutException() || SocketException() || http.ClientException()) return null;
      rethrow;
    }
  }

  JevOutcome<JevHttpReply> _classify(http.Response? response) => switch (response) {
    null => const .err(.network),
    http.Response(statusCode: HttpStatus.ok) => _reply(response),
    http.Response(:final statusCode) => .err(_failureFor(statusCode)),
  };

  JevOutcome<JevHttpReply> _reply(http.Response response) => switch (_decode(response.body)) {
    final Object json => .ok((json: json, requestId: response.headers[_requestIdHeader])),
    null => const .err(.invalidResponse),
  };

  Object? _decode(String body) {
    try {
      return jsonDecode(body);
    } on FormatException {
      return null;
    }
  }

  bool _retryable(int status) =>
      status == HttpStatus.requestTimeout ||
      status == HttpStatus.tooManyRequests ||
      status >= HttpStatus.internalServerError;

  Duration _delay(int attempt, http.Response? response) {
    if (response?.retryAfter case final Duration wait) return wait;
    final doubled = _backoffBase * pow(2, attempt).toInt();
    final base = doubled > _backoffCap ? _backoffCap : doubled;
    return base * (1 - _maxJitter * _random.nextDouble());
  }

  JevFailure _failureFor(int status) => switch (status) {
    HttpStatus.unauthorized || HttpStatus.forbidden => .invalidKey,
    HttpStatus.tooManyRequests => .rateLimited,
    _overloaded || >= HttpStatus.internalServerError => .unavailable,
    _ => .invalidResponse,
  };
}

@Riverpod(keepAlive: true)
IJevHttpService jevHttpService(Ref ref) {
  final service = JevHttpService();
  ref.onDispose(service.close);
  return service;
}
