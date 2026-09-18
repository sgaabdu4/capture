import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/data/notion/notion_keys.dart';
import 'package:capture/features/capture/domain/entities/due_date.dart';

/// Pure builders/readers for Notion JSON shapes (API 2026-03-11).

/// Longest text Notion accepts in one rich-text object.
const maxRichText = 2000;

/// Most children Notion accepts in one append request.
const maxChildren = 100;

const _untitled = 'Untitled';

List<Json> richText(String value) => [
  for (int i = 0; i < value.length; i += maxRichText)
    {
      NotionKeys.type: 'text',
      NotionKeys.text: {
        NotionKeys.content: value.substring(
          i,
          i + maxRichText > value.length ? value.length : i + maxRichText,
        ),
      },
    },
];

Json titleValue(String text) => {NotionKeys.title: richText(text.isEmpty ? _untitled : text)};

Json textValue(String text) => {NotionKeys.richText: richText(text)};

Json selectValue(String name) => {
  NotionKeys.select: {NotionKeys.name: name},
};

Json relationValue(Iterable<String> ids) => {
  NotionKeys.relation: [
    for (final id in ids) {NotionKeys.id: id},
  ],
};

/// A date property. Timed values carry the capture's IANA zone so Notion
/// shows the wall time the user meant.
Json dateValue(DueDate? date, String timeZone) => {
  NotionKeys.date: switch (date) {
    final DueDate d => {NotionKeys.start: d.iso, if (d.hasTime) NotionKeys.timeZone: timeZone},
    null => null,
  },
};

Json block(String type, String text) => {
  NotionKeys.object: 'block',
  NotionKeys.type: type,
  type: {NotionKeys.richText: richText(text)},
};

/// Paragraph blocks of at most [maxRichText] characters, split at spaces.
List<Json> paragraphs(String text) {
  final out = <Json>[];
  String rest = text.trim();
  while (rest.isNotEmpty) {
    int cut = rest.length <= maxRichText ? rest.length : maxRichText;
    if (cut < rest.length) {
      final space = rest.lastIndexOf(' ', cut);
      if (space > maxRichText ~/ 2) cut = space;
    }
    out.add(block('paragraph', rest.substring(0, cut).trim()));
    rest = rest.substring(cut).trim();
  }
  return out;
}

String plainText(Object? richTextList) => switch (richTextList) {
  final List<Object?> parts => parts.map(_plain).join(),
  _ => '',
};

String _plain(Object? part) => switch (part) {
  {'plain_text': final String text} => text,
  {'text': {'content': final String text}} => text,
  _ => '',
};

Object? _prop(Json page, String name) => switch (page) {
  {'properties': final Json props} => props[name],
  _ => null,
};

String propText(Json page, String name) => switch (_prop(page, name)) {
  {'title': final Object? text} || {'rich_text': final Object? text} => plainText(text),
  _ => '',
};

String? propSelect(Json page, String name) => switch (_prop(page, name)) {
  {NotionKeys.select: {NotionKeys.name: final String value}} => value,
  _ => null,
};

List<String> propRelation(Json page, String name) => switch (_prop(page, name)) {
  {'relation': final List<Object?> relations} => [
    for (final r in relations)
      if (r case {'id': final String id}) id,
  ],
  _ => const [],
};

bool propCheckbox(Json page, String name) => switch (_prop(page, name)) {
  {'checkbox': true} => true,
  _ => false,
};

List<Object?> propFiles(Json page, String name) => switch (_prop(page, name)) {
  {'files': final List<Object?> files} => files,
  _ => const [],
};

final _datePattern = RegExp(r'^(\d{4})-(\d{2})-(\d{2})(?:T(\d{2}):(\d{2}))?');

/// Reads a Notion date start (`2026-09-19` or `2026-09-19T14:00:00.000+01:00`)
/// as the wall-clock date it names.
DueDate? propDate(Json page, String name) => switch (_prop(page, name)) {
  {'date': {'start': final String start}} => _wallDate(start),
  _ => null,
};

DueDate? _wallDate(String start) {
  final m = _datePattern.firstMatch(start);
  if (m == null) return null;
  return switch ([for (int g = 1; g <= m.groupCount; g++) m[g]]) {
    [final String y, final String mo, final String d, final String h, final String mi] => .new(
      .parse(y),
      .parse(mo),
      .parse(d),
      hour: .parse(h),
      minute: .parse(mi),
    ),
    [final String y, final String mo, final String d, ...] => .new(
      .parse(y),
      .parse(mo),
      .parse(d),
    ),
    _ => null,
  };
}

final _dashedId = RegExp(
  r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
);
final _hexId = RegExp(r'([0-9a-fA-F]{32})$');

/// Group boundaries of a canonical UUID, as offsets into its 32 hex digits.
const _uuidBounds = [0, 8, 12, 16, 20, 32];

/// Accepts a Notion page URL or id and returns the dashed id. For URLs the
/// id is the trailing 32 hex characters of the last path segment (query
/// strings such as `?v=` view ids are ignored).
String? parseNotionId(String input) {
  final trimmed = input.trim();
  final segment = switch (Uri.tryParse(trimmed)) {
    final Uri uri when uri.hasScheme =>
      uri.pathSegments.where((s) => s.isNotEmpty).lastOrNull ?? '',
    _ => trimmed,
  };
  final compact = _dashedId.hasMatch(segment) ? segment.replaceAll('-', '') : segment;
  if (_hexId.firstMatch(compact)?[1] case final String hex) {
    final id = hex.toLowerCase();
    return [
      for (int i = 1; i < _uuidBounds.length; i++) id.substring(_uuidBounds[i - 1], _uuidBounds[i]),
    ].join('-');
  }
  return null;
}
