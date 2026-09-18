/// Durable milestones of one capture. Each is persisted before the next
/// step starts, so a crash or quit resumes from the last one reached.
enum CaptureStage {
  /// Audio is on disk; nothing else has happened yet.
  recorded,

  /// Local transcript exists.
  transcribed,

  /// A proposal (Jev or manual fallback) is waiting for review.
  proposed,

  /// The user approved; the Notion save may be partial (see SaveProgress).
  approved,

  /// Every save step is confirmed.
  saved,

  /// The user said No; nothing was sent to Notion.
  dismissed,
}
