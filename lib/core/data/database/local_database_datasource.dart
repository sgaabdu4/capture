import 'dart:io';

import 'package:capture/core/data/system/local_app_directories_datasource.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqlite3/sqlite3.dart';

part 'local_database_datasource.g.dart';

/// Local SQLite for drafts, pending saves and the Notion cache. Records are
/// JSON documents keyed by id; every write is a single statement, so a
/// crash leaves either the old or the new version.
const localSchema = '''
  PRAGMA journal_mode = WAL;
  CREATE TABLE IF NOT EXISTS captures (
    id TEXT PRIMARY KEY, captured_at TEXT NOT NULL, json TEXT NOT NULL);
  CREATE TABLE IF NOT EXISTS kv (key TEXT PRIMARY KEY, value TEXT NOT NULL);
  CREATE TABLE IF NOT EXISTS library (item_id TEXT PRIMARY KEY, json TEXT NOT NULL);
''';

Database openLocalDatabase(String path) {
  Directory(File(path).parent.path).createSync(recursive: true);
  return sqlite3.open(path)..execute(localSchema);
}

extension DatabaseTransaction on Database {
  /// Runs [body] atomically: commits, or rolls back if anything throws.
  void transaction(VoidCallback body) {
    execute('BEGIN');
    bool committed = false;
    try {
      body();
      execute('COMMIT');
      committed = true;
    } finally {
      if (!committed) execute('ROLLBACK');
    }
  }
}

@Riverpod(keepAlive: true)
Database localDatabase(Ref ref) {
  final db = openLocalDatabase(ref.read(appDirectoriesProvider).database);
  ref.onDispose(db.close);
  return db;
}

/// Small documents in the `kv` table (workspace ids, shortcut, groups).
abstract interface class IKeyValueLocalDatasource {
  String? read(String key);
  void write(String key, String? value);
}

@Riverpod(keepAlive: true)
IKeyValueLocalDatasource keyValueLocalDatasource(Ref ref) =>
    KeyValueLocalDatasource(ref.read(localDatabaseProvider));

class KeyValueLocalDatasource implements IKeyValueLocalDatasource {
  KeyValueLocalDatasource(this._db);
  final Database _db;

  @override
  String? read(String key) {
    for (final row in _db.select('SELECT value FROM kv WHERE key = ?', [key])) {
      if (row case {'value': final String value}) return value;
    }
    return null;
  }

  @override
  void write(String key, String? value) => switch (value) {
    final String v => _db.execute('INSERT OR REPLACE INTO kv (key, value) VALUES (?, ?)', [key, v]),
    null => _db.execute('DELETE FROM kv WHERE key = ?', [key]),
  };
}
