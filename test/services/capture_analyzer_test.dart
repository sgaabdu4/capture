import 'dart:convert';

import 'package:capture/domain/models.dart';
import 'package:capture/domain/source_span.dart';
import 'package:capture/services/capture_analyzer.dart';
import 'package:capture/services/jev_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Deterministic stand-in for Jev: splits at every boundary, picks the first
/// offered option, and answers "task"/"alert" yes when the state mentions
/// "Remind".
http.Response _fakeJev(http.Request request) {
  final body = jsonDecode(request.body) as Map<String, Object?>;
  final questions = body['questions']! as Map<String, Object?>;
  final state = body['state']! as String;
  final answers = <String, Object?>{};
  for (final MapEntry(:key, :value) in questions.entries) {
    final q = value! as Map<String, Object?>;
    if (q['type'] == 'noul') {
      final yes =
          key.startsWith('boundary_') ||
          (key.endsWith('_alert') && state.contains('Remind')) ||
          (key.endsWith('_task') && state.contains('Remind'));
      answers[key] = {'type': 'noul', 'noul': yes ? 0.9 : 0.05};
    } else {
      final options = (q['criteria']! as Map<String, Object?>).keys.toList();
      final pick = options.firstWhere((o) => o != 'none', orElse: () => 'none');
      answers[key] = {'type': 'choice', 'choice': pick, 'confidence': 0.9};
    }
  }
  return http.Response(
    jsonEncode({
      'model': 'jev-1.13.0',
      'answers': answers,
      'usage': {'input_tokens': 50, 'output_tokens': 1},
    }),
    200,
  );
}

void main() {
  setUpAll(tzdata.initializeTimeZones);

  final groups = [
    for (final (i, g) in defaultGroups.indexed)
      Group(id: 'g$i', name: g.name, description: g.description),
  ];

  Future<Analysis> run(String transcript) {
    var n = 0;
    return CaptureAnalyzer(
      JevClient('k', client: MockClient((r) async => _fakeJev(r))),
    ).analyze(
      transcript: transcript,
      groups: groups,
      capturedAtUtc: DateTime.utc(2026, 9, 17, 19, 9),
      location: tz.getLocation('Europe/London'),
      newId: () => 'i${++n}',
    );
  }

  test('two passes produce items that cover the transcript exactly', () async {
    const text =
        'I learned about Jev today. Remind me to buy milk tomorrow at 2pm.';
    final analysis = await run(text);
    expect(analysis.requestCount, 2);
    expect(analysis.inputTokens, 100);
    expect(analysis.items, hasLength(2));
    expect(
      coverageProblems(text, analysis.items.expand((i) => i.sources)),
      isEmpty,
    );
    expect(analysis.latency.isNegative, isFalse);
  });

  test('an empty transcript makes no requests', () async {
    final analysis = await run('   ');
    expect(analysis.items, isEmpty);
    expect(analysis.requestCount, 0);
  });

  test('a single unit skips the boundary pass', () async {
    final analysis = await run('Buy stamps.');
    expect(analysis.requestCount, 1);
    expect(analysis.items.single.title, isNotEmpty);
  });

  test('wholeTranscript trims to the spoken text', () {
    final t = wholeTranscript('  hello there  ');
    expect(t.span.excerpt, 'hello there');
  });
}
