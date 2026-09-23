import 'package:capture/core/domain/values/required_text.dart';
import 'package:capture/features/capture/domain/entities/edited_field.dart';
import 'package:capture/features/capture/domain/entities/proposal_item.dart';
import 'package:capture/features/capture/domain/entities/review_flag.dart';
import 'package:capture/features/capture/domain/entities/source_span.dart';
import 'package:capture/features/capture/domain/text/candidate_splitter.dart';
import 'package:capture/features/capture/domain/text/coverage.dart';
import 'package:capture/features/capture/domain/text/titles.dart';
import 'package:capture/features/capture/domain/values/item_id.dart';

/// The two items a split produces, in source order.
typedef SplitItems = ({ProposalItem left, ProposalItem right});

/// Splits [item] at transcript offset [at] (which must fall strictly inside
/// one of its source spans, on whitespace/word start). Both pieces keep
/// their source links, reset body/title to their own source text and are
/// flagged for group/type review. Returns null for an invalid split point.
SplitItems? splitItem(ProposalItem item, String transcript, int at, ItemId newId) {
  final sources = item.sources;
  final index = sources.indexWhere((s) => at > s.start && at < s.end);
  if (index < 0) return null;
  final SourceSpan(:start, :end) = sources[index];
  final leftEnd = trimEnd(transcript, start, at);
  final rightStart = firstNonSpace(transcript, at);
  if (leftEnd <= start || rightStart >= end) return null;
  return (
    left: _piece(item, item.id, [...sources.take(index), spanOf(transcript, start, leftEnd)]),
    right: _piece(item, newId, [spanOf(transcript, rightStart, end), ...sources.skip(index + 1)]),
  );
}

/// One split piece of [item] holding [sources].
ProposalItem _piece(ProposalItem item, ItemId id, List<SourceSpan> sources) {
  final excerpt = sources.map((s) => s.excerpt.value).join(' ');
  final ProposalItem(:kind, :groupId, :due, :reminder, :flags) = item;
  return .new(
    id: id,
    sources: sources,
    kind: kind,
    groupId: groupId,
    title: proposedTitle(excerpt),
    body: proposedBody(excerpt),
    due: due,
    reminder: reminder,
    flags: {
      ...flags.difference({ReviewFlag.checkSplit}),
      .newPiece,
    },
  );
}

/// Merges [second] into [first]. The first item's choices (and any user
/// edits) are kept; differing group/type is flagged instead of silently
/// picking one.
ProposalItem mergeItems(ProposalItem first, ProposalItem second) {
  final ProposalItem(
    :copyWith,
    :sources,
    :edited,
    :body,
    :title,
    :groupId,
    :kind,
    :due,
    :reminder,
    :flags,
  ) = first;
  final ProposalItem(
    sources: secondSources,
    edited: secondEdited,
    body: secondBody,
    groupId: secondGroupId,
    kind: secondKind,
    due: secondDue,
    reminder: secondReminder,
    flags: secondFlags,
  ) = second;
  final merged = [...sources, ...secondSources]..sort((a, b) => a.start.compareTo(b.start));
  final excerpt = merged.map((s) => s.excerpt.value).join(' ');
  final bodyEdited = edited.contains(EditedField.body) || secondEdited.contains(EditedField.body);
  final conflicting = groupId != secondGroupId || kind != secondKind;
  return copyWith(
    sources: merged,
    body: bodyEdited ? optionalText([?body, ?secondBody].join('\n')) : proposedBody(excerpt),
    title: edited.contains(EditedField.title) ? title : proposedTitle(excerpt),
    due: due ?? secondDue,
    reminder: reminder ?? secondReminder,
    flags: {
      ...flags,
      ...secondFlags,
      if (conflicting) ReviewFlag.newPiece,
    }.difference({ReviewFlag.checkSplit}),
  );
}
