import 'dart:io';

import 'package:capture/core/data/system/local_app_directories_datasource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_files_local_datasource.g.dart';

/// Recording files in the captures folder: raw PCM written while recording
/// and the compressed M4A uploaded to Notion.
abstract interface class IAudioFilesLocalDatasource {
  /// Creates the folder and returns where a capture's PCM goes.
  Future<String> pcmPathFor(String captureId);
  String m4aPathFor(String captureId);

  /// Bytes on disk, or 0 when missing.
  int sizeOf(String path);
  Future<List<int>> read(String path);
  Future<void> delete(Iterable<String> paths);
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
  Future<void> delete(Iterable<String> paths) async {
    for (final path in paths) {
      final file = File(path);
      if (file.existsSync()) await file.delete();
    }
  }
}
