import AppKit
import SwiftUI

struct ReviewRow: Identifiable {
  let id: String
  let icon: String
  let title: String
  let detail: String
}

struct ReviewPayload {
  let countLine: String
  let rows: [ReviewRow]
  let canApprove: Bool
  let blockedReason: String?

  init(_ map: [String: Any]) {
    countLine = map["countLine"] as? String ?? ""
    canApprove = map["canApprove"] as? Bool ?? false
    blockedReason = map["blockedReason"] as? String
    rows = (map["rows"] as? [[String: Any]] ?? []).enumerated().map { index, row in
      ReviewRow(
        id: row["id"] as? String ?? "\(index)",
        icon: row["icon"] as? String ?? "doc.text",
        title: row["title"] as? String ?? "",
        detail: row["detail"] as? String ?? "")
    }
  }
}

final class OverlayModel: ObservableObject {
  enum Mode { case hidden, recording, working, review }

  @Published var mode: Mode = .hidden
  @Published var levels: [CGFloat] = Array(repeating: 0, count: 18)
  @Published var elapsed: TimeInterval = 0
  @Published var shortcut = "⌃⌥R"
  @Published var status = ""
  @Published var review: ReviewPayload?

  var onStop: () -> Void = {}
  var onReview: (String) -> Void = { _ in }

  func push(level: Float) {
    // Map RMS (≈0.001–0.3) onto 0…1 with a log curve so speech is visible.
    let db = 20 * log10(max(level, 0.0001))
    let value = CGFloat(min(max((db + 50) / 40, 0), 1))
    levels.removeFirst()
    levels.append(value)
  }
}

/// Non-activating floating panel, bottom-centre of the display under the
/// pointer, clear of the Dock. It never becomes key, so typing or pressing
/// Enter in another app can't trigger its buttons.
final class OverlayController {
  let model = OverlayModel()
  private lazy var panel: NSPanel = makePanel()
  private lazy var host = ClickThroughHostingView(rootView: OverlayView(model: model))

  func show(_ mode: OverlayModel.Mode) {
    model.mode = mode
    if mode == .hidden {
      panel.orderOut(nil)
      return
    }
    layout()
    panel.orderFrontRegardless()
  }

  func layout() {
    host.layoutSubtreeIfNeeded()
    let size = host.fittingSize
    let screen = NSScreen.screens.first { $0.frame.contains(NSEvent.mouseLocation) } ?? NSScreen.main
    guard let visible = screen?.visibleFrame else { return }
    let origin = NSPoint(x: visible.midX - size.width / 2, y: visible.minY + 20)
    panel.setFrame(NSRect(origin: origin, size: size), display: true)
  }

  private func makePanel() -> NSPanel {
    let panel = NSPanel(
      contentRect: NSRect(x: 0, y: 0, width: 420, height: 120),
      styleMask: [.nonactivatingPanel, .borderless], backing: .buffered, defer: true)
    panel.isFloatingPanel = true
    panel.level = .statusBar
    panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
    panel.backgroundColor = .clear
    panel.isOpaque = false
    panel.hasShadow = false
    panel.hidesOnDeactivate = false
    panel.becomesKeyOnlyIfNeeded = true
    panel.contentView = host
    return panel
  }
}

struct OverlayView: View {
  @ObservedObject var model: OverlayModel

  var body: some View {
    VStack(spacing: 14) {
      if model.mode == .review, let review = model.review {
        ReviewCard(review: review, onAction: model.onReview)
      }
      switch model.mode {
      case .recording: RecordingPill(model: model)
      case .working: WorkingPill(status: model.status)
      case .review: ReviewPill { model.onReview("later") }
      case .hidden: EmptyView()
      }
    }
    .padding(18)
    .fixedSize()
  }
}

private struct PillBackground: ViewModifier {
  func body(content: Content) -> some View {
    content
      .background(Capsule().fill(Theme.charcoal.opacity(0.96)))
      .shadow(color: .black.opacity(0.25), radius: 10, y: 4)
  }
}

struct RecordingPill: View {
  @ObservedObject var model: OverlayModel

  var body: some View {
    VStack(spacing: 8) {
      HStack(spacing: 16) {
        Image(systemName: "mic")
          .font(.system(size: 15, weight: .medium))
          .foregroundColor(Theme.cream)
          .frame(width: 34, height: 34)
          .background(Circle().fill(Color.white.opacity(0.08)))
        Waveform(levels: model.levels)
          .frame(width: 118, height: 26)
        Text(Self.format(model.elapsed))
          .font(.system(size: 15, weight: .medium).monospacedDigit())
          .foregroundColor(Theme.cream)
        Button(action: model.onStop) {
          ZStack {
            Circle().fill(Theme.cream)
            RoundedRectangle(cornerRadius: 2).fill(Theme.charcoal).frame(width: 11, height: 11)
          }
          .frame(width: 30, height: 30)
        }
        .buttonStyle(.plain)
        .help("Stop recording")
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 9)
      .modifier(PillBackground())
      Text("\(model.shortcut) to stop")
        .font(Theme.hand(15))
        .foregroundColor(Theme.muted)
        .padding(.horizontal, 10)
        .padding(.vertical, 2)
        .background(Capsule().fill(Theme.paper.opacity(0.75)))
    }
  }

  static func format(_ seconds: TimeInterval) -> String {
    let s = Int(seconds)
    return String(format: "%d:%02d", s / 60, s % 60)
  }
}

struct Waveform: View {
  let levels: [CGFloat]

  var body: some View {
    HStack(alignment: .center, spacing: 3) {
      ForEach(levels.indices, id: \.self) { i in
        Capsule()
          .fill(Theme.cream.opacity(levels[i] > 0.05 ? 1 : 0.55))
          .frame(width: 3.5, height: max(4, levels[i] * 26))
      }
    }
    .animation(.linear(duration: 0.08), value: levels)
  }
}

struct WorkingPill: View {
  let status: String

  var body: some View {
    HStack(spacing: 12) {
      ProgressView().controlSize(.small).colorScheme(.dark)
      Text(status)
        .font(Theme.hand(17))
        .foregroundColor(Theme.cream)
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 12)
    .modifier(PillBackground())
  }
}

/// Idle pill under the review card: no live waveform (the mic is off).
struct ReviewPill: View {
  let onClose: () -> Void

  var body: some View {
    HStack(spacing: 14) {
      Circle().fill(Theme.creamMuted).frame(width: 7, height: 7)
      Text("Not saved yet")
        .font(Theme.hand(15))
        .foregroundColor(Theme.creamMuted)
      Button(action: onClose) {
        Image(systemName: "xmark")
          .font(.system(size: 9, weight: .bold))
          .foregroundColor(Theme.cream)
          .frame(width: 22, height: 22)
          .background(Circle().fill(Theme.charcoalButton))
      }
      .buttonStyle(.plain)
      .help("Review later")
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 8)
    .modifier(PillBackground())
  }
}

struct ReviewCard: View {
  let review: ReviewPayload
  let onAction: (String) -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 2) {
          Text("Ready to save?").font(Theme.title(34)).foregroundColor(Theme.cream)
          Text("Here's what I understood").font(Theme.hand(17)).foregroundColor(Theme.creamMuted)
          if !review.countLine.isEmpty {
            Text(review.countLine).font(Theme.hand(14)).foregroundColor(Theme.creamMuted)
              .padding(.top, 2)
          }
        }
        Spacer()
        Button { onAction("later") } label: {
          Image(systemName: "xmark").font(.system(size: 13, weight: .regular))
            .foregroundColor(Theme.creamMuted).frame(width: 24, height: 24)
        }
        .buttonStyle(.plain)
        .help("Review later")
      }
      .padding(.bottom, 14)

      ScrollView {
        VStack(spacing: 8) {
          ForEach(review.rows) { row in ReviewRowView(row: row) }
        }
      }
      .frame(maxHeight: min(CGFloat(review.rows.count) * 74, 300))

      if let reason = review.blockedReason {
        Text(reason).font(Theme.hand(14)).foregroundColor(Theme.cream).padding(.top, 10)
      }
      Rectangle().fill(Color.black.opacity(0.18)).frame(height: 1).padding(.vertical, 14)
      HStack(spacing: 14) {
        Button { onAction("no") } label: {
          Text("No").font(Theme.hand(18)).foregroundColor(Theme.cream)
            .frame(width: 92, height: 46)
            .background(RoundedRectangle(cornerRadius: 12).fill(Theme.charcoalButton))
        }
        .buttonStyle(.plain)
        Button { onAction("yes") } label: {
          Text("Yes, save").font(Theme.hand(18)).foregroundColor(Theme.ink)
            .frame(width: 150, height: 46)
            .background(RoundedRectangle(cornerRadius: 12).fill(Theme.cream))
        }
        .buttonStyle(.plain)
        .disabled(!review.canApprove)
        .opacity(review.canApprove ? 1 : 0.45)
        Button { onAction("edit") } label: {
          Text("Edit").font(Theme.hand(18)).foregroundColor(Theme.cream)
            .frame(width: 70, height: 46)
        }
        .buttonStyle(.plain)
      }
    }
    .padding(22)
    .frame(width: 400)
    .background(RoundedRectangle(cornerRadius: 16).fill(Theme.charcoal.opacity(0.97)))
    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.06)))
    .shadow(color: .black.opacity(0.28), radius: 18, y: 8)
  }
}

struct ReviewRowView: View {
  let row: ReviewRow

  var body: some View {
    HStack(spacing: 18) {
      Image(systemName: row.icon)
        .font(.system(size: 21, weight: .light))
        .foregroundColor(Theme.cream)
        .frame(width: 30)
      VStack(alignment: .leading, spacing: 2) {
        Text(row.title).font(Theme.hand(18)).foregroundColor(Theme.cream).lineLimit(2)
        if !row.detail.isEmpty {
          Text(row.detail).font(Theme.hand(15)).foregroundColor(Theme.creamMuted).lineLimit(1)
        }
      }
      Spacer(minLength: 0)
    }
    .padding(.horizontal, 18)
    .padding(.vertical, 12)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(RoundedRectangle(cornerRadius: 10).fill(Theme.charcoalRow))
  }
}
