import 'dart:io';

import 'package:capture/core/async/in_order.dart';
import 'package:capture/core/data/system/local_app_directories_datasource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_files_local_datasource.g.dart';

/// Recording files in the captures folder: raw PCM while recording, the M4A uploaded to Notion.
abstract interface class IAudioFilesLocalDatasource {
  /// Creates the folder and returns where a capture's PCM goes.
  Future<String> pcmPathFor(String captureId);
  String m4aPathFor(String captureId);

  /// Bytes on disk, or 0 when missing.
  int sizeOf(String path);
  Future<List<int>> read(String path);
  Future<void> delete(Iterable<String> paths);

  /// Removes the captures folder and every recording in it.
  void deleteAll();
}

@Riverpod(keepAlive: true)
IAudioFilesLocalDatasource audioFilesLocalDatasource(Ref ref) =>
    AudioFilesLocalDatasource(ref.read(appDirectoriesProvider).captures);

class AudioFilesLocalDatasource implements IAudioFilesLocalDatasource {
  AudioFilesLocalDatasource(this._dir);
  final String _dir;

  @override
  Future<String> pcmPathFor(String captureId) async {
    await Directory(_dir).create(recursive: true);
    return '$_dir/$captureId.pcm';
  }

  @override
  String m4aPathFor(String captureId) => '$_dir/$captureId.m4a';

  @override
  int sizeOf(String path) {
    final file = File(path);
    return file.existsSync() ? file.lengthSync() : 0;
  }

  @override
  Future<List<int>> read(String path) => File(path).readAsBytes();

  @override
  Future<void> delete(Iterable<String> paths) => inOrder(paths, (path) async {
    final file = File(path);
    if (file.existsSync()) await file.delete();
  }, reason: 'A failed delete stops the rest so the files left on disk stay known.');

  @override
  void deleteAll() {
    final dir = Directory(_dir);
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  }
}
