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
