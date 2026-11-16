import AppIntents

struct CaptureShortcuts: AppShortcutsProvider {
  static var appShortcuts: [AppShortcut] {
    AppShortcut(
      intent: RecordWithCaptureIntent(),
      phrases: ["Record with \(.applicationName)"],
      shortTitle: "Record with Capture",
      systemImageName: "mic.fill")
  }
}
