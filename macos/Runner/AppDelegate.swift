import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  // A menu-bar (accessory) app: macOS only lets an accessory app's panels
  // and popovers onto another app's full-screen Space, and a window stays on
  // the Space it was created in, so this runs before any window is shown.
  override func applicationWillFinishLaunching(_ notification: Notification) {
    NSApp.setActivationPolicy(.accessory)
    super.applicationWillFinishLaunching(notification)
  }

  // Capture keeps running in the menu bar so the shortcut works with the
  // window closed.
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }

  override func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    if !flag { mainFlutterWindow?.makeKeyAndOrderFront(nil) }
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
