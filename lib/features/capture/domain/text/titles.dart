/// Extractive titles and bodies from a few plain string rules, not a language model.
library;

const _connectives = [
  'and also', 'and then', 'oh and', 'by the way', 'and', 'but', 'so', 'plus', //
  'also', 'anyway', 'anyways', 'then', 'oh',
];

const _actionPrefixes = [
  'remind me to', 'remind me that', 'remind me', 'i need to', 'i have to', //
  "don't forget to", 'don’t forget to', 'note to self', 'i must', 'i should',
  'i want to',
];

const _dangling = {'at', 'on', 'by', 'for', 'around', 'about', 'until', 'from'};

final _runOfSpaces = RegExp(r'[ \t]{2,}');
final _spaceBeforePunctuation = RegExp(r' (?=[,.;!?])');
final _leadingSeparators = RegExp(r'^[,\s]+');
final _clauseEnd = RegExp(r'[.!?;…]|\s[—–-]\s');
final _whitespace = RegExp(r'\s+');
final _trailingSeparators = RegExp(r'[,\s]+$');

const maxTitleLength = 60;

/// A truncated title is cut mid-word when a word cut would leave fewer characters than this.
const _minWordCutLength = 20;

/// A half-open `[start, end)` range of offsets into an excerpt.
typedef ExcerptRange = ({int start, int end});

/// Body text proposed for an item: the excerpt without a leading connective.
String proposedBody(String excerpt) => _capitalise(_stripPrefix(excerpt.trim(), _connectives));

/// Title from the first clause, with the [remove] ranges of [excerpt] cut out and action prefixes stripped.
String proposedTitle(String excerpt, {List<ExcerptRange> remove = const []}) {
  String text = _removeRanges(excerpt, remove);
  text = _stripPrefix(text.trim(), _connectives);
  text = _firstClause(text);
  text = _stripPrefix(text, _actionPrefixes);
  text = _trimDangling(text);
  if (text.isEmpty) text = _firstClause(excerpt.trim());
  return _truncate(_capitalise(text));
}

String _removeRanges(String text, List<ExcerptRange> ranges) {
  final sorted = [for (final r in ranges) _withPreposition(text, r)]
    ..sort((a, b) => b.start.compareTo(a.start));
  return sorted
      .fold(text, _blank)
      .replaceAll(_runOfSpaces, ' ')
      .replaceAll(_spaceBeforePunctuation, '');
}

/// A preposition directly before a date phrase goes with it ("dentist at [9 tomorrow]" → "dentist").
final _prepositionBefore = RegExp('\\b(?:${_dangling.join('|')})\\s+\$', caseSensitive: false);

ExcerptRange _withPreposition(String text, ExcerptRange range) {
  final (:start, :end) = range;
  if (start < 0 || start > text.length) return range;
  final m = _prepositionBefore.firstMatch(text.substring(0, start));
  return m == null ? range : (start: m.start, end: end);
}

/// [text] with [range] replaced by one space; out-of-bounds or empty ranges are ignored.
String _blank(String text, ExcerptRange range) {
  final (:start, :end) = range;
  if (start < 0 || end > text.length || start >= end) return text;
  return text.replaceRange(start, end, ' ');
}

String _stripPrefix(String text, List<String> prefixes) {
  final lower = text.toLowerCase();
  for (final p in prefixes) {
    if (lower.startsWith('$p ') || lower.startsWith('$p,')) {
      return text.substring(p.length).replaceFirst(_leadingSeparators, '');
    }
  }
  return text;
}

String _firstClause(String text) {
  final m = _clauseEnd.firstMatch(text);
  return (m == null ? text : text.substring(0, m.start)).trim();
}

String _trimDangling(String text) {
  List<String> words = text.split(_whitespace).where((w) => w.isNotEmpty).toList();
  while (words.isNotEmpty && _dangling.contains(words.last.toLowerCase().replaceAll(',', ''))) {
    words = words.sublist(0, words.length - 1);
  }
  return words.join(' ').replaceAll(_trailingSeparators, '');
}

String _capitalise(String text) => text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);

String _truncate(String text) {
  if (text.length <= maxTitleLength) return text;
  final cut = text.substring(0, maxTitleLength);
  final space = cut.lastIndexOf(' ');
  return '${(space > _minWordCutLength ? cut.substring(0, space) : cut).trimRight()}…';
}
