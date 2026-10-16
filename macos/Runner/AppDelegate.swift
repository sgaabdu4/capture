import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  // Only an accessory app's panels reach full-screen Spaces, and this must run before any window.
  override func applicationWillFinishLaunching(_ notification: Notification) {
    NSApp.setActivationPolicy(.accessory)
    super.applicationWillFinishLaunching(notification)
  }

  // Capture stays in the menu bar so the shortcut works with the window closed.
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }

  override func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool)
    -> Bool
  {
    if !flag { mainFlutterWindow?.makeKeyAndOrderFront(nil) }
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
