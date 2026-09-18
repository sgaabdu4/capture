import 'dart:convert';

import 'package:capture/core/data/database/local_database_datasource.dart';
import 'package:capture/features/library/data/models/library_entry_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqlite3/sqlite3.dart';

part 'library_local_datasource.g.dart';

/// Local mirror of the Notion Library in the `library` table.
abstract interface class ILibraryLocalDatasource {
  List<LibraryEntryModel> all();
  void put(LibraryEntryModel entry);
  void remove(String itemId);
  void replaceAll(List<LibraryEntryModel> entries);
}

@Riverpod(keepAlive: true)
ILibraryLocalDatasource libraryLocalDatasource(Ref ref) =>
    LibraryLocalDatasource(ref.read(localDatabaseProvider));

class LibraryLocalDatasource implements ILibraryLocalDatasource {
  LibraryLocalDatasource(this._db);
  final Database _db;

  @override
  List<LibraryEntryModel> all() => [
    for (final row in _db.select('SELECT json FROM library'))
      if (row case {'json': final String raw})
        if ((jsonDecode(raw) as Object?) case final Map<String, dynamic> json)
          LibraryEntryModel.fromJson(json),
  ];

  @override
  void put(LibraryEntryModel entry) => _db.execute(
    'INSERT OR REPLACE INTO library (item_id, json) VALUES (?, ?)',
    [entry.itemId, jsonEncode(entry.toJson())],
  );

  @override
  void remove(String itemId) => _db.execute('DELETE FROM library WHERE item_id = ?', [itemId]);

  @override
  void replaceAll(List<LibraryEntryModel> entries) => _db.transaction(() {
    _db.execute('DELETE FROM library');
    entries.forEach(put);
  });
}
