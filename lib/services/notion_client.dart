import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

const notionVersion = '2026-03-11';

enum NotionFailure {
  invalidToken,
  notShared,
  missingCapability,
  blockLimit,
  rateLimited,
  unavailable,
  network,
  invalidRequest,
}

class NotionException implements Exception {
  const NotionException(this.failure, {this.status, this.code});
  final NotionFailure failure;
  final int? status;
  final String? code;

  String get userMessage => switch (failure) {
    NotionFailure.invalidToken => 'Notion rejected the token.',
    NotionFailure.notShared =>
      "Capture can't see that page. In Notion open it, then ••• → "
          'Connections → Add connection.',
    NotionFailure.missingCapability =>
      'The Notion connection needs read, update and insert content '
          'capabilities.',
    NotionFailure.blockLimit =>
      'This Notion workspace has reached its free-plan block limit.',
    NotionFailure.rateLimited => 'Notion is busy. Try again in a minute.',
    NotionFailure.unavailable => 'Notion is unavailable right now.',
    NotionFailure.network => "Couldn't reach Notion. Check your connection.",
    NotionFailure.invalidRequest => 'Notion refused the request.',
  };

  /// Worth retrying later without changing anything.
  bool get transient =>
      failure == NotionFailure.rateLimited ||
      failure == NotionFailure.unavailable ||
      failure == NotionFailure.network;

  @override
  String toString() => 'NotionException($failure, $status, $code)';
}

/// Thin Notion API client. Retries 429/529 (honouring Retry-After) for
/// every method and 5xx only for GET; everything else surfaces as a typed
/// failure. Never logs request or response bodies.
class NotionClient {
  NotionClient(
    this._token, {
    http.Client? client,
    this.baseUrl = 'https://api.notion.com',
    this.maxRetries = 3,
    this.timeout = const Duration(seconds: 60),
    Future<void> Function(Duration)? sleep,
  }) : _client = client ?? http.Client(),
       _sleep = sleep ?? Future<void>.delayed;

  final String _token;
  final http.Client _client;
  final String baseUrl;
  final int maxRetries;
  final Duration timeout;
  final Future<void> Function(Duration) _sleep;
  final _random = Random();

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $_token',
    'Notion-Version': notionVersion,
  };

  Future<Map<String, Object?>> get(String path) => _json('GET', path);

  Future<Map<String, Object?>> post(String path, Map<String, Object?> body) =>
      _json('POST', path, body);

  Future<Map<String, Object?>> patch(String path, Map<String, Object?> body) =>
      _json('PATCH', path, body);

  /// Single-part upload (≤ 20 MiB): create, then send the bytes.
  Future<String> uploadFile(
    List<int> bytes, {
    required String filename,
    required String contentType,
  }) async {
    final created = await post('/v1/file_uploads', {
      'mode': 'single_part',
      'filename': filename,
      'content_type': contentType,
    });
    final id = created['id']! as String;
    final response = await _send('POST', () {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/v1/file_uploads/$id/send'),
      )..headers.addAll(_headers);
      final type = contentType.split('/');
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: filename,
          contentType: MediaType(type.first, type.last),
        ),
      );
      return request;
    });
    _decode(response);
    return id;
  }

  Future<Map<String, Object?>> _json(
    String method,
    String path, [
    Map<String, Object?>? body,
  ]) async {
    final response = await _send(method, () {
      final request = http.Request(method, Uri.parse('$baseUrl$path'))
        ..headers.addAll(_headers);
      if (body != null) {
        request.headers['Content-Type'] = 'application/json';
        request.body = jsonEncode(body);
      }
      return request;
    });
    return _decode(response);
  }

  Future<http.Response> _send(
    String method,
    http.BaseRequest Function() build,
  ) async {
    for (var attempt = 0; ; attempt++) {
      http.Response? response;
      try {
        final streamed = await _client.send(build()).timeout(timeout);
        response = await http.Response.fromStream(streamed).timeout(timeout);
      } on TimeoutException {
        response = null;
      } on SocketException {
        response = null;
      } on http.ClientException {
        response = null;
      }
      final retry = _retryable(method, response?.statusCode);
      if (!retry || attempt >= maxRetries) {
        if (response == null) {
          throw const NotionException(NotionFailure.network);
        }
        return response;
      }
      await _sleep(_delay(attempt, response));
    }
  }

  /// Transport failures are retried only for GET: a POST may have landed.
  bool _retryable(String method, int? status) => switch (status) {
    null => method == 'GET',
    429 || 529 => true,
    500 || 502 || 503 || 504 => method == 'GET',
    _ => false,
  };

  Duration _delay(int attempt, http.Response? response) {
    final header = response?.headers['retry-after'];
    final seconds = header == null ? null : int.tryParse(header);
    if (seconds != null) return Duration(seconds: min(seconds, 60));
    final base = min(1000 * pow(2, attempt).toInt(), 8000);
    return Duration(milliseconds: base + _random.nextInt(250));
  }

  Map<String, Object?> _decode(http.Response response) {
    Object? body;
    try {
      body = jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      body = null;
    }
    final map = body is Map<String, Object?> ? body : const <String, Object?>{};
    if (response.statusCode >= 200 && response.statusCode < 300) return map;
    throw _failure(response.statusCode, map);
  }

  NotionException _failure(int status, Map<String, Object?> body) {
    final code = body['code'] as String?;
    final extra = body['additional_data'];
    final blockLimit =
        extra is Map<String, Object?> && extra['block_limit'] != null;
    final failure = switch ((status, code)) {
      (401, _) => NotionFailure.invalidToken,
      (404, _) => NotionFailure.notShared,
      (403, _) when blockLimit => NotionFailure.blockLimit,
      (403, _) => NotionFailure.missingCapability,
      (429, _) || (529, _) => NotionFailure.rateLimited,
      (409, _) || (>= 500, _) => NotionFailure.unavailable,
      _ => NotionFailure.invalidRequest,
    };
    return NotionException(failure, status: status, code: code);
  }

  void close() => _client.close();
}
