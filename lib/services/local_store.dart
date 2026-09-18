import 'dart:convert';

import 'package:sqlite3/sqlite3.dart';

import '../domain/capture.dart';
import '../domain/models.dart';

/// Local SQLite for drafts, pending saves and the Notion cache. Records are
/// stored as JSON documents keyed by id; every write is a single statement,
/// so a crash leaves either the old or the new version.
class LocalStore {
  LocalStore(this._db) {
    _db.execute('''
      PRAGMA journal_mode = WAL;
      CREATE TABLE IF NOT EXISTS captures (
        id TEXT PRIMARY KEY, captured_at TEXT NOT NULL, json TEXT NOT NULL);
      CREATE TABLE IF NOT EXISTS kv (key TEXT PRIMARY KEY, value TEXT NOT NULL);
      CREATE TABLE IF NOT EXISTS library (
        item_id TEXT PRIMARY KEY, json TEXT NOT NULL);
    ''');
  }

  factory LocalStore.open(String path) => LocalStore(sqlite3.open(path));
  factory LocalStore.memory() => LocalStore(sqlite3.openInMemory());

  final Database _db;

  void putCapture(CaptureRecord r) => _db.execute(
    'INSERT OR REPLACE INTO captures (id, captured_at, json) VALUES (?, ?, ?)',
    [r.id, r.capturedAtUtc.toIso8601String(), jsonEncode(r.toJson())],
  );

  CaptureRecord? capture(String id) {
    final rows = _db.select('SELECT json FROM captures WHERE id = ?', [id]);
    return rows.isEmpty ? null : _decode(rows.first);
  }

  /// Newest first.
  List<CaptureRecord> captures() => [
    for (final row in _db.select(
      'SELECT json FROM captures ORDER BY captured_at DESC',
    ))
      _decode(row),
  ];

  void deleteCapture(String id) =>
      _db.execute('DELETE FROM captures WHERE id = ?', [id]);

  CaptureRecord _decode(Row row) => CaptureRecord.fromJson(
    jsonDecode(row['json'] as String) as Map<String, Object?>,
  );

  String? get(String key) {
    final rows = _db.select('SELECT value FROM kv WHERE key = ?', [key]);
    return rows.isEmpty ? null : rows.first['value'] as String;
  }

  void set(String key, String? value) => value == null
      ? _db.execute('DELETE FROM kv WHERE key = ?', [key])
      : _db.execute('INSERT OR REPLACE INTO kv (key, value) VALUES (?, ?)', [
          key,
          value,
        ]);

  Map<String, Object?>? getJson(String key) {
    final raw = get(key);
    return raw == null ? null : jsonDecode(raw) as Map<String, Object?>;
  }

  void setJson(String key, Map<String, Object?>? value) =>
      set(key, value == null ? null : jsonEncode(value));

  List<Group> groups() {
    final raw = get('groups');
    if (raw == null) return const [];
    return [
      for (final g in jsonDecode(raw) as List<Object?>)
        Group.fromJson(g! as Map<String, Object?>),
    ];
  }

  void setGroups(List<Group> groups) =>
      set('groups', jsonEncode([for (final g in groups) g.toJson()]));

  void putLibrary(LibraryEntry e) => _db.execute(
    'INSERT OR REPLACE INTO library (item_id, json) VALUES (?, ?)',
    [e.itemId, jsonEncode(e.toJson())],
  );

  void replaceLibrary(List<LibraryEntry> entries) {
    _db.execute('BEGIN');
    try {
      _db.execute('DELETE FROM library');
      entries.forEach(putLibrary);
      _db.execute('COMMIT');
    } catch (_) {
      _db.execute('ROLLBACK');
      rethrow;
    }
  }

  List<LibraryEntry> library() => [
    for (final row in _db.select('SELECT json FROM library'))
      LibraryEntry.fromJson(
        jsonDecode(row['json'] as String) as Map<String, Object?>,
      ),
  ];

  void close() => _db.close();
}
