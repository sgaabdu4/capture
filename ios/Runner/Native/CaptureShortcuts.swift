import AppIntents

/// Offers "Record with Capture" in Shortcuts, Spotlight and Siri, and for
/// the Action Button, with no setup.
struct CaptureShortcuts: AppShortcutsProvider {
  static var appShortcuts: [AppShortcut] {
    AppShortcut(
      intent: RecordWithCaptureIntent(),
      phrases: ["Record with \(.applicationName)"],
      shortTitle: "Record with Capture",
      systemImageName: "mic.fill")
  }
}
