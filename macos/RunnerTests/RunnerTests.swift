import Carbon.HIToolbox
import Cocoa
import FlutterMacOS
import Sparkle
import XCTest

@testable import Capture

final class FakeMessenger: NSObject, FlutterBinaryMessenger {
  private(set) var sentMethods: [String] = []

  func send(onChannel channel: String, message: Data?) {
    record(message)
  }

  func send(
    onChannel channel: String, message: Data?, binaryReply callback: FlutterBinaryReply? = nil
  ) {
    record(message)
  }

  func setMessageHandlerOnChannel(
    _ channel: String, binaryMessageHandler handler: FlutterBinaryMessageHandler? = nil
  ) -> FlutterBinaryMessengerConnection {
    0
  }

  func cleanUpConnection(_ connection: FlutterBinaryMessengerConnection) {}

  private func record(_ message: Data?) {
    guard let message else { return }
    sentMethods.append(FlutterStandardMethodCodec.sharedInstance().decodeMethodCall(message).method)
  }
}

extension XCTestCase {
  func writePCM(seconds: Double = 0.5) throws -> URL {
    let count = Int(Recorder.sampleRate * seconds)
    let samples = (0..<count).map { Int16(8000 * sin(Double($0) * 0.1)) }
    let url = FileManager.default.temporaryDirectory.appendingPathComponent(
      "\(UUID().uuidString).pcm")
    try samples.withUnsafeBytes { try Data($0).write(to: url) }
    addTeardownBlock { try? FileManager.default.removeItem(at: url) }
    return url
  }
}

final class CaptureNativePluginTests: XCTestCase {
  private let messenger = FakeMessenger()
  private var plugin: CaptureNativePlugin!

  override func setUp() {
    super.setUp()
    plugin = CaptureNativePlugin(
      channel: FlutterMethodChannel(name: "capture_native_test", binaryMessenger: messenger))
  }

  private func reply(_ method: String, _ arguments: Any? = nil) -> Any? {
    var value: Any?
    var answered = false
    plugin.handle(FlutterMethodCall(methodName: method, arguments: arguments)) {
      value = $0
      answered = true
    }
    XCTAssertTrue(answered, "\(method) did not answer")
    return value
  }

  private func asyncReply(_ method: String, _ arguments: Any?) -> Any? {
    let answered = expectation(description: method)
    var value: Any?
    plugin.handle(FlutterMethodCall(methodName: method, arguments: arguments)) {
      value = $0
      answered.fulfill()
    }
    wait(for: [answered], timeout: 30)
    return value
  }

  func testUnknownMethodIsNotImplemented() {
    XCTAssertTrue((reply("nope") as? NSObject) === FlutterMethodNotImplemented)
  }

  func testMicPermissionIsAKnownState() {
    XCTAssertTrue(
      ["granted", "undetermined", "denied"].contains(reply("micPermission") as? String))
  }

  func testShortcutIsRegisteredAndReleased() {
    let args: [String: Any] = [
      "keyCode": 122, "modifiers": cmdKey | shiftKey | optionKey | controlKey, "label": "F1",
    ]
    XCTAssertEqual(reply("setHotKey", args) as? Bool, true)
    XCTAssertNil(reply("pauseHotKey", ["paused": true]))
    XCTAssertNil(reply("pauseHotKey", ["paused": false]))
    XCTAssertEqual(reply("setHotKey", ["modifiers": controlKey | optionKey]) as? Bool, true)
  }

  func testStartRecordingNeedsAPath() {
    XCTAssertEqual((reply("startRecording", [:]) as? FlutterError)?.code, "args")
  }

  func testEncodeNeedsBothPaths() {
    XCTAssertEqual((reply("encodeM4a", ["input": "a"]) as? FlutterError)?.code, "args")
  }

  func testEncodeWritesTheFileAndReportsItsSize() throws {
    let output = FileManager.default.temporaryDirectory.appendingPathComponent(
      "\(UUID().uuidString).m4a")
    addTeardownBlock { try? FileManager.default.removeItem(at: output) }
    let bytes = asyncReply(
      "encodeM4a", ["input": try writePCM().path, "output": output.path, "bitRate": 24000])
    let size = try FileManager.default.attributesOfItem(atPath: output.path)[.size] as? Int
    XCTAssertGreaterThan(size ?? 0, 0)
    XCTAssertEqual(bytes as? Int, size)
  }

  func testEncodeReportsAMissingInput() {
    let error = asyncReply("encodeM4a", ["input": "/no/such.pcm", "output": "/tmp/out.m4a"])
    XCTAssertEqual((error as? FlutterError)?.code, "encode")
  }

  func testOverlayAndMenuCallsAnswerWithNothing() {
    XCTAssertNil(reply("installMenu"))
    XCTAssertNil(reply("showWorking", ["status": "Sorting"]))
    XCTAssertNil(reply("showReview", ["countLine": "1 note", "canApprove": true]))
    XCTAssertNil(reply("hideOverlay"))
    XCTAssertNil(reply("setMenuState", ["nextUp": "Soon", "latest": "Idea", "canRecord": false]))
    XCTAssertNil(reply("showMainWindow"))
  }

  func testDebugBuildsRefuseUpdateChecks() throws {
    let updater = SPUStandardUpdaterController(
      startingUpdater: false, updaterDelegate: nil, userDriverDelegate: nil
    ).updater
    XCTAssertThrowsError(try plugin.updater(updater, mayPerform: .updates)) {
      XCTAssertEqual(($0 as NSError).domain, SUSparkleErrorDomain)
    }
  }

  func testFoundUpdateIsReportedToDart() {
    let updater = SPUStandardUpdaterController(
      startingUpdater: false, updaterDelegate: nil, userDriverDelegate: nil
    ).updater
    plugin.updater(updater, didFindValidUpdate: SUAppcastItem.empty())
    XCTAssertEqual(messenger.sentMethods, ["updateAvailable"])
  }

  func testAppRunsAsAMenuBarApp() throws {
    let delegate = try XCTUnwrap(NSApp.delegate as? AppDelegate)
    XCTAssertEqual(NSApp.activationPolicy(), .accessory)
    XCTAssertFalse(delegate.applicationShouldTerminateAfterLastWindowClosed(NSApp))
    XCTAssertTrue(delegate.applicationShouldHandleReopen(NSApp, hasVisibleWindows: false))
    XCTAssertTrue(delegate.applicationSupportsSecureRestorableState(NSApp))
  }
}
