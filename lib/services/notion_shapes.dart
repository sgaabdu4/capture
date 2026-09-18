import '../domain/models.dart';

/// Pure builders/readers for Notion JSON shapes (API 2026-03-11).

const maxRichText = 2000;
const maxChildren = 100;

List<Map<String, Object?>> richText(String text) => [
  for (var i = 0; i < text.length; i += maxRichText)
    {
      'type': 'text',
      'text': {
        'content': text.substring(
          i,
          i + maxRichText > text.length ? text.length : i + maxRichText,
        ),
      },
    },
];

Map<String, Object?> titleValue(String text) => {
  'title': richText(text.isEmpty ? 'Untitled' : text),
};

Map<String, Object?> textValue(String text) => {'rich_text': richText(text)};

Map<String, Object?> selectValue(String name) => {
  'select': {'name': name},
};

Map<String, Object?> relationValue(Iterable<String> ids) => {
  'relation': [
    for (final id in ids) {'id': id},
  ],
};

/// A date property. Timed values carry the capture's IANA zone so Notion
/// shows the wall time the user meant.
Map<String, Object?> dateValue(DueDate? date, String timeZone) => {
  'date': date == null
      ? null
      : {'start': date.iso, if (date.hasTime) 'time_zone': timeZone},
};

Map<String, Object?> block(String type, String text) => {
  'object': 'block',
  'type': type,
  type: {'rich_text': richText(text)},
};

/// Paragraph blocks of at most [maxRichText] characters, split at spaces.
List<Map<String, Object?>> paragraphs(String text) {
  final out = <Map<String, Object?>>[];
  var rest = text.trim();
  while (rest.isNotEmpty) {
    var cut = rest.length <= maxRichText ? rest.length : maxRichText;
    if (cut < rest.length) {
      final space = rest.lastIndexOf(' ', cut);
      if (space > maxRichText ~/ 2) cut = space;
    }
    out.add(block('paragraph', rest.substring(0, cut).trim()));
    rest = rest.substring(cut).trim();
  }
  return out;
}

String plainText(Object? richTextList) => [
  for (final t in richTextList as List<Object?>? ?? const [])
    _plain(t! as Map<String, Object?>),
].join();

String _plain(Map<String, Object?> t) =>
    t['plain_text'] as String? ??
    (t['text'] as Map<String, Object?>?)?['content'] as String? ??
    '';

Map<String, Object?> props(Map<String, Object?> page) =>
    page['properties'] as Map<String, Object?>? ?? const {};

String propText(Map<String, Object?> page, String name) {
  final p = props(page)[name] as Map<String, Object?>?;
  if (p == null) return '';
  return plainText(p['title'] ?? p['rich_text']);
}

String? propSelect(Map<String, Object?> page, String name) {
  final p = props(page)[name] as Map<String, Object?>?;
  return (p?['select'] as Map<String, Object?>?)?['name'] as String?;
}

List<String> propRelation(Map<String, Object?> page, String name) => [
  for (final r
      in (props(page)[name] as Map<String, Object?>?)?['relation']
              as List<Object?>? ??
          const [])
    (r! as Map<String, Object?>)['id']! as String,
];

bool propCheckbox(Map<String, Object?> page, String name) =>
    (props(page)[name] as Map<String, Object?>?)?['checkbox'] as bool? ?? false;

List<Object?> propFiles(Map<String, Object?> page, String name) =>
    (props(page)[name] as Map<String, Object?>?)?['files'] as List<Object?>? ??
    const [];

/// Reads a Notion date start (`2026-09-19` or `2026-09-19T14:00:00.000+01:00`)
/// as the wall-clock date it names.
DueDate? propDate(Map<String, Object?> page, String name) {
  final date = (props(page)[name] as Map<String, Object?>?)?['date'];
  final start = (date as Map<String, Object?>?)?['start'] as String?;
  if (start == null) return null;
  final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})(?:T(\d{2}):(\d{2}))?')
      .firstMatch(start);
  if (match == null) return null;
  final hour = match[4];
  return DueDate(
    int.parse(match[1]!),
    int.parse(match[2]!),
    int.parse(match[3]!),
    hour: hour == null ? null : int.parse(hour),
    minute: hour == null ? null : int.parse(match[5]!),
  );
}

/// Accepts a Notion page URL or id and returns the dashed id. For URLs the
/// id is the trailing 32 hex characters of the last path segment (query
/// strings such as `?v=` view ids are ignored).
String? parseNotionId(String input) {
  var segment = input.trim();
  final uri = Uri.tryParse(segment);
  if (uri != null && uri.hasScheme) {
    segment = uri.pathSegments.where((s) => s.isNotEmpty).lastOrNull ?? '';
  }
  final dashed = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  );
  if (dashed.hasMatch(segment)) segment = segment.replaceAll('-', '');
  final match = RegExp(r'([0-9a-fA-F]{32})$').firstMatch(segment);
  if (match == null) return null;
  final id = match[1]!.toLowerCase();
  return '${id.substring(0, 8)}-${id.substring(8, 12)}-${id.substring(12, 16)}-'
      '${id.substring(16, 20)}-${id.substring(20)}';
}
