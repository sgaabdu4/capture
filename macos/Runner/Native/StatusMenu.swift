import AppKit
import SwiftUI

final class MenuModel: ObservableObject {
  @Published var nextUp = "Nothing scheduled"
  @Published var latest = "No captures yet"
  @Published var shortcut = "⌃⌥R"
  @Published var recording = false
  @Published var canRecord = true

  var onAction: (String) -> Void = { _ in }
}

/// Menu-bar item with the Quick capture popover (reference:
/// docs/design/reference/menu-popover.png, without Weekly summary).
final class StatusMenu: NSObject {
  let model = MenuModel()
  private var item: NSStatusItem?
  private let popover = NSPopover()

  func install() {
    guard item == nil else { return }
    let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    item.button?.image = NSImage(systemSymbolName: "mic", accessibilityDescription: "Capture")
    item.button?.target = self
    item.button?.action = #selector(toggle)
    self.item = item
    popover.behavior = .transient
    popover.contentViewController = NSHostingController(
      rootView: MenuPopoverView(model: model) { [weak self] action in
        self?.popover.performClose(nil)
        self?.model.onAction(action)
      })
  }

  func setRecording(_ recording: Bool) {
    model.recording = recording
    item?.button?.image = NSImage(
      systemSymbolName: recording ? "mic.fill" : "mic", accessibilityDescription: "Capture")
  }

  @objc private func toggle() {
    guard let button = item?.button else { return }
    if popover.isShown {
      popover.performClose(nil)
    } else {
      // The hosting view's size is only known after SwiftUI lays it out;
      // without this the popover keeps a stale height and clips the top.
      if let view = popover.contentViewController?.view {
        view.layoutSubtreeIfNeeded()
        popover.contentSize = view.fittingSize
      }
      popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
      popover.contentViewController?.view.window?.makeKey()
    }
  }
}

struct MenuPopoverView: View {
  @ObservedObject var model: MenuModel
  let act: (String) -> Void

  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Spacer()
        Button { act("settings") } label: {
          Image(systemName: "gearshape").font(.system(size: 17)).foregroundColor(Theme.ink)
        }
        .buttonStyle(.plain)
        .help("Settings")
      }
      Text("Capture").font(Theme.title(46)).foregroundColor(Theme.ink)
      Text("Quick capture").font(Theme.hand(20)).foregroundColor(Theme.ink)
      MicButton(recording: model.recording, enabled: model.canRecord) { act("record") }
        .padding(.top, 18)
      Text(model.recording ? "Click to stop" : "Click to record")
        .font(Theme.hand(19)).foregroundColor(Theme.ink).padding(.top, 10)
      Text("or press \(model.shortcut)").font(Theme.hand(14)).foregroundColor(Theme.muted)
      VStack(spacing: 12) {
        InfoCard(title: "Next up", icon: "calendar", text: model.nextUp) { act("upcoming") }
        InfoCard(title: "Latest", icon: "doc.text", text: model.latest) { act("recordings") }
      }
      .padding(.top, 18)
      Rectangle().fill(Theme.line).frame(height: 1).padding(.top, 16)
      HStack {
        Button { act("open") } label: {
          Label("Open app", systemImage: "arrow.up.forward.square").font(Theme.hand(16))
        }
        Spacer()
        Button { act("quit") } label: { Text("Quit").font(Theme.hand(16)) }
      }
      .buttonStyle(.plain)
      .foregroundColor(Theme.ink)
      .padding(.top, 14)
    }
    .padding(22)
    .frame(width: 380)
    .background(Theme.paper)
  }
}

struct MicButton: View {
  let recording: Bool
  let enabled: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      ZStack {
        Circle().fill(Theme.mic).frame(width: 128, height: 128)
          .shadow(color: .black.opacity(0.18), radius: 8, y: 4)
        if recording {
          RoundedRectangle(cornerRadius: 5).fill(Theme.cream).frame(width: 34, height: 34)
        } else {
          Image(systemName: "mic").font(.system(size: 44, weight: .regular))
            .foregroundColor(Theme.cream)
        }
      }
      .overlay(Rays().stroke(Theme.ray, style: StrokeStyle(lineWidth: 3, lineCap: .round)))
    }
    .buttonStyle(.plain)
    .disabled(!enabled)
    .help(recording ? "Stop recording" : "Record")
  }
}

/// The six short strokes either side of the microphone in the references.
struct Rays: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    let c = CGPoint(x: rect.midX, y: rect.midY)
    let r = rect.width / 2
    for side in [-1.0, 1.0] {
      for angle in [-30.0, 0.0, 30.0] {
        let a = angle * .pi / 180
        let dx = cos(a) * side
        let dy = sin(a)
        path.move(to: CGPoint(x: c.x + dx * (r + 18), y: c.y + dy * (r + 18)))
        path.addLine(to: CGPoint(x: c.x + dx * (r + 34), y: c.y + dy * (r + 34)))
      }
    }
    return path
  }
}

struct InfoCard: View {
  let title: String
  let icon: String
  let text: String
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack {
        VStack(alignment: .leading, spacing: 8) {
          Text(title).font(Theme.hand(19)).foregroundColor(Theme.ink)
          HStack(spacing: 14) {
            Image(systemName: icon).font(.system(size: 19, weight: .light))
            Text(text).font(Theme.hand(16)).foregroundColor(Theme.muted).lineLimit(1)
          }
          .foregroundColor(Theme.ink)
        }
        Spacer()
        Image(systemName: "chevron.right").font(.system(size: 13, weight: .semibold))
          .foregroundColor(Theme.ink)
      }
      .padding(16)
      .background(RoundedRectangle(cornerRadius: 12).fill(Theme.card))
      .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.line))
    }
    .buttonStyle(.plain)
  }
}
