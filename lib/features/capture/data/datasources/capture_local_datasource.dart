import 'dart:convert';

import 'package:capture/core/data/database/local_database_datasource.dart';
import 'package:capture/features/capture/data/models/capture_record_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqlite3/sqlite3.dart';

part 'capture_local_datasource.g.dart';

/// Capture drafts in the `captures` table.
abstract interface class ICaptureLocalDatasource {
  void put(CaptureRecordModel record);
  CaptureRecordModel? get(String id);

  /// Newest first.
  List<CaptureRecordModel> all();
  void delete(String id);
}

@Riverpod(keepAlive: true)
ICaptureLocalDatasource captureLocalDatasource(Ref ref) =>
    CaptureLocalDatasource(ref.read(localDatabaseProvider));

class CaptureLocalDatasource implements ICaptureLocalDatasource {
  CaptureLocalDatasource(this._db);
  final Database _db;

  @override
  void put(CaptureRecordModel record) => _db.execute(
    'INSERT OR REPLACE INTO captures (id, captured_at, json) VALUES (?, ?, ?)',
    [record.id, record.capturedAtUtc.toIso8601String(), jsonEncode(record.toJson())],
  );

  @override
  CaptureRecordModel? get(String id) =>
      _decode(_db.select('SELECT json FROM captures WHERE id = ?', [id])).firstOrNull;

  @override
  List<CaptureRecordModel> all() =>
      _decode(_db.select('SELECT json FROM captures ORDER BY captured_at DESC'));

  @override
  void delete(String id) => _db.execute('DELETE FROM captures WHERE id = ?', [id]);

  List<CaptureRecordModel> _decode(ResultSet rows) => [
    for (final row in rows)
      if (row case {'json': final String raw})
        if ((jsonDecode(raw) as Object?) case final Map<String, dynamic> json)
          CaptureRecordModel.fromJson(json),
  ];
}
