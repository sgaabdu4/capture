import 'package:capture/features/capture/domain/text/boundary_kind.dart';
import 'package:capture/features/capture/domain/text/coverage.dart';
import 'package:capture/features/capture/domain/text/transcript_unit.dart';

export 'package:capture/features/capture/domain/text/boundary_kind.dart';
export 'package:capture/features/capture/domain/text/transcript_unit.dart';

/// Tokens that end with a full stop without ending a sentence. Single letters
/// ("p.m.", "e.g.") are handled separately.
const _abbreviations = {
  'mr', 'mrs', 'ms', 'dr', 'st', 'vs', 'etc', 'jr', 'sr', 'prof', 'approx', //
};

const _conjunctions = {'and', 'but', 'so', 'plus'};

/// Discourse markers / action openers that may begin a new thought even
/// without punctuation. Lowercase word sequences.
const _markers = [
  ['by', 'the', 'way'],
  ['oh', 'and'],
  ['and', 'also'],
  ['and', 'then'],
  ['also'],
  ['anyway'],
  ['anyways'],
  ['remind', 'me'],
  ['note', 'to', 'self'],
  ['don’t', 'forget'],
  ["don't", 'forget'],
  ['i', 'need', 'to'],
  ['i', 'have', 'to'],
  ['i', 'must'],
  ['i', 'should'],
];

final _letter = RegExp(r'\p{L}', unicode: true);
final _word = RegExp(r"[\p{L}\p{N}][\p{L}\p{N}'’\-]*", unicode: true);
final _sentenceEnd = RegExp(r'''[.!?…]+["'”’)\]]*(?=\s)''', unicode: true);
final _nonSpace = RegExp(r'\S');

/// Minimum words in a unit created by a clause-level candidate. Keeps
/// "Buy milk and bread" together while allowing "and book a haircut".
const minClauseWords = 2;

/// Proposes candidate thought boundaries. Over-generation is acceptable (each
/// candidate costs one Jev question); a missing candidate cannot be recovered
/// by classification, so the review editor also allows manual splits.
List<TranscriptUnit> splitCandidates(String text) {
  final splitter = _Splitter(text, _word.allMatches(text).toList(growable: false));
  if (splitter.words.isEmpty) return const [];
  splitter
    ..addSentenceCuts()
    ..addClauseCuts();
  return splitter.units();
}

/// Index of the first non-whitespace UTF-16 unit at or after [from].
int firstNonSpace(String text, int from) {
  if (from >= text.length) return from;
  final next = text.indexOf(_nonSpace, from);
  return next < 0 ? text.length : next;
}

/// End offset of `text[start, end)` with trailing whitespace removed.
int trimEnd(String text, int start, int end) {
  if (end <= start) return end;
  final last = text.lastIndexOf(_nonSpace, end - 1);
  return last < start ? start : last + 1;
}

class _Splitter {
  _Splitter(this.text, this.words)
    : lower = [for (final w in words) text.substring(w.start, w.end).toLowerCase()];

  final String text;
  final List<RegExpMatch> words;

  /// Lowercase text of each word in [words].
  final List<String> lower;
  final cuts = <int, BoundaryKind>{};

  void addSentenceCuts() {
    for (final end in _sentenceEnd.allMatches(text)) {
      final next = firstNonSpace(text, end.end);
      if (next < text.length && !_isAbbreviation(end)) cuts[next] = .sentence;
    }
  }

  /// A single full stop right after an abbreviation or a lone letter. A
  /// full stop with no word before it ends a sentence.
  bool _isAbbreviation(RegExpMatch end) {
    if (end[0] != '.') return false;
    final before = words.reversed.where((w) => w.end <= end.start).firstOrNull;
    if (before == null) return false;
    final token = text.substring(before.start, end.start).toLowerCase();
    return _abbreviations.contains(token) || (token.length == 1 && _letter.hasMatch(token));
  }

  void addClauseCuts() {
    for (int i = 1; i < words.length; i++) {
      if (_clauseCandidate(i) case final kind?) cuts[words[i].start] = kind;
    }
  }

  BoundaryKind? _clauseCandidate(int i) {
    if (_cutBefore(i)) return null;
    final marker = _markers.where(_matchesAt(i)).firstOrNull;
    if (marker == null && !_conjunctions.contains(lower[i])) return null;
    // "and also" / "oh and": keep the earliest word of a marker run.
    if (i > 1 && _cutBefore(i - 1)) return null;
    final needed = (marker?.length ?? 1) + minClauseWords - 1;
    if (_wordsToSentenceEnd(i) <= needed) return null;
    if (_wordsSinceCut(i) < minClauseWords) return null;
    return marker == null ? .conjunction : .marker;
  }

  bool Function(List<String>) _matchesAt(int index) =>
      (marker) =>
          index + marker.length <= lower.length &&
          Iterable<int>.generate(marker.length).every((j) => lower[index + j] == marker[j]);

  bool _cutBefore(int j) =>
      j == 0 || cuts.keys.any((c) => c >= words[j - 1].end && c <= words[j].start);

  int _wordsSinceCut(int i) {
    int count = 1;
    while (i - count > 0 && !_cutBefore(i - count)) {
      count++;
    }
    return count;
  }

  /// Words from [index] to the end of its sentence. Later clause cuts are not
  /// known yet, so this is an upper bound.
  int _wordsToSentenceEnd(int index) {
    final end = _sentenceEnd.allMatches(text, words[index].start).firstOrNull;
    final limit = end?.end ?? text.length;
    return words.skip(index).takeWhile((w) => w.start < limit).length;
  }

  List<TranscriptUnit> units() {
    final starts = cuts.keys.toList()..sort();
    final units = <TranscriptUnit>[];
    int unitStart = firstNonSpace(text, 0);
    BoundaryKind kind = .start;
    for (final cut in [...starts, text.length]) {
      if (cut > unitStart) {
        final end = trimEnd(text, unitStart, cut);
        if (end > unitStart) {
          units.add(.new(_unitId(units.length + 1), spanOf(text, unitStart, end), kind));
        }
        unitStart = cut;
        kind = cuts[cut] ?? .sentence;
      }
    }
    return units;
  }
}

/// Unit ids are `U001`, `U002`, … in source order.
String _unitId(int number) => 'U${number.toString().padLeft(_unitIdDigits, '0')}';

const _unitIdDigits = 3;
