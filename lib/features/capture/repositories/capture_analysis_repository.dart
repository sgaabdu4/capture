import 'package:capture/features/capture/domain/jev/boundary_pass.dart';
import 'package:capture/features/capture/domain/jev/classification_pass.dart';
import 'package:capture/features/capture/domain/jev/jev_protocol.dart';
import 'package:capture/features/capture/domain/jev/thresholds.dart';
import 'package:capture/features/capture/domain/entities/models.dart';
import 'package:capture/features/capture/domain/proposal/proposal_builder.dart';
import 'package:capture/features/capture/domain/entities/source_span.dart';
import 'package:capture/features/capture/domain/text/assembly.dart';
import 'package:capture/features/capture/domain/text/candidate_splitter.dart';
import 'package:capture/features/capture/data/datasources/jev_remote_datasource.dart';
import 'package:timezone/timezone.dart' as tz;

/// Result of analysing one transcript: the proposal plus request metadata.
class Analysis {
  const Analysis({
    required this.items,
    required this.thoughts,
    required this.units,
    required this.calls,
  });

  final List<ProposalItem> items;
  final List<Thought> thoughts;
  final List<TranscriptUnit> units;
  final List<JevCallMetrics> calls;

  int get requestCount => calls.length;
  int get inputTokens => calls.fold(0, (sum, c) => sum + c.inputTokens);
  Duration get latency => calls.fold(Duration.zero, (sum, c) => sum + c.latency);
}

/// Runs the two-pass pipeline for a completed transcript:
/// code candidates → Jev boundary pass → code assembly → Jev classification
/// pass → code proposal. Only the transcript text and group descriptions are
/// sent; never audio.
class CaptureAnalyzer {
  const CaptureAnalyzer(this._jev);
  final JevClient _jev;

  Future<Analysis> analyze({
    required String transcript,
    required List<Group> groups,
    required DateTime capturedAtUtc,
    required tz.Location location,
    required String Function() newId,
  }) async {
    final calls = <JevCallMetrics>[];
    final units = splitCandidates(transcript);
    if (units.isEmpty) {
      return Analysis(items: const [], thoughts: const [], units: units, calls: calls);
    }
    final decisions = await _boundaries(units, calls);
    final thoughts = assembleThoughts(transcript, units, decisions);
    final plan = planClassification(transcript, thoughts, groups);
    final answers = await _askAll(plan.state, plan.questions, calls);
    final items = buildProposal(
      thoughts: thoughts,
      decisions: decodeClassification(plan, thoughts, answers),
      plan: plan,
      groups: groups,
      capturedAtUtc: capturedAtUtc,
      location: location,
      newId: newId,
    );
    return Analysis(items: items, thoughts: thoughts, units: units, calls: calls);
  }

  Future<Map<int, BoundaryDecision>> _boundaries(
    List<TranscriptUnit> units,
    List<JevCallMetrics> calls,
  ) async {
    if (units.length < 2) return const {};
    final answers = await _askAll(boundaryState(units), {
      ...boundaryQuestions(units),
      ...lateCorrectionQuestions(units),
    }, calls);
    return {
      for (var i = 1; i < units.length; i++)
        i: _decision(
          (answers[boundaryKey(units[i])]! as NoulAnswer).yes,
          (answers[lateCorrectionKey(units[i])] as NoulAnswer?)?.yes ?? 0,
        ),
    };
  }

  BoundaryDecision _decision(double p, double late) => BoundaryDecision(
    boundaryBand.yes(p),
    boundaryBand.uncertain(p),
    p,
    lateCorrection: correctionBand.yes(late),
  );

  Future<Map<String, JevAnswer>> _askAll(
    String state,
    Map<String, JevQuestion> questions,
    List<JevCallMetrics> calls,
  ) async {
    final answers = <String, JevAnswer>{};
    for (final batch in batchQuestions(state, questions)) {
      final (result, metrics) = await _jev.ask(state, batch);
      answers.addAll(result.answers);
      calls.add(metrics);
    }
    return answers;
  }
}

/// Whole transcript as one span (manual fallback when Jev is unavailable).
Thought wholeTranscript(String transcript) {
  final start = firstNonSpace(transcript, 0);
  final end = trimEnd(transcript, start, transcript.length);
  return Thought('T1', const [], SourceSpan.of(transcript, start, end));
}
