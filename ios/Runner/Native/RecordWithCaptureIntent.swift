import AppIntents

/// "Record with Capture": the one action behind the Control Centre control,
/// the Action Button, Shortcuts and Siri. It opens the app and starts a
/// recording. Built into the app and the controls extension; it runs in the
/// app, which it opens first.
struct RecordWithCaptureIntent: AppIntent {
  static let title: LocalizedStringResource = "Record with Capture"
  static let description = IntentDescription("Opens Capture and starts recording.")
  static let supportedModes: IntentModes = .foreground

  @MainActor
  func perform() async throws -> some IntentResult {
    RecordRequests.shared.request()
    return .result()
  }
}

/// Record requests from the intent and the Home Screen quick action. Until
/// Dart has asked for the one that launched the app, a request waits here;
/// after that each one goes straight to Dart. Dart ignores a request while
/// a capture is in progress.
@MainActor
final class RecordRequests {
  static let shared = RecordRequests()

  private var pending = false
  private var deliver: (() -> Void)?

  func request() {
    if let deliver { deliver() } else { pending = true }
  }

  /// Whether a request is waiting; later ones go to [deliver].
  func take(deliver: @escaping () -> Void) -> Bool {
    self.deliver = deliver
    defer { pending = false }
    return pending
  }
}
