/// Why the last step of a capture failed. The UI renders fixed copy for
/// each; the step can be retried.
enum CaptureFailure {
  transcription,

  /// Jev could not sort the transcript; the capture became one editable note.
  jevKey,
  jevUnavailable,
  jevResponse,
  audioTooLarge,
  audioMissing,
  notionAuth,
  notionAccess,
  notionBlockLimit,
  notionUnavailable,
  notionRejected,
}
