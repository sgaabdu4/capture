import SwiftUI
import XCTest

@testable import Capture

func fittingSize<Content: View>(_ view: Content) -> CGSize {
  let host = NSHostingView(rootView: view)
  host.layoutSubtreeIfNeeded()
  return host.fittingSize
}

final class OverlayTests: XCTestCase {
  private let payload: [String: Any] = [
    "countLine": "2 items", "canApprove": true, "blockedReason": "Pick a group",
    "rows": [
      ["id": "a", "icon": "checkmark.circle", "title": "Call Sam", "detail": "Tomorrow"],
      ["title": "Buy milk"],
    ],
  ]

  func testReviewPayloadReadsTheRows() {
    let review = ReviewPayload(payload)
    XCTAssertEqual(review.countLine, "2 items")
    XCTAssertTrue(review.canApprove)
    XCTAssertEqual(review.blockedReason, "Pick a group")
    XCTAssertEqual(review.rows.map(\.id), ["a", "1"])
    XCTAssertEqual(review.rows[1].icon, "doc.text")
    XCTAssertEqual(review.rows[1].detail, "")
  }

  func testReviewPayloadDefaultsToBlockedAndEmpty() {
    let review = ReviewPayload([:])
    XCTAssertFalse(review.canApprove)
    XCTAssertNil(review.blockedReason)
    XCTAssertTrue(review.rows.isEmpty)
  }

  func testLevelsScrollAndLoudSoundFillsTheBar() {
    let model = OverlayModel()
    model.push(level: 1)
    model.push(level: 0)
    XCTAssertEqual(model.levels.count, 18)
    XCTAssertEqual(model.levels.last, 0)
    XCTAssertEqual(model.levels[16], 1)
  }

  func testTimerShowsMinutesAndSeconds() {
    XCTAssertEqual(RecordingPill.format(0), "0:00")
    XCTAssertEqual(RecordingPill.format(75.9), "1:15")
  }

  func testEveryOverlayModeDrawsItsContent() {
    let model = OverlayModel()
    model.review = ReviewPayload(payload)
    model.status = "Sorting your thoughts"
    var heights: [CGFloat] = []
    for mode in [OverlayModel.Mode.hidden, .recording, .working, .review] {
      model.mode = mode
      heights.append(fittingSize(OverlayView(model: model)).height)
    }
    XCTAssertEqual(heights[0], 36)
    XCTAssertGreaterThan(heights[1], 36)
    XCTAssertGreaterThan(heights[3], heights[2])
  }

  func testReviewCardGrowsWithItsRows() {
    let none = fittingSize(ReviewCard(review: ReviewPayload([:]), onAction: { _ in }))
    let some = fittingSize(ReviewCard(review: ReviewPayload(payload), onAction: { _ in }))
    XCTAssertGreaterThan(some.height, none.height)
  }

  func testPillsAndWaveformDraw() {
    XCTAssertGreaterThan(fittingSize(WorkingPill(status: "Saving")).width, 0)
    XCTAssertGreaterThan(fittingSize(ReviewPill(onClose: {})).width, 0)
    XCTAssertGreaterThan(fittingSize(Waveform(levels: [0, 0.5, 1])).width, 0)
  }

  func testPanelFollowsTheMode() {
    let overlay = OverlayController()
    overlay.show(.working)
    XCTAssertEqual(overlay.model.mode, .working)
    overlay.show(.hidden)
    XCTAssertEqual(overlay.model.mode, .hidden)
  }
}
