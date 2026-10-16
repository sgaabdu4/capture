import Carbon.HIToolbox
import SwiftUI
import XCTest

@testable import Capture

final class HotKeyTests: XCTestCase {
  private let hotKey = HotKey()
  private var presses = 0

  override func setUp() {
    super.setUp()
    hotKey.onPress = { [unowned self] in presses += 1 }
    XCTAssertTrue(hotKey.register(keyCode: nil, modifiers: UInt32(controlKey | optionKey)))
  }

  override func tearDown() {
    hotKey.unregister()
    super.tearDown()
  }

  private func send(_ type: NSEvent.EventType, _ flags: NSEvent.ModifierFlags) throws {
    let event = try XCTUnwrap(
      NSEvent.keyEvent(
        with: type, location: .zero, modifierFlags: flags, timestamp: 0, windowNumber: 0,
        context: nil, characters: "", charactersIgnoringModifiers: "", isARepeat: false,
        keyCode: 0))
    NSApp.sendEvent(event)
  }

  func testReleasingTheHeldModifiersPresses() throws {
    try send(.flagsChanged, [.control, .option])
    try send(.flagsChanged, [])
    XCTAssertEqual(presses, 1)
  }

  func testAKeyPressedMeanwhileMakesItACombination() throws {
    try send(.flagsChanged, [.control, .option])
    try send(.keyDown, [.control, .option])
    try send(.flagsChanged, [])
    XCTAssertEqual(presses, 0)
  }

  func testExtraModifiersCancelThePress() throws {
    try send(.flagsChanged, [.control, .option])
    try send(.flagsChanged, [.control, .option, .shift])
    try send(.flagsChanged, [])
    XCTAssertEqual(presses, 0)
  }

  func testBouncingPressesCountOnce() throws {
    for _ in 0..<2 {
      try send(.flagsChanged, [.control, .option])
      try send(.flagsChanged, [])
    }
    XCTAssertEqual(presses, 1)
  }

  func testPausingStopsListeningUntilResumed() throws {
    hotKey.paused = true
    try send(.flagsChanged, [.control, .option])
    try send(.flagsChanged, [])
    XCTAssertEqual(presses, 0)
    hotKey.paused = false
    try send(.flagsChanged, [.control, .option])
    try send(.flagsChanged, [])
    XCTAssertEqual(presses, 1)
  }

  func testAKeyShortcutRegistersAndCanBeReplaced() {
    XCTAssertTrue(hotKey.register(keyCode: 122, modifiers: UInt32(cmdKey | shiftKey | controlKey)))
    XCTAssertTrue(hotKey.register(keyCode: 120, modifiers: UInt32(cmdKey | shiftKey | controlKey)))
  }
}

final class ThemeTests: XCTestCase {
  func testHexColoursKeepTheirChannels() throws {
    let colour = try XCTUnwrap(NSColor(Color(hex: 0x336699)).usingColorSpace(.sRGB))
    XCTAssertEqual(colour.redComponent, 0.2, accuracy: 0.001)
    XCTAssertEqual(colour.greenComponent, 0.4, accuracy: 0.001)
    XCTAssertEqual(colour.blueComponent, 0.6, accuracy: 0.001)
  }

  func testFontsRegisterTwiceWithoutTrouble() {
    Theme.registerFonts()
    Theme.registerFonts()
    XCTAssertGreaterThan(fittingSize(Text("Capture").font(Theme.title(20))).width, 0)
    XCTAssertGreaterThan(fittingSize(Text("Capture").font(Theme.hand(20))).width, 0)
  }

  func testFirstClickReachesAnInactivePanel() {
    XCTAssertTrue(ClickThroughHostingView(rootView: EmptyView()).acceptsFirstMouse(for: nil))
  }
}
