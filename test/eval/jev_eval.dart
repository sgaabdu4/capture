// Evaluation harness for the Jev splitting/classification pipeline.
//
//   dart run test/eval/jev_eval.dart            # replay recorded responses
//   TYPESAFE_API_KEY=… dart run test/eval/jev_eval.dart --live   # opt-in live
//   dart run test/eval/jev_eval.dart --prune    # drop unused recordings
//
// In replay mode every Jev request is looked up in `recorded/jev.json`
// (keyed by a hash of the exact request body). Missing requests are written
// to `recorded/pending.b64` (gzip+base64) so they can be run elsewhere (e.g.
// the TypeSafe playground) and merged with `--merge <file>`. Synthetic
// fixtures only; nothing personal is recorded.
import 'dart:convert';
import 'dart:io';

import 'package:capture/domain/models.dart';
import 'package:capture/domain/source_span.dart';
import 'package:capture/services/capture_analyzer.dart';
import 'package:capture/services/jev_client.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'eval_cases.dart';

final _dir = Directory('test/eval/recorded');
final _store = File('${_dir.path}/jev.json');
final _pending = File('${_dir.path}/pending.b64');

Future<void> main(List<String> args) async {
  tzdata.initializeTimeZones();
  if (args.isNotEmpty && args.first == '--merge') {
    _merge(File(args[1]));
    return;
  }
  final live = args.contains('--live');
  final recorded = _load();
  final pending = <String, Object?>{};
  final client = _ReplayClient(recorded, pending);
  final key = Platform.environment['TYPESAFE_API_KEY'];
  if (live && (key == null || key.isEmpty)) {
    stderr.writeln('Set TYPESAFE_API_KEY for --live.');
    exit(2);
  }
  final jev = live
      ? JevClient(key!)
      : JevClient('replay', client: client, maxRetries: 0);
  final report = _Report();
  for (final c in evalCases) {
    try {
      final analysis = await CaptureAnalyzer(jev).analyze(
        transcript: c.transcript,
        groups: c.groups,
        capturedAtUtc: c.captured,
        location: tz.getLocation('Europe/London'),
        newId: _ids(),
      );
      report.add(c, analysis);
    } on _Pending {
      report.pending.add(c.id);
    }
  }
  if (args.contains('--prune') && !live && pending.isEmpty) {
    _store.writeAsStringSync(
      const JsonEncoder.withIndent(' ')
          .convert({for (final h in client.used) h: recorded[h]}),
    );
    stdout.writeln('kept ${client.used.length} of ${recorded.length}');
  }
  if (pending.isNotEmpty) {
    _dir.createSync(recursive: true);
    _pending.writeAsStringSync(
      base64.encode(gzip.encode(utf8.encode(jsonEncode(pending)))),
    );
    stdout.writeln('${pending.length} request(s) pending → ${_pending.path}');
  }
  stdout.writeln(report.render());
  jev.close();
}

String Function() _ids() {
  var n = 0;
  return () => 'item-${++n}';
}

Map<String, Object?> _load() => _store.existsSync()
    ? (jsonDecode(_store.readAsStringSync()) as Map<String, Object?>)
    : <String, Object?>{};

/// Merges playground results: a JSON object `{hash: responseBody}`.
void _merge(File results) {
  final text = results.readAsStringSync().trim();
  final decoded = text.startsWith('{')
      ? text
      : utf8.decode(gzip.decode(base64.decode(text)));
  final incoming = jsonDecode(decoded) as Map<String, Object?>;
  final all = {..._load(), ...incoming};
  _dir.createSync(recursive: true);
  _store.writeAsStringSync(const JsonEncoder.withIndent(' ').convert(all));
  stdout.writeln('merged ${incoming.length}; store has ${all.length}');
}

String requestHash(String body) => sha1.convert(utf8.encode(body)).toString();

class _Pending implements Exception {}

class _ReplayClient extends http.BaseClient {
  _ReplayClient(this.recorded, this.pending);
  final Map<String, Object?> recorded;
  final Map<String, Object?> pending;
  final used = <String>{};

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final body = request is http.Request ? request.body : '';
    final hash = requestHash(body);
    final hit = recorded[hash];
    if (hit == null) {
      pending[hash] = jsonDecode(body);
      throw _Pending();
    }
    used.add(hash);
    final bytes = utf8.encode(jsonEncode(hit));
    return http.StreamedResponse(Stream.value(bytes), 200);
  }
}

class _Report {
  final pending = <String>[];
  final rows = <String>[];
  var goldBoundaries = 0;
  var predictedBoundaries = 0;
  var correctBoundaries = 0;
  var alignedItems = 0;
  var groupCorrect = 0;
  var kindCorrect = 0;
  var falseTasks = 0;
  var missedTasks = 0;
  var reminderChecks = 0;
  var reminderCorrect = 0;
  var flagChecks = 0;
  var flagsPresent = 0;
  var sourceLoss = 0;
  var requests = 0;
  var tokens = 0;
  var latencyMs = 0;

  void add(EvalCase c, Analysis a) {
    requests += a.requestCount;
    tokens += a.inputTokens;
    latencyMs += a.latency.inMilliseconds;
    final spans = a.items.expand((i) => i.sources);
    if (coverageProblems(c.transcript, spans).isNotEmpty) sourceLoss++;
    final gold = c.goldBoundaries.toSet();
    final predicted = a.items.skip(1).map((i) => i.sources.first.start).toSet();
    final unexpected = predicted.difference(gold);
    goldBoundaries += gold.length;
    predictedBoundaries += predicted.length;
    correctBoundaries += gold.intersection(predicted).length;
    final problems = <String>[
      for (final o in unexpected)
        'unexpected item at "${c.transcript.substring(o, (o + 24).clamp(0, c.transcript.length))}"',
    ];
    for (final e in c.expected) {
      final start = c.transcript.indexOf(e.startsWith);
      final item = a.items
          .where((i) => i.sources.first.start == start)
          .firstOrNull;
      if (item == null) {
        problems.add('no item at "${e.startsWith}"');
        continue;
      }
      problems.addAll(_compare(c, e, item));
    }
    rows.add(
      '${problems.isEmpty ? 'PASS' : 'FAIL'} ${c.id} '
      '(${a.items.length} items, ${a.requestCount} req)'
      '${problems.isEmpty ? '' : '\n    - ${problems.join('\n    - ')}'}',
    );
  }

  List<String> _compare(EvalCase c, Expected e, ProposalItem item) {
    final problems = <String>[];
    alignedItems++;
    final group = c.groups.where((g) => g.id == item.groupId).firstOrNull?.name;
    if (e.groups.contains(group)) {
      groupCorrect++;
    } else {
      problems.add('"${e.startsWith}": group $group, expected ${e.groups}');
    }
    if (item.kind == e.kind) {
      kindCorrect++;
    } else if (item.kind == ItemKind.task) {
      falseTasks++;
      problems.add('"${e.startsWith}": false task');
    } else {
      missedTasks++;
      problems.add('"${e.startsWith}": missed task');
    }
    if (e.reminder != null || item.reminder != null) {
      reminderChecks++;
      if (item.reminder == e.reminder) {
        reminderCorrect++;
      } else {
        problems.add(
          '"${e.startsWith}": reminder ${item.reminder}, expected ${e.reminder}',
        );
      }
    }
    if (e.due != null && item.due != e.due) {
      problems.add('"${e.startsWith}": due ${item.due}, expected ${e.due}');
    }
    if (item.included != e.included) {
      problems.add('"${e.startsWith}": included ${item.included}');
    }
    for (final f in e.flags) {
      flagChecks++;
      if (item.flags.contains(f)) {
        flagsPresent++;
      } else {
        problems.add('"${e.startsWith}": missing flag ${f.name}');
      }
    }
    return problems;
  }

  String render() {
    String pct(int a, int b) =>
        b == 0 ? 'n/a' : '$a/$b (${(100 * a / b).round()}%)';
    return [
      ...rows,
      if (pending.isNotEmpty) 'PENDING: ${pending.join(', ')}',
      '',
      'Boundary recall    ${pct(correctBoundaries, goldBoundaries)}',
      'Boundary precision ${pct(correctBoundaries, predictedBoundaries)}',
      'Group accuracy     ${pct(groupCorrect, alignedItems)}',
      'Note/task accuracy ${pct(kindCorrect, alignedItems)}  (false tasks $falseTasks, missed tasks $missedTasks)',
      'Reminders correct  ${pct(reminderCorrect, reminderChecks)}',
      'Expected flags     ${pct(flagsPresent, flagChecks)}',
      'Source-text loss   $sourceLoss case(s)',
      'Requests $requests, input tokens $tokens, summed Jev latency ${latencyMs}ms',
    ].join('\n');
  }
}
