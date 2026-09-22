import AppIntents
import SwiftUI
import WidgetKit

@main
struct CaptureControlsBundle: WidgetBundle {
  var body: some Widget {
    RecordControl()
  }
}

/// The Control Centre and Lock Screen control, also offered for the Action
/// Button. Pressing it runs "Record with Capture" in the app.
struct RecordControl: ControlWidget {
  var body: some ControlWidgetConfiguration {
    StaticControlConfiguration(kind: "com.afenso.capture.record") {
      ControlWidgetButton(action: RecordWithCaptureIntent()) {
        Label("Record with Capture", systemImage: "mic.fill")
      }
    }
    .displayName("Record with Capture")
    .description("Opens Capture and starts recording.")
  }
}
