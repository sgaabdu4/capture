import 'dart:convert';

import 'package:capture/core/data/secrets/secrets_local_datasource.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/capture/data/services/jev_http_service.dart';
import 'package:capture/features/capture/domain/entities/jev_call_metrics.dart';
import 'package:capture/features/capture/domain/jev/jev_failure.dart';
import 'package:capture/features/capture/domain/jev/jev_protocol.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

export 'package:capture/features/capture/domain/jev/jev_failure.dart';

part 'jev_remote_datasource.g.dart';

/// One answered Jev request and its metadata.
typedef JevReply = ({JevResult result, JevCallMetrics metrics});

/// TypeSafe Jev (`POST /v1/systemone`). Only transcript text and group
/// descriptions are sent; never audio.
abstract interface class IJevRemoteDatasource {
  /// Harmless key check: lists models (no tokens, no diary content).
  Future<JevOutcome<void>> validateKey(String apiKey);

  /// Uses the Keychain key.
  Future<JevOutcome<JevReply>> ask(String state, Map<String, JevQuestion> questions);
}

class JevRemoteDatasource implements IJevRemoteDatasource {
  const JevRemoteDatasource(this._secrets, this._http);

  final ISecretsLocalDatasource _secrets;
  final IJevHttpService _http;

  static const _modelsPath = '/v1/models';
  static const _askPath = '/v1/systemone';

  @override
  Future<JevOutcome<void>> validateKey(String apiKey) async =>
      switch (await _http.get(_modelsPath, apiKey: apiKey)) {
        Ok() => const .ok(null),
        Err(:final failure) => .err(failure),
      };

  @override
  Future<JevOutcome<JevReply>> ask(String state, Map<String, JevQuestion> questions) async {
    final apiKey = await _secrets.read(.typesafeKey);
    if (apiKey == null) return const .err(.invalidKey);
    final watch = Stopwatch()..start();
    final sent = await _http.post(
      _askPath,
      jsonEncode(buildRequest(state, questions)),
      apiKey: apiKey,
    );
    watch.stop();
    return switch (sent) {
      Ok(value: final reply) => _reply(reply, questions, watch.elapsed),
      Err(:final failure) => .err(failure),
    };
  }

  JevOutcome<JevReply> _reply(
    JevHttpReply reply,
    Map<String, JevQuestion> questions,
    Duration latency,
  ) => switch (decodeResponse(reply.json, questions)) {
    Ok(value: final result) => .ok((
      result: result,
      metrics: JevCallMetrics(
        model: result.model,
        latency: latency,
        inputTokens: result.usage.inputTokens,
        outputTokens: result.usage.outputTokens,
        questions: questions.length,
        requestId: reply.requestId,
      ),
    )),
    Err() => const .err(.invalidResponse),
  };
}

@Riverpod(keepAlive: true)
IJevRemoteDatasource jevRemoteDatasource(Ref ref) =>
    JevRemoteDatasource(ref.read(secretsLocalDatasourceProvider), ref.read(jevHttpServiceProvider));
