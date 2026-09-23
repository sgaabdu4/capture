import 'package:capture/core/data/system/system_datasource.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/capture/data/datasources/jev_remote_datasource.dart';
import 'package:capture/features/capture/domain/dates/capture_moment.dart';
import 'package:capture/features/capture/domain/entities/analysis.dart';
import 'package:capture/features/capture/domain/entities/jev_call_metrics.dart';
import 'package:capture/features/capture/domain/jev/boundary_pass.dart';
import 'package:capture/features/capture/domain/jev/classification_pass.dart';
import 'package:capture/features/capture/domain/jev/jev_protocol.dart';
import 'package:capture/features/capture/domain/jev/thresholds.dart';
import 'package:capture/features/capture/domain/proposal/proposal_builder.dart';
import 'package:capture/features/capture/domain/text/assembly.dart';
import 'package:capture/features/capture/domain/text/candidate_splitter.dart';
import 'package:capture/features/capture/domain/text/coverage.dart';
import 'package:capture/features/groups/domain/entities/group.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'capture_analysis_repository.g.dart';

/// Runs the two-pass pipeline for a completed transcript:
/// code candidates → Jev boundary pass → code assembly → Jev classification
/// pass → code proposal. Only the transcript text and group descriptions are
/// sent; never audio.
abstract interface class ICaptureAnalysisRepository {
  Future<JevOutcome<Analysis>> analyze({
    required String transcript,
    required List<Group> groups,
    required CaptureMoment moment,
  });
}

/// Boundaries exist only between two units.
const _minUnitsForBoundary = 2;

/// Metadata of every Jev request made for one analysis.
class _CallLog {
  final _calls = <JevCallMetrics>[];

  List<JevCallMetrics> get all => .unmodifiable(_calls);

  void add(JevCallMetrics metrics) => _calls.add(metrics);
}

class CaptureAnalysisRepository implements ICaptureAnalysisRepository {
  const CaptureAnalysisRepository(this._jev, this._system);
  final IJevRemoteDatasource _jev;
  final ISystemDatasource _system;

  @override
  Future<JevOutcome<Analysis>> analyze({
    required String transcript,
    required List<Group> groups,
    required CaptureMoment moment,
  }) async {
    final calls = _CallLog();
    final units = splitCandidates(transcript);
    if (units.isEmpty) {
      return .ok(.new(items: const [], thoughts: const [], units: units, calls: calls.all));
    }
    final Map<int, BoundaryDecision> decisions;
    switch (await _boundaries(units, calls)) {
      case Ok(:final value):
        decisions = value;
      case Err(:final failure):
        return .err(failure);
    }
    final thoughts = assembleThoughts(transcript, units, decisions);
    final plan = planClassification(transcript, thoughts, groups);
    final Map<String, JevAnswer> answers;
    switch (await _askAll(plan.state.value, plan.questions, calls)) {
      case Ok(:final value):
        answers = value;
      case Err(:final failure):
        return .err(failure);
    }
    return switch (decodeClassification(plan, thoughts, answers)) {
      Ok(value: final decisions) => .ok(
        .new(
          items: buildProposal(
            decisions: decisions,
            plan: plan,
            moment: moment,
            newId: _system.newId,
          ),
          thoughts: thoughts,
          units: units,
          calls: calls.all,
        ),
      ),
      Err() => const .err(.invalidResponse),
    };
  }

  Future<JevOutcome<Map<int, BoundaryDecision>>> _boundaries(
    List<TranscriptUnit> units,
    _CallLog calls,
  ) async {
    if (units.length < _minUnitsForBoundary) return const .ok({});
    final questions = {...boundaryQuestions(units), ...lateCorrectionQuestions(units)};
    return switch (await _askAll(boundaryState(units), questions, calls)) {
      Ok(value: final answers) => .ok({
        for (final (i, unit) in units.indexed.skip(1))
          i: _decision(_yes(answers[boundaryKey(unit)]), _yes(answers[lateCorrectionKey(unit)])),
      }),
      Err(:final failure) => .err(failure),
    };
  }

  double _yes(JevAnswer? answer) => switch (answer) {
    NoulAnswer(:final yes) => yes,
    _ => 0,
  };

  BoundaryDecision _decision(double p, double late) => .new(
    split: boundaryBand.yes(p),
    uncertain: boundaryBand.uncertain(p),
    yes: p,
    lateCorrection: correctionBand.yes(late),
  );

  Future<JevOutcome<Map<String, JevAnswer>>> _askAll(
    String state,
    Map<String, JevQuestion> questions,
    _CallLog calls,
  ) async {
    final List<Map<String, JevQuestion>> batches;
    switch (batchQuestions(state, questions)) {
      case Ok(:final value):
        batches = value;
      case Err():
        return const .err(.invalidResponse);
    }
    final answers = <String, JevAnswer>{};
    for (final batch in batches) {
      switch (await _jev.ask(state, batch)) {
        case Ok(value: (:final result, :final metrics)):
          answers.addAll(result.answers);
          calls.add(metrics);
        case Err(:final failure):
          return .err(failure);
      }
    }
    return .ok(answers);
  }
}

/// Whole transcript as one span (manual fallback when Jev is unavailable).
Thought wholeTranscript(String transcript) {
  final start = firstNonSpace(transcript, 0);
  final end = trimEnd(transcript, start, transcript.length);
  return .new(thoughtId(1), const [], spanOf(transcript, start, end));
}

@Riverpod(keepAlive: true)
ICaptureAnalysisRepository captureAnalysisRepository(Ref ref) => CaptureAnalysisRepository(
  ref.read(jevRemoteDatasourceProvider),
  ref.read(systemDatasourceProvider),
);
