import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:capture/core/data/notion/notion_keys.dart';
import 'package:capture/core/data/secrets/secrets_local_datasource.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notion_http_service.g.dart';

const notionVersion = '2026-03-11';

typedef Json = Map<String, Object?>;

enum NotionFailure {
  invalidToken,
  notShared,
  missingCapability,
  blockLimit,
  rateLimited,
  unavailable,
  network,
  invalidRequest;

  /// Worth retrying later without changing anything.
  bool get transient => this == rateLimited || this == unavailable || this == network;
}

typedef NotionResult<T> = Result<T, NotionFailure>;

final _random = Random();

/// Notion API transport. Every call reads the Keychain token unless an
/// explicit [token] is given (used to validate a new token before storing
/// it). Status codes are classified once here.
abstract interface class INotionHttpService {
  Future<NotionResult<Json>> get(String path, {String? token});
  Future<NotionResult<Json>> post(String path, Json body, {String? token});
  Future<NotionResult<Json>> patch(String path, Json body, {String? token});

  /// Single-part upload (≤ 20 MiB): create, then send the bytes. Returns
  /// the upload id.
  Future<NotionResult<String>> uploadFile(
    List<int> bytes, {
    required String filename,
    required MediaType type,
  });
}

/// Retries 429/529 (honouring Retry-After) for every method and 5xx or
/// transport failures only for GET, because a write may have landed.
/// Never logs request or response bodies. Owns [_client]; call [close] when
/// done.
class NotionHttpService implements INotionHttpService {
  NotionHttpService(this._secrets, {http.Client? client, Future<void> Function(Duration)? sleep})
    : _client = client ?? http.Client(),
      _sleep = sleep ?? Future<void>.delayed;

  final ISecretsLocalDatasource _secrets;
  final http.Client _client;
  final Future<void> Function(Duration) _sleep;

  static const baseUrl = 'https://api.notion.com';
  static const maxRetries = 3;
  static const timeout = Duration(seconds: 60);
  static const _maxRetryAfter = Duration(seconds: 60);
  static const _backoffBase = Duration(seconds: 1);
  static const _backoffCap = Duration(seconds: 8);
  static const _jitterMs = 250;
  static const _rateLimited = {HttpStatus.tooManyRequests, 529};
  static const _retryableForGet = {
    HttpStatus.internalServerError,
    HttpStatus.badGateway,
    HttpStatus.serviceUnavailable,
    HttpStatus.gatewayTimeout,
  };

  void close() => _client.close();

  Future<NotionResult<Map<String, String>>> _headers(String? token) async =>
      switch (token ?? await _secrets.read(.notionToken)) {
        final String value => .ok({
          HttpHeaders.authorizationHeader: 'Bearer $value',
          NotionKeys.versionHeader: notionVersion,
        }),
        null => const .err(.invalidToken),
      };

  @override
  Future<NotionResult<Json>> get(String path, {String? token}) => _json('GET', path, token: token);

  @override
  Future<NotionResult<Json>> post(String path, Json body, {String? token}) =>
      _json('POST', path, body: body, token: token);

  @override
  Future<NotionResult<Json>> patch(String path, Json body, {String? token}) =>
      _json('PATCH', path, body: body, token: token);

  @override
  Future<NotionResult<String>> uploadFile(
    List<int> bytes, {
    required String filename,
    required MediaType type,
  }) async {
    final created = await post('/v1/file_uploads', {
      NotionKeys.mode: 'single_part',
      NotionKeys.filename: filename,
      NotionKeys.contentType: type.mimeType,
    });
    final String id;
    switch (created) {
      case Ok(value: {NotionKeys.id: final String value}):
        id = value;
      case Ok():
        return const .err(.invalidRequest);
      case Err(:final failure):
        return .err(failure);
    }
    final Map<String, String> headers;
    switch (await _headers(null)) {
      case Ok(:final value):
        headers = value;
      case Err(:final failure):
        return .err(failure);
    }
    final sent = await _send('POST', () {
      return http.MultipartRequest('POST', .parse('$baseUrl/v1/file_uploads/$id/send'))
        ..headers.addAll(headers)
        ..files.add(.fromBytes('file', bytes, filename: filename, contentType: type));
    });
    return switch (sent) {
      Ok() => .ok(id),
      Err(:final failure) => .err(failure),
    };
  }

  Future<NotionResult<Json>> _json(String method, String path, {Json? body, String? token}) async {
    final Map<String, String> headers;
    switch (await _headers(token)) {
      case Ok(:final value):
        headers = value;
      case Err(:final failure):
        return .err(failure);
    }
    return _send(method, () {
      final request = http.Request(method, .parse('$baseUrl$path'))..headers.addAll(headers);
      if (body != null) {
        request.headers[HttpHeaders.contentTypeHeader] = 'application/json';
        request.body = jsonEncode(body);
      }
      return request;
    });
  }

  Future<NotionResult<Json>> _send(String method, http.BaseRequest Function() build) async {
    for (int attempt = 0; ; attempt++) {
      final response = await _attempt(build);
      if (!_retryable(method, response?.statusCode) || attempt >= maxRetries) {
        return switch (response) {
          final http.Response r => _decode(r),
          null => const .err(.network),
        };
      }
      await _sleep(_delay(attempt, response));
    }
  }

  Future<http.Response?> _attempt(http.BaseRequest Function() build) async {
    try {
      final streamed = await _client.send(build()).timeout(timeout);
      return await http.Response.fromStream(streamed).timeout(timeout);
    } on Exception catch (e) {
      if (e case TimeoutException() || SocketException() || http.ClientException()) return null;
      rethrow;
    }
  }

  bool _retryable(String method, int? status) => switch (status) {
    null => method == 'GET',
    final int s when _rateLimited.contains(s) => true,
    final int s => _retryableForGet.contains(s) && method == 'GET',
  };

  Duration _delay(int attempt, http.Response? response) {
    final header = response?.headers[HttpHeaders.retryAfterHeader];
    final seconds = header == null ? null : int.tryParse(header);
    if (seconds != null) {
      final wait = Duration(seconds: seconds);
      return wait > _maxRetryAfter ? _maxRetryAfter : wait;
    }
    final base = _backoffBase * pow(2, attempt).toInt();
    return (base > _backoffCap ? _backoffCap : base) +
        Duration(milliseconds: _random.nextInt(_jitterMs));
  }

  NotionResult<Json> _decode(http.Response response) {
    final body = _parse(response.bodyBytes);
    final status = response.statusCode;
    if (status >= HttpStatus.ok && status < HttpStatus.multipleChoices) return .ok(body);
    return .err(_classify(status, body));
  }

  Json _parse(List<int> bytes) {
    try {
      final decoded = jsonDecode(utf8.decode(bytes));
      return decoded is Json ? decoded : const {};
    } on FormatException {
      return const {};
    }
  }

  NotionFailure _classify(int status, Json body) {
    final blockLimit = switch (body) {
      {'additional_data': {'block_limit': Object()}} => true,
      _ => false,
    };
    return switch (status) {
      HttpStatus.unauthorized => .invalidToken,
      HttpStatus.notFound => .notShared,
      HttpStatus.forbidden when blockLimit => .blockLimit,
      HttpStatus.forbidden => .missingCapability,
      final s when _rateLimited.contains(s) => .rateLimited,
      final s when s == HttpStatus.conflict || s >= HttpStatus.internalServerError => .unavailable,
      _ => .invalidRequest,
    };
  }
}

@Riverpod(keepAlive: true)
INotionHttpService notionHttpService(Ref ref) {
  final service = NotionHttpService(ref.read(secretsLocalDatasourceProvider));
  ref.onDispose(service.close);
  return service;
}
