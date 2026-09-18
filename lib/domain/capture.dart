import 'models.dart';

/// Durable milestones of one capture. Each is persisted before the next
/// step starts, so a crash or quit resumes from the last one reached.
enum CaptureStage {
  /// Audio is on disk; nothing else has happened yet.
  recorded,

  /// Local transcript exists.
  transcribed,

  /// A proposal (Jev or manual fallback) is waiting for review.
  proposed,

  /// The user approved; the Notion save may be partial (see [SaveProgress]).
  approved,

  /// Every save step is confirmed.
  saved,

  /// The user said No; nothing was sent to Notion.
  dismissed,
}

/// Which Notion save steps are confirmed. Retries skip confirmed steps and
/// look up by stable IDs before creating anything, so nothing duplicates.
class SaveProgress {
  const SaveProgress({
    this.capturePageId,
    this.itemPages = const {},
    this.audioUploadId,
    this.audioAttached = false,
    this.markedSaved = false,
    this.remindersScheduled = const {},
  });

  factory SaveProgress.fromJson(Map<String, Object?> json) => SaveProgress(
    capturePageId: json['capturePageId'] as String?,
    itemPages: {
      for (final e
          in (json['itemPages'] as Map<String, Object?>? ?? const {}).entries)
        e.key: e.value! as String,
    },
    audioUploadId: json['audioUploadId'] as String?,
    audioAttached: json['audioAttached'] as bool? ?? false,
    markedSaved: json['markedSaved'] as bool? ?? false,
    remindersScheduled: {
      for (final id in json['remindersScheduled'] as List<Object?>? ?? const [])
        id! as String,
    },
  );

  final String? capturePageId;

  /// Proposal item id → Notion Library page id.
  final Map<String, String> itemPages;
  final String? audioUploadId;
  final bool audioAttached;
  final bool markedSaved;
  final Set<String> remindersScheduled;

  SaveProgress copyWith({
    String? capturePageId,
    Map<String, String>? itemPages,
    String? audioUploadId,
    bool? audioAttached,
    bool? markedSaved,
    Set<String>? remindersScheduled,
  }) => SaveProgress(
    capturePageId: capturePageId ?? this.capturePageId,
    itemPages: itemPages ?? this.itemPages,
    audioUploadId: audioUploadId ?? this.audioUploadId,
    audioAttached: audioAttached ?? this.audioAttached,
    markedSaved: markedSaved ?? this.markedSaved,
    remindersScheduled: remindersScheduled ?? this.remindersScheduled,
  );

  Map<String, Object?> toJson() => {
    'capturePageId': capturePageId,
    'itemPages': itemPages,
    'audioUploadId': audioUploadId,
    'audioAttached': audioAttached,
    'markedSaved': markedSaved,
    'remindersScheduled': remindersScheduled.toList(),
  };
}

/// One voice capture and everything derived from it. Stored locally as a
/// draft until saved; audio and transcript never leave the Mac except in the
/// approved Notion save (and transcript text to Jev for analysis).
class CaptureRecord {
  const CaptureRecord({
    required this.id,
    required this.capturedAtUtc,
    required this.timeZone,
    required this.audioPath,
    this.durationSeconds = 0,
    this.stage = CaptureStage.recorded,
    this.transcript,
    this.items = const [],
    this.progress = const SaveProgress(),
    this.error,
    this.m4aPath,
  });

  factory CaptureRecord.fromJson(Map<String, Object?> json) => CaptureRecord(
    id: json['id']! as String,
    capturedAtUtc: DateTime.parse(json['capturedAtUtc']! as String),
    timeZone: json['timeZone']! as String,
    audioPath: json['audioPath']! as String,
    durationSeconds: (json['durationSeconds'] as num?)?.toDouble() ?? 0,
    stage: CaptureStage.values.byName(json['stage']! as String),
    transcript: json['transcript'] as String?,
    items: [
      for (final i in json['items'] as List<Object?>? ?? const [])
        ProposalItem.fromJson(i! as Map<String, Object?>),
    ],
    progress: json['progress'] == null
        ? const SaveProgress()
        : SaveProgress.fromJson(json['progress']! as Map<String, Object?>),
    error: json['error'] as String?,
    m4aPath: json['m4aPath'] as String?,
  );

  final String id;
  final DateTime capturedAtUtc;

  /// IANA zone at capture time; dates in the proposal are resolved in it.
  final String timeZone;

  /// Raw PCM16 16 kHz mono file written while recording.
  final String audioPath;
  final double durationSeconds;
  final CaptureStage stage;
  final String? transcript;
  final List<ProposalItem> items;
  final SaveProgress progress;

  /// Last failure shown to the user; cleared when the step succeeds.
  final String? error;
  final String? m4aPath;

  bool get isOpen =>
      stage != CaptureStage.saved && stage != CaptureStage.dismissed;

  List<ProposalItem> get includedItems => [
    for (final i in items)
      if (i.included) i,
  ];

  CaptureRecord copyWith({
    double? durationSeconds,
    CaptureStage? stage,
    String? transcript,
    List<ProposalItem>? items,
    SaveProgress? progress,
    String? Function()? error,
    String? m4aPath,
  }) => CaptureRecord(
    id: id,
    capturedAtUtc: capturedAtUtc,
    timeZone: timeZone,
    audioPath: audioPath,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    stage: stage ?? this.stage,
    transcript: transcript ?? this.transcript,
    items: items ?? this.items,
    progress: progress ?? this.progress,
    error: error == null ? this.error : error(),
    m4aPath: m4aPath ?? this.m4aPath,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'capturedAtUtc': capturedAtUtc.toIso8601String(),
    'timeZone': timeZone,
    'audioPath': audioPath,
    'durationSeconds': durationSeconds,
    'stage': stage.name,
    'transcript': transcript,
    'items': [for (final i in items) i.toJson()],
    'progress': progress.toJson(),
    'error': error,
    'm4aPath': m4aPath,
  };
}

/// A saved Library entry as mirrored locally for the To-do and Upcoming
/// views (refreshed from Notion; Notion is the source of truth).
class LibraryEntry {
  const LibraryEntry({
    required this.pageId,
    required this.itemId,
    required this.title,
    required this.kind,
    this.groupId,
    this.due,
    this.reminder,
    this.done = false,
    this.captureId,
  });

  factory LibraryEntry.fromJson(Map<String, Object?> json) => LibraryEntry(
    pageId: json['pageId']! as String,
    itemId: json['itemId']! as String,
    title: json['title']! as String,
    kind: ItemKind.values.byName(json['kind']! as String),
    groupId: json['groupId'] as String?,
    due: json['due'] == null
        ? null
        : DueDate.fromJson(json['due']! as Map<String, Object?>),
    reminder: json['reminder'] == null
        ? null
        : DueDate.fromJson(json['reminder']! as Map<String, Object?>),
    done: json['done'] as bool? ?? false,
    captureId: json['captureId'] as String?,
  );

  final String pageId;
  final String itemId;
  final String title;
  final ItemKind kind;
  final String? groupId;
  final DueDate? due;
  final DueDate? reminder;
  final bool done;
  final String? captureId;

  Map<String, Object?> toJson() => {
    'pageId': pageId,
    'itemId': itemId,
    'title': title,
    'kind': kind.name,
    'groupId': groupId,
    'due': due?.toJson(),
    'reminder': reminder?.toJson(),
    'done': done,
    'captureId': captureId,
  };
}
