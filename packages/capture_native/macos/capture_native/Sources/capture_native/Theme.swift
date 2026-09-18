import AppKit
import CoreText
import SwiftUI

/// Tokens measured from the approved references (docs/design/reference).
/// Keep in sync with `lib/ui/theme.dart`.
enum Theme {
  static let paper = Color(hex: 0xFBF9F3)
  static let card = Color(hex: 0xFDFBF7)
  static let line = Color(hex: 0xE9E4DA)
  static let ink = Color(hex: 0x1A1916)
  static let muted = Color(hex: 0x6E6A63)
  static let ray = Color(hex: 0xD0CAC3)
  static let mic = Color(hex: 0x161714)

  static let charcoal = Color(hex: 0x403B36)
  static let charcoalRow = Color(hex: 0x4A443E)
  static let charcoalButton = Color(hex: 0x524C45)
  static let cream = Color(hex: 0xFBF5ED)
  static let creamMuted = Color(hex: 0xBDB4AA)

  static func title(_ size: CGFloat) -> Font { .custom("Caveat", size: size).weight(.bold) }
  static func hand(_ size: CGFloat) -> Font { .custom("Patrick Hand", size: size) }

  /// Registers the app's bundled OFL fonts (shipped as Flutter assets) for
  /// the native overlay and menu-bar views. Safe to call more than once.
  static func registerFonts() {
    let base = Bundle.main.bundleURL
      .appendingPathComponent("Contents/Frameworks/App.framework/Resources/flutter_assets/assets/fonts")
    for name in ["Caveat.ttf", "PatrickHand-Regular.ttf"] {
      let url = base.appendingPathComponent(name)
      CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }
  }
}

extension Color {
  init(hex: UInt32, alpha: Double = 1) {
    self.init(
      .sRGB,
      red: Double((hex >> 16) & 0xFF) / 255,
      green: Double((hex >> 8) & 0xFF) / 255,
      blue: Double(hex & 0xFF) / 255,
      opacity: alpha)
  }
}

/// Hosting view that reacts to the first click even when the panel is not
/// key, so overlay buttons work without activating Capture.
final class ClickThroughHostingView<Content: View>: NSHostingView<Content> {
  override func acceptsFirstMouse(for event: NSEvent?) -> Bool { true }
}
