import SwiftUI
import XCTest

@testable import Capture

final class MenuTests: XCTestCase {
  func testMenuStartsEmptyAndIdle() {
    let model = MenuModel()
    XCTAssertEqual(model.nextUp, "Nothing scheduled")
    XCTAssertEqual(model.latest, "No captures yet")
    XCTAssertFalse(model.recording)
    XCTAssertTrue(model.canRecord)
  }

  func testStatusItemIsInstalledOnce() {
    let menu = StatusMenu()
    menu.install()
    menu.install()
    menu.setRecording(true)
    XCTAssertTrue(menu.model.recording)
    menu.setRecording(false)
    XCTAssertFalse(menu.model.recording)
  }

  func testPopoverDrawsIdleAndRecording() {
    let model = MenuModel()
    let idle = fittingSize(MenuPopoverView(model: model, act: { _ in }))
    model.recording = true
    model.canRecord = false
    let recording = fittingSize(MenuPopoverView(model: model, act: { _ in }))
    XCTAssertEqual(idle.width, 380)
    XCTAssertEqual(recording.width, 380)
  }

  func testRaysSitOutsideTheButton() {
    let rect = CGRect(x: 0, y: 0, width: 128, height: 128)
    let bounds = Rays().path(in: rect).boundingRect
    XCTAssertFalse(Rays().path(in: rect).isEmpty)
    XCTAssertGreaterThan(bounds.width, rect.width)
  }

  func testButtonsAndCardsDraw() {
    XCTAssertEqual(fittingSize(MicButton(recording: true, enabled: true, action: {})).width, 128)
    XCTAssertGreaterThan(
      fittingSize(InfoCard(title: "Next up", icon: "calendar", text: "Soon", action: {})).width, 0)
  }
}
