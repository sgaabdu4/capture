import 'dart:convert';

import 'package:capture/core/data/system/zone_offsets.dart';
import 'package:capture/features/capture/data/datasources/jev_remote_datasource.dart';
import 'package:capture/features/capture/data/services/jev_http_service.dart';
import 'package:capture/features/capture/domain/entities/analysis.dart';
import 'package:capture/features/capture/domain/text/coverage.dart';
import 'package:capture/features/capture/repositories/capture_analysis_repository.dart';
import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:capture/features/groups/domain/group_rules.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import '../../../helpers/test_fakes.dart';

/// Deterministic stand-in for Jev: splits at every boundary, picks the first
/// offered option, and answers "task"/"alert" yes when the state mentions
/// "Remind".
class _FakeJevHttp implements IJevHttpService {
  @override
  Future<JevOutcome<JevHttpReply>> get(String path, {required String apiKey}) async =>
      const .ok((json: null, requestId: null));

  @override
  Future<JevOutcome<JevHttpReply>> post(String path, String body, {required String apiKey}) async {
    final Object? request = jsonDecode(body);
    if (request case {
      'state': final String state,
      'questions': final Map<String, Object?> questions,
    }) {
      return .ok((json: _reply(state, questions), requestId: null));
    }
    return const .err(.invalidResponse);
  }

  Map<String, Object?> _reply(String state, Map<String, Object?> questions) => {
    'model': 'jev-1.13.0',
    'answers': {
      for (final MapEntry(:key, :value) in questions.entries) key: _answer(key, value, state),
    },
    'usage': {'input_tokens': 50, 'output_tokens': 1},
  };

  Map<String, Object?> _answer(String key, Object? question, String state) => switch (question) {
    {'type': 'choice', 'criteria': final Map<String, Object?> options} => {
      'type': 'choice',
      'choice': options.keys.firstWhere((o) => o != 'none', orElse: () => 'none'),
      'confidence': 0.9,
    },
    _ => {'type': 'noul', 'noul': _yes(key, state) ? 0.9 : 0.05},
  };

  bool _yes(String key, String state) =>
      key.startsWith('boundary_') ||
      ((key.endsWith('_alert') || key.endsWith('_task')) && state.contains('Remind'));
}

final _groups = [
  for (final (i, g) in defaultGroups.indexed)
    Group(id: 'g$i', name: g.name, description: g.description),
];

Future<Analysis?> _run(String transcript) async {
  final jev = JevRemoteDatasource(FakeSecrets({.typesafeKey: 'k'}), _FakeJevHttp());
  final outcome = await CaptureAnalysisRepository(jev, FakeSystem()).analyze(
    transcript: transcript,
    groups: _groups,
    moment: .new(capturedAtUtc: FakeSystem.now, offsetAt: zoneOffsets(FakeSystem.zone)),
  );
  return outcome.valueOrNull;
}

void main() {
  setUpAll(tzdata.initializeTimeZones);

  test('two passes produce items that cover the transcript exactly', () async {
    const text = 'I learned about Jev today. Remind me to buy milk tomorrow at 2pm.';
    final analysis = await _run(text);
    expect(analysis?.requestCount, equals(2));
    expect(analysis?.inputTokens, equals(100));
    expect(analysis?.items, hasLength(2));
    expect(coverageProblems(text, [...?analysis?.items.expand((i) => i.sources)]), isEmpty);
  });

  test('an empty transcript makes no requests', () async {
    final analysis = await _run('   ');
    expect(analysis?.items, isEmpty);
    expect(analysis?.requestCount, equals(0));
  });

  test('a single unit skips the boundary pass', () async {
    final analysis = await _run('Buy stamps.');
    expect(analysis?.requestCount, equals(1));
    expect(analysis?.items, hasLength(1));
    expect(analysis?.items.firstOrNull?.title, isNotEmpty);
  });

  test('wholeTranscript trims to the spoken text', () {
    expect(wholeTranscript('  hello there  ').span.excerpt, equals('hello there'));
  });
}
