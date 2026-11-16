import AppIntents

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
