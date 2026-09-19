import 'package:capture/core/data/database/local_database_datasource.dart';
import 'package:capture/core/data/reminders/reminder_datasource.dart';
import 'package:capture/features/capture/data/datasources/audio_files_local_datasource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqlite3/sqlite3.dart';

part 'local_data_datasource.g.dart';

/// The local database, the recordings folder and scheduled reminders; not
/// the speech model.
abstract interface class ILocalDataDatasource {
  /// Empties every table, deletes every recording and cancels every reminder.
  Future<void> erase();
}

@Riverpod(keepAlive: true)
ILocalDataDatasource localDataDatasource(Ref ref) => LocalDataDatasource(
  ref.read(localDatabaseProvider),
  ref.read(audioFilesLocalDatasourceProvider),
  ref.read(reminderDatasourceProvider),
);

class LocalDataDatasource implements ILocalDataDatasource {
  LocalDataDatasource(this._db, this._audio, this._reminders);
  final Database _db;
  final IAudioFilesLocalDatasource _audio;
  final IReminderDatasource _reminders;

  @override
  Future<void> erase() async {
    clearLocalDatabase(_db);
    _audio.deleteAll();
    await _reminders.cancelAll();
  }
}
