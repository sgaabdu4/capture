import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../domain/jev/jev_protocol.dart';

/// Failure categories the capture flow reacts to. Drafts are always kept.
enum JevFailure {
  invalidKey,
  rateLimited,
  unavailable,
  network,
  invalidResponse,
}

class JevException implements Exception {
  const JevException(this.failure, [this.status]);
  final JevFailure failure;
  final int? status;

  String get userMessage => switch (failure) {
    JevFailure.invalidKey => 'TypeSafe rejected the API key.',
    JevFailure.rateLimited =>
      'TypeSafe is rate limiting requests. Try again shortly.',
    JevFailure.unavailable => 'TypeSafe is unavailable right now.',
    JevFailure.network => "Couldn't reach TypeSafe. Check your connection.",
    JevFailure.invalidResponse => 'TypeSafe returned an unexpected response.',
  };

  @override
  String toString() => 'JevException($failure, $status)';
}

/// Metadata recorded per request — never transcript or answers.
class JevCallMetrics {
  const JevCallMetrics({
    required this.model,
    required this.latency,
    required this.inputTokens,
    required this.outputTokens,
    required this.questions,
    this.requestId,
  });

  final String model;
  final Duration latency;
  final int inputTokens;
  final int outputTokens;
  final int questions;
  final String? requestId;
}

/// Minimal TypeSafe client: `POST /v1/systemone` with bearer auth. Retries
/// are bounded (2 retries, 0.5 s doubling backoff capped at 5 s, honours
/// Retry-After up to 60 s) and only for 408/429/5xx/529 and transport errors.
class JevClient {
  JevClient(
    this._apiKey, {
    http.Client? client,
    this.baseUrl = 'https://api.typesafe.ai',
    this.timeout = const Duration(seconds: 30),
    this.maxRetries = 2,
    Future<void> Function(Duration)? sleep,
  }) : _client = client ?? http.Client(),
       _sleep = sleep ?? Future<void>.delayed;

  final String _apiKey;
  final http.Client _client;
  final String baseUrl;
  final Duration timeout;
  final int maxRetries;
  final Future<void> Function(Duration) _sleep;
  final _random = Random();

  /// Harmless key check: lists models (no tokens, no diary content).
  Future<void> validateKey() async {
    final response = await _send(
      () => _client.get(Uri.parse('$baseUrl/v1/models'), headers: _headers),
    );
    if (response.statusCode != 200) _throwFor(response);
  }

  Future<(JevResult, JevCallMetrics)> ask(
    String state,
    Map<String, JevQuestion> questions,
  ) async {
    final body = jsonEncode(buildRequest(state, questions));
    final watch = Stopwatch()..start();
    final response = await _send(
      () => _client.post(
        Uri.parse('$baseUrl/v1/systemone'),
        headers: {..._headers, 'Content-Type': 'application/json'},
        body: body,
      ),
    );
    watch.stop();
    if (response.statusCode != 200) _throwFor(response);
    final JevResult result;
    try {
      result = decodeResponse(jsonDecode(response.body), questions);
    } on FormatException {
      throw const JevException(JevFailure.invalidResponse);
    } on JevDecodeException {
      throw const JevException(JevFailure.invalidResponse);
    }
    return (
      result,
      JevCallMetrics(
        model: result.model,
        latency: watch.elapsed,
        inputTokens: result.usage.inputTokens,
        outputTokens: result.usage.outputTokens,
        questions: questions.length,
        requestId: response.headers['x-typesafe-request-id'],
      ),
    );
  }

  Map<String, String> get _headers => {'Authorization': 'Bearer $_apiKey'};

  Future<http.Response> _send(Future<http.Response> Function() request) async {
    for (var attempt = 0; ; attempt++) {
      http.Response? response;
      try {
        response = await request().timeout(timeout);
      } on TimeoutException {
        response = null;
      } on SocketException {
        response = null;
      } on http.ClientException {
        response = null;
      }
      final retryable = response == null || _retryable(response.statusCode);
      if (!retryable || attempt >= maxRetries) {
        if (response == null) throw const JevException(JevFailure.network);
        return response;
      }
      await _sleep(_delay(attempt, response));
    }
  }

  bool _retryable(int status) =>
      status == 408 || status == 429 || status >= 500;

  Duration _delay(int attempt, http.Response? response) {
    final header = response?.headers['retry-after'];
    final seconds = header == null ? null : int.tryParse(header);
    if (seconds != null) return Duration(seconds: min(seconds, 60));
    final base = min(500 * pow(2, attempt).toInt(), 5000);
    final jitter = (base * 0.25 * _random.nextDouble()).round();
    return Duration(milliseconds: base - jitter);
  }

  Never _throwFor(http.Response response) {
    final status = response.statusCode;
    throw JevException(switch (status) {
      401 || 403 => JevFailure.invalidKey,
      429 => JevFailure.rateLimited,
      >= 500 => JevFailure.unavailable,
      _ => JevFailure.invalidResponse,
    }, status);
  }

  void close() => _client.close();
}
