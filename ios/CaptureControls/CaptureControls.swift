import AppIntents
import SwiftUI
import WidgetKit

@main
struct CaptureControlsBundle: WidgetBundle {
  var body: some Widget {
    RecordControl()
  }
}

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
