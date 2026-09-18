import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)
    CaptureNativePlugin.register(
      with: flutterViewController.registrar(forPlugin: "CaptureNativePlugin"))
    self.isReleasedWhenClosed = false
    self.title = "Capture"
    self.titlebarAppearsTransparent = true
    self.titleVisibility = .hidden
    self.styleMask.insert(.fullSizeContentView)
    // Down to a phone-sized window; the layout switches to a bottom bar.
    self.minSize = NSSize(width: 320, height: 480)
    self.setContentSize(NSSize(width: 1240, height: 860))
    self.center()

    super.awakeFromNib()
  }
}
