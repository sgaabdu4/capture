import 'package:capture/core/data/database/local_database_datasource.dart';
import 'package:capture/features/capture/data/datasources/audio_files_local_datasource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqlite3/sqlite3.dart';

part 'local_data_datasource.g.dart';

/// The local database and the recordings folder; not the speech model.
abstract interface class ILocalDataDatasource {
  /// Empties every table and deletes every recording.
  void erase();
}

@Riverpod(keepAlive: true)
ILocalDataDatasource localDataDatasource(Ref ref) => LocalDataDatasource(
  ref.read(localDatabaseProvider),
  ref.read(audioFilesLocalDatasourceProvider),
);

class LocalDataDatasource implements ILocalDataDatasource {
  LocalDataDatasource(this._db, this._audio);
  final Database _db;
  final IAudioFilesLocalDatasource _audio;

  @override
  void erase() {
    clearLocalDatabase(_db);
    _audio.deleteAll();
  }
}
