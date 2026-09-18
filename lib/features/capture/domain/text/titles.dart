/// Extractive titles and bodies. Deliberately a few plain string rules, not a
/// language model: the full source text is always kept in the body.
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

const maxTitleLength = 60;

/// A truncated title is cut at its last word boundary unless that would
/// leave fewer characters than this; then it is cut mid-word.
const _minWordCutLength = 20;

/// A half-open `[start, end)` range of offsets into an excerpt.
typedef ExcerptRange = ({int start, int end});

/// Body text proposed for an item: the source excerpt without a leading
/// connective ("and thought of…" → "Thought of…").
String proposedBody(String excerpt) => _capitalise(_stripPrefix(excerpt.trim(), _connectives));

/// Title from the first clause, with date/time phrases (offsets relative to
/// [excerpt]) removed and common action prefixes stripped.
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
  final sorted = [...ranges]..sort((a, b) => b.start.compareTo(a.start));
  return sorted
      .fold(text, _blank)
      .replaceAll(RegExp(r'[ \t]{2,}'), ' ')
      .replaceAll(RegExp(r' (?=[,.;!?])'), '');
}

/// [text] with [range] replaced by one space; out-of-bounds or empty ranges
/// are ignored.
String _blank(String text, ExcerptRange range) {
  final (:start, :end) = range;
  if (start < 0 || end > text.length || start >= end) return text;
  return text.replaceRange(start, end, ' ');
}

String _stripPrefix(String text, List<String> prefixes) {
  final lower = text.toLowerCase();
  for (final p in prefixes) {
    if (lower.startsWith('$p ') || lower.startsWith('$p,')) {
      return text.substring(p.length).replaceFirst(RegExp(r'^[,\s]+'), '');
    }
  }
  return text;
}

String _firstClause(String text) {
  final m = RegExp(r'[.!?;…]|\s[—–-]\s').firstMatch(text);
  return (m == null ? text : text.substring(0, m.start)).trim();
}

String _trimDangling(String text) {
  List<String> words = text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
  while (words.isNotEmpty &&
      _dangling.contains(words.last.toLowerCase().replaceAll(RegExp(r'[,]'), ''))) {
    words = words.sublist(0, words.length - 1);
  }
  return words.join(' ').replaceAll(RegExp(r'[,\s]+$'), '');
}

String _capitalise(String text) => text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);

String _truncate(String text) {
  if (text.length <= maxTitleLength) return text;
  final cut = text.substring(0, maxTitleLength);
  final space = cut.lastIndexOf(' ');
  return '${(space > _minWordCutLength ? cut.substring(0, space) : cut).trimRight()}…';
}
