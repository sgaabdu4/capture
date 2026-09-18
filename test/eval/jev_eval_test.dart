// Evaluation harness for the Jev splitting/classification pipeline. The
// default test run replays recorded responses and fails on any unrecorded
// request or lost source text; the other modes are opt-in:
//
//   flutter test test/eval/jev_eval_test.dart                          # replay
//   EVAL_LIVE=1 TYPESAFE_API_KEY=… flutter test test/eval/jev_eval_test.dart
//   EVAL_PRUNE=1 flutter test test/eval/jev_eval_test.dart             # drop unused
//   EVAL_MERGE=<file> flutter test test/eval/jev_eval_test.dart        # add results
//
// In replay mode every Jev request is looked up in `recorded/jev.json`
// (keyed by a hash of the exact request body). Missing requests are written
// to `recorded/pending.b64` (gzip+base64) so they can be run elsewhere (e.g.
// the TypeSafe playground) and merged with EVAL_MERGE. Synthetic fixtures
// only; nothing personal is recorded.
import 'dart:convert';
import 'dart:io';

import 'package:capture/core/data/system/zone_offsets.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/capture/data/datasources/jev_remote_datasource.dart';
import 'package:capture/features/capture/data/services/jev_http_service.dart';
import 'package:capture/features/capture/domain/entities/analysis.dart';
import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:capture/features/capture/domain/entities/proposal_item.dart';
import 'package:capture/features/capture/domain/text/coverage.dart';
import 'package:capture/features/capture/repositories/capture_analysis_repository.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest.dart' as tzdata;

import '../helpers/test_fakes.dart';
import 'eval_cases.dart';

final _dir = Directory('test/eval/recorded');
final _store = File('${_dir.path}/jev.json');
final _pending = File('${_dir.path}/pending.b64');

/// Characters of transcript shown after an unexpected item start.
const _contextChars = 24;

/// Percentages are whole numbers.
const _percent = 100;

/// Live requests retry like the app; replayed ones never do.
const _liveRetries = 2;

final _env = Platform.environment;

void main() {
  setUpAll(tzdata.initializeTimeZones);

  test('Jev eval: every case is answered and no source text is lost', () async {
    if (_env['EVAL_MERGE'] case final String path) {
      _merge(.new(path));
      return;
    }
    final live = _env['EVAL_LIVE'] == '1';
    final key = _env['TYPESAFE_API_KEY'];
    if (live && (key == null || key.isEmpty)) fail('Set TYPESAFE_API_KEY for EVAL_LIVE=1.');
    final report = await _evaluate(live: live, key: key ?? 'replay');
    debugPrint(report.render());
    expect(report.pending, isEmpty, reason: 'unrecorded requests; see ${_pending.path}');
    expect(report.sourceLoss, equals(0));
  }, timeout: .none);
}

Future<_Report> _evaluate({required bool live, required String key}) async {
  final recorded = _load();
  final pending = <String, Object?>{};
  final replay = _ReplayClient(recorded, pending);
  final transport = JevHttpService(
    client: live ? null : replay,
    maxRetries: live ? _liveRetries : 0,
  );
  final jev = JevRemoteDatasource(FakeSecrets({.typesafeKey: key}), transport);
  final report = _Report();
  for (final c in evalCases) {
    replay.missed = false;
    final outcome = await CaptureAnalysisRepository(jev, FakeSystem()).analyze(
      transcript: c.transcript,
      groups: c.groups,
      moment: .new(capturedAtUtc: c.captured, offsetAt: zoneOffsets(FakeSystem.zone)),
    );
    switch (outcome) {
      case Ok(value: final analysis):
        report.add(c, analysis);
      case Err() when replay.missed:
        report.pending.add(c.id);
      case Err(:final failure):
        report.rows.add('FAIL ${c.id} (${failure.name})');
    }
  }
  if (_env['EVAL_PRUNE'] == '1' && !live && pending.isEmpty) {
    _store.writeAsStringSync(
      const JsonEncoder.withIndent(' ').convert({for (final h in replay.used) h: recorded[h]}),
    );
    report.rows.add('kept ${replay.used.length} of ${recorded.length}');
  }
  if (pending.isNotEmpty) {
    _dir.createSync(recursive: true);
    _pending.writeAsStringSync(base64.encode(gzip.encode(utf8.encode(jsonEncode(pending)))));
  }
  transport.close();
  replay.close();
  return report;
}

Map<String, Object?> _load() => _store.existsSync() ? _object(_store.readAsStringSync()) : {};

Map<String, Object?> _object(String json) => switch (jsonDecode(json)) {
  final Map<String, Object?> map => map,
  _ => {},
};

/// Merges playground results: a JSON object `{hash: responseBody}`.
void _merge(File results) {
  final text = results.readAsStringSync().trim();
  final decoded = text.startsWith('{') ? text : utf8.decode(gzip.decode(base64.decode(text)));
  final incoming = _object(decoded);
  final all = {..._load(), ...incoming};
  _dir.createSync(recursive: true);
  _store.writeAsStringSync(const JsonEncoder.withIndent(' ').convert(all));
  debugPrint('merged ${incoming.length}; store has ${all.length}');
}

String _requestHash(String body) => sha1.convert(utf8.encode(body)).toString();

/// Serves recorded responses; an unrecorded request is kept as pending and
/// answered 404, which fails its case without a retry.
class _ReplayClient extends http.BaseClient {
  _ReplayClient(this.recorded, this.pending);
  final Map<String, Object?> recorded;
  final Map<String, Object?> pending;
  final used = <String>{};

  /// Whether a request since the last reset had no recording.
  bool missed = false;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final body = request is http.Request ? request.body : '';
    final hash = _requestHash(body);
    final hit = recorded[hash];
    if (hit == null) {
      pending[hash] = jsonDecode(body);
      missed = true;
      return .new(const .empty(), HttpStatus.notFound);
    }
    used.add(hash);
    final bytes = utf8.encode(jsonEncode(hit));
    return .new(.value(bytes), HttpStatus.ok);
  }
}

String _pct(int a, int b) => b == 0 ? 'n/a' : '$a/$b (${(_percent * a / b).round()}%)';

String _date(DueDate? date) => switch (date) {
  final DueDate d => d.iso,
  null => 'null',
};

class _Report {
  final pending = <String>[];
  final rows = <String>[];
  int goldBoundaries = 0;
  int predictedBoundaries = 0;
  int correctBoundaries = 0;
  int alignedItems = 0;
  int groupCorrect = 0;
  int kindCorrect = 0;
  int falseTasks = 0;
  int missedTasks = 0;
  int reminderChecks = 0;
  int reminderCorrect = 0;
  int flagChecks = 0;
  int flagsPresent = 0;
  int sourceLoss = 0;
  int requests = 0;
  int tokens = 0;
  int latencyMs = 0;

  void add(EvalCase c, Analysis a) {
    requests += a.requestCount;
    tokens += a.inputTokens;
    latencyMs += a.latency.inMilliseconds;
    final spans = a.items.expand((i) => i.sources);
    if (coverageProblems(c.transcript, spans).isNotEmpty) sourceLoss++;
    final gold = c.goldBoundaries.toSet();
    final predicted = {for (final i in a.items.skip(1)) ?i.sources.firstOrNull?.start};
    final unexpected = predicted.difference(gold);
    goldBoundaries += gold.length;
    predictedBoundaries += predicted.length;
    correctBoundaries += gold.intersection(predicted).length;
    final problems = <String>[
      for (final o in unexpected)
        'unexpected item at "${c.transcript.substring(o, (o + _contextChars).clamp(0, c.transcript.length))}"',
      for (final e in c.expected) ..._expected(c, e, a.items),
    ];
    final verdict = problems.isEmpty ? 'PASS' : 'FAIL';
    final details = problems.isEmpty ? '' : '\n    - ${problems.join('\n    - ')}';
    rows.add('$verdict ${c.id} (${a.items.length} items, ${a.requestCount} req)$details');
  }

  List<String> _expected(EvalCase c, Expected e, List<ProposalItem> items) {
    final start = c.transcript.indexOf(e.startsWith);
    final item = items.where((i) => i.sources.firstOrNull?.start == start).firstOrNull;
    if (item == null) return ['no item at "${e.startsWith}"'];
    return _compare(c, e, item);
  }

  List<String> _compare(EvalCase c, Expected e, ProposalItem item) {
    alignedItems++;
    return [
      ..._compareGroup(c, e, item),
      ..._compareKind(e, item),
      ..._compareDates(e, item),
      if (item.included != e.included) '"${e.startsWith}": included ${item.included}',
      ..._compareFlags(e, item),
    ];
  }

  List<String> _compareGroup(EvalCase c, Expected e, ProposalItem item) {
    final group = c.groups.where((g) => g.id == item.groupId).firstOrNull?.name;
    if (e.groups.contains(group)) {
      groupCorrect++;
      return const [];
    }
    return ['"${e.startsWith}": group ${group ?? 'null'}, expected ${e.groups}'];
  }

  List<String> _compareKind(Expected e, ProposalItem item) {
    if (item.kind == e.kind) {
      kindCorrect++;
      return const [];
    }
    if (item.kind == .task) {
      falseTasks++;
      return ['"${e.startsWith}": false task'];
    }
    missedTasks++;
    return ['"${e.startsWith}": missed task'];
  }

  List<String> _compareDates(Expected e, ProposalItem item) {
    final problems = <String>[];
    if (e.reminder != null || item.reminder != null) {
      reminderChecks++;
      if (item.reminder == e.reminder) reminderCorrect++;
      if (item.reminder != e.reminder) {
        problems.add(
          '"${e.startsWith}": reminder ${_date(item.reminder)}, expected ${_date(e.reminder)}',
        );
      }
    }
    if (e.due != null && item.due != e.due) {
      problems.add('"${e.startsWith}": due ${_date(item.due)}, expected ${_date(e.due)}');
    }
    return problems;
  }

  List<String> _compareFlags(Expected e, ProposalItem item) {
    flagChecks += e.flags.length;
    final present = e.flags.where(item.flags.contains);
    flagsPresent += present.length;
    return [
      for (final f in e.flags.difference(item.flags)) '"${e.startsWith}": missing flag ${f.name}',
    ];
  }

  String render() => [
    ...rows,
    if (pending.isNotEmpty) 'PENDING: ${pending.join(', ')}',
    '',
    'Boundary recall    ${_pct(correctBoundaries, goldBoundaries)}',
    'Boundary precision ${_pct(correctBoundaries, predictedBoundaries)}',
    'Group accuracy     ${_pct(groupCorrect, alignedItems)}',
    'Note/task accuracy ${_pct(kindCorrect, alignedItems)}  (false tasks $falseTasks, missed tasks $missedTasks)',
    'Reminders correct  ${_pct(reminderCorrect, reminderChecks)}',
    'Expected flags     ${_pct(flagsPresent, flagChecks)}',
    'Source-text loss   $sourceLoss case(s)',
    'Requests $requests, input tokens $tokens, summed Jev latency ${latencyMs}ms',
  ].join('\n');
}
