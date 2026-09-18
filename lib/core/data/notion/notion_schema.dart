import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:intl/intl.dart';

/// The Notion structure Capture creates and reads: the marked "Capture"
/// area page and its Groups, Captures and Library data sources.
const areaTitle = 'Capture';
const areaMarkerPrefix = 'Managed by the Capture app';
const areaMarker =
    'Managed by the Capture app. Rename pages freely, but keep the Groups, Captures and Library databases here.';

/// Capture page titles, e.g. "Capture 18 Sep 2026, 09:30". One fixed,
/// English format so they sort and read the same whatever the Mac's language.
final captureTitleFormat = DateFormat("'Capture' d MMM y, HH:mm", 'en');

/// Property names written by the app.
abstract final class P {
  static const name = 'Name';
  static const description = 'Description';
  static const status = 'Status';
  static const captureId = 'Capture ID';
  static const capturedAt = 'Captured at';
  static const timeZone = 'Time zone';
  static const duration = 'Duration (s)';
  static const recording = 'Recording';
  static const itemId = 'Item ID';
  static const kind = 'Kind';
  static const group = 'Group';
  static const capture = 'Capture';
  static const done = 'Done';
  static const due = 'Due';
  static const reminder = 'Reminder';
}

typedef SelectOption = ({String name, String color});

Json _select(List<SelectOption> choices) => {
  'select': {
    'options': [
      for (final o in choices) {'name': o.name, 'color': o.color},
    ],
  },
};

final groupsSchema = <String, Object?>{
  P.name: {'title': <String, Object?>{}},
  P.description: {'rich_text': <String, Object?>{}},
  P.status: _select([
    (name: NotionValues.active, color: 'green'),
    (name: NotionValues.archived, color: 'gray'),
  ]),
};

final capturesSchema = <String, Object?>{
  P.name: {'title': <String, Object?>{}},
  P.captureId: {'rich_text': <String, Object?>{}},
  P.capturedAt: {'date': <String, Object?>{}},
  P.timeZone: {'rich_text': <String, Object?>{}},
  P.duration: {
    'number': {'format': 'number'},
  },
  P.recording: {'files': <String, Object?>{}},
  P.status: _select([
    (name: NotionValues.incomplete, color: 'yellow'),
    (name: NotionValues.saved, color: 'green'),
  ]),
};

Json librarySchema(String groups, String captures) => {
  P.name: {'title': <String, Object?>{}},
  P.itemId: {'rich_text': <String, Object?>{}},
  P.kind: _select([
    (name: NotionValues.note, color: 'blue'),
    (name: NotionValues.task, color: 'orange'),
  ]),
  P.group: {
    'relation': {
      'data_source_id': groups,
      'type': 'single_property',
      'single_property': <String, Object?>{},
    },
  },
  P.capture: {
    'relation': {
      'data_source_id': captures,
      'type': 'dual_property',
      'dual_property': {'synced_property_name': NotionValues.itemsBackLink},
    },
  },
  P.done: {'checkbox': <String, Object?>{}},
  P.due: {'date': <String, Object?>{}},
  P.reminder: {'date': <String, Object?>{}},
};

/// Select option and database names written by the app.
abstract final class NotionValues {
  static const active = 'Active';
  static const archived = 'Archived';
  static const incomplete = 'Incomplete';
  static const saved = 'Saved';
  static const note = 'Note';
  static const task = 'Task';
  static const itemsBackLink = 'Items';
  static const groupsDatabase = 'Groups';
  static const capturesDatabase = 'Captures';
  static const libraryDatabase = 'Library';
}
