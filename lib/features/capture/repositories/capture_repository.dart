import 'package:capture/core/data/system/system_datasource.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/core/services/native_platform_service.dart';
import 'package:capture/features/capture/data/datasources/audio_files_local_datasource.dart';
import 'package:capture/features/capture/data/datasources/capture_local_datasource.dart';
import 'package:capture/features/capture/data/datasources/transcription_datasource.dart';
import 'package:capture/features/capture/domain/audio_chunks.dart';
import 'package:capture/features/capture/domain/entities/capture_failure.dart';
import 'package:capture/features/capture/domain/entities/capture_record.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'capture_repository.g.dart';

typedef CaptureOutcome = Result<CaptureRecord, CaptureFailure>;

/// Capture drafts and their audio files on this Mac.
typedef CaptureStorage = ({ICaptureLocalDatasource records, IAudioFilesLocalDatasource audio});

/// Capture drafts and their audio on this Mac. Every milestone is written
/// before the next step starts.
abstract interface class ICaptureRepository {
  /// Newest first.
  List<CaptureRecord> all();
  CaptureRecord? get(String id);
  void put(CaptureRecord record);

  /// Removes the draft and its audio files.
  Future<void> delete(CaptureRecord record);

  /// A fresh draft whose PCM file the recorder will write.
  Future<CaptureRecord> createDraft();

  /// Local transcript plus the compressed M4A for Notion.
  Future<CaptureOutcome> transcribe(CaptureRecord record);

  /// After a crash mid-recording the PCM file is intact but its duration was
  /// never stored; recover it from the file size, or drop clips shorter than
  /// [minimum].
  void recoverInterrupted({required Duration minimum});
}

class CaptureRepository implements ICaptureRepository {
  CaptureRepository({
    required CaptureStorage storage,
    required this._transcription,
    required this._native,
    required this._system,
  }) : _local = storage.records,
       _files = storage.audio;

  final ICaptureLocalDatasource _local;
  final IAudioFilesLocalDatasource _files;
  final ITranscriptionDatasource _transcription;
  final INativePlatformService _native;
  final ISystemDatasource _system;

  /// PCM16 mono at [sampleRate]: two bytes per sample.
  static const _pcmBytesPerSecond = sampleRate * 2;

  @override
  List<CaptureRecord> all() => [for (final m in _local.all()) m.toEntity()];

  @override
  CaptureRecord? get(String id) => _local.get(id)?.toEntity();

  @override
  void put(CaptureRecord record) => _local.put(.fromEntity(record));

  @override
  Future<void> delete(CaptureRecord record) async {
    final CaptureRecord(:audioPath, :m4aPath, :id) = record;
    await _files.delete([audioPath.value, ?m4aPath]);
    _local.delete(id.value);
  }

  @override
  Future<CaptureRecord> createDraft() async {
    final id = _system.newId();
    final record = CaptureRecord(
      id: .new(id),
      capturedAtUtc: _system.nowUtc(),
      timeZone: .new(await _system.timeZone()),
      audioPath: .new(await _files.pcmPathFor(id)),
    );
    put(record);
    return record;
  }

  @override
  Future<CaptureOutcome> transcribe(CaptureRecord record) async {
    final String transcript;
    try {
      transcript = await _transcription.transcribe(record.audioPath.value);
    } on Exception {
      return const .err(.transcription);
    }
    final next = record.copyWith(
      stage: .transcribed,
      transcript: transcript,
      m4aPath: await _encode(record),
      failure: null,
    );
    put(next);
    return .ok(next);
  }

  /// Null when encoding fails: the capture is then saved without audio.
  Future<String?> _encode(CaptureRecord record) async {
    final out = _files.m4aPathFor(record.id.value);
    try {
      final bytes = await _native.encodeM4a(input: record.audioPath.value, output: out);
      return bytes > 0 ? out : null;
    } on PlatformException {
      return null;
    }
  }

  @override
  void recoverInterrupted({required Duration minimum}) {
    final interrupted = all().where((r) => r.stage == .recorded && r.duration == .zero);
    for (final r in interrupted) {
      final CaptureRecord(:audioPath, :id, :copyWith) = r;
      final duration = Duration(
        milliseconds:
            _files.sizeOf(audioPath.value) * Duration.millisecondsPerSecond ~/ _pcmBytesPerSecond,
      );
      if (duration < minimum) _local.delete(id.value);
      if (duration >= minimum) put(copyWith(duration: duration));
    }
  }
}

@Riverpod(keepAlive: true)
ICaptureRepository captureRepository(Ref ref) => CaptureRepository(
  storage: (
    records: ref.read(captureLocalDatasourceProvider),
    audio: ref.read(audioFilesLocalDatasourceProvider),
  ),
  transcription: ref.read(transcriptionDatasourceProvider),
  native: ref.read(nativePlatformServiceProvider),
  system: ref.read(systemDatasourceProvider),
);
