import 'package:capture/features/capture/domain/entities/jev_call_metrics.dart';
import 'package:capture/features/capture/domain/entities/proposal_item.dart';
import 'package:capture/features/capture/domain/text/assembly.dart';
import 'package:capture/features/capture/domain/text/candidate_splitter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'analysis.freezed.dart';

/// Result of analysing one transcript: the proposal plus request metadata.
@freezed
sealed class Analysis with _$Analysis {
  const Analysis._();

  const factory Analysis({
    required List<ProposalItem> items,
    required List<Thought> thoughts,
    required List<TranscriptUnit> units,
    required List<JevCallMetrics> calls,
  }) = _Analysis;

  int get requestCount => calls.length;
  int get inputTokens => calls.fold(0, (sum, c) => sum + c.inputTokens);
  Duration get latency => calls.fold(.zero, (sum, c) => sum + c.latency);
}
