import AVFoundation
import Flutter
import UIKit
import XCTest

@testable import Runner

final class FakeMessenger: NSObject, FlutterBinaryMessenger {
  private(set) var sentCalls: [FlutterMethodCall] = []
  var sentMethods: [String] { sentCalls.map(\.method) }

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
    sentCalls.append(FlutterStandardMethodCodec.sharedInstance().decodeMethodCall(message))
  }
}

final class FakeRecorder: AudioRecording {
  var onLevel: ((Float) -> Void)?
  var onFailure: ((String) -> Void)?
  var seconds = 0.0
  var failure: Error?
  private(set) var started: URL?

  func start(url: URL) throws {
    if let failure { throw failure }
    started = url
  }

  func stop() -> (URL, Double)? {
    started.map { ($0, seconds) }
  }
}

final class CaptureNativePluginTests: XCTestCase {
  private let messenger = FakeMessenger()
  private let recorder = FakeRecorder()
  private var plugin: CaptureNativePlugin!

  override func setUp() {
    super.setUp()
    plugin = CaptureNativePlugin(
      channel: FlutterMethodChannel(name: "capture_native_test", binaryMessenger: messenger),
      recorder: recorder)
  }

  private func temporaryURL(_ name: String) -> URL {
    let url = FileManager.default.temporaryDirectory.appendingPathComponent(
      "\(UUID().uuidString)-\(name)")
    addTeardownBlock { try? FileManager.default.removeItem(at: url) }
    return url
  }

  private func writePCM(seconds: Double = 0.5) throws -> URL {
    let count = Int(Recorder.sampleRate * seconds)
    let samples = (0..<count).map { Int16(8000 * sin(Double($0) * 0.1)) }
    let url = temporaryURL("tone.pcm")
    try samples.withUnsafeBytes { try Data($0).write(to: url) }
    return url
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
    wait(for: [answered], timeout: 60)
    return value
  }

  func testUnknownMethodIsNotImplemented() {
    XCTAssertTrue((reply("nope") as? NSObject) === FlutterMethodNotImplemented)
  }

  func testMicPermissionIsAKnownState() {
    XCTAssertTrue(
      ["granted", "undetermined", "denied"].contains(reply("micPermission") as? String))
  }

  func testMacOnlyCallsAreAnsweredAndIgnored() {
    XCTAssertEqual(reply("setHotKey") as? Bool, true)
    for method in [
      "installMenu", "pauseHotKey", "showWorking", "showReview", "hideOverlay", "setMenuState",
      "showMainWindow", "checkForUpdates",
    ] {
      XCTAssertNil(reply(method), method)
    }
  }

  func testStartRecordingNeedsAPath() {
    XCTAssertEqual((reply("startRecording", [:]) as? FlutterError)?.code, "args")
  }

  func testEncodeNeedsBothPaths() {
    XCTAssertEqual((reply("encodeM4a", ["input": "a"]) as? FlutterError)?.code, "args")
  }

  func testEncodeWritesTheFileAndReportsItsSize() throws {
    let output = temporaryURL("out.m4a")
    let bytes = asyncReply(
      "encodeM4a", ["input": try writePCM().path, "output": output.path, "bitRate": 24000])
    let size = try FileManager.default.attributesOfItem(atPath: output.path)[.size] as? Int
    XCTAssertGreaterThan(size ?? 0, 0)
    XCTAssertEqual(bytes as? Int, size)
  }

  func testEncodeReportsAMissingInput() {
    let error = asyncReply(
      "encodeM4a", ["input": "/no/such.pcm", "output": temporaryURL("out.m4a").path])
    XCTAssertEqual((error as? FlutterError)?.code, "encode")
  }

  func testTranscribeNeedsBothPaths() {
    XCTAssertEqual((reply("transcribe", ["path": "a"]) as? FlutterError)?.code, "args")
  }

  func testTranscribeReportsAMissingRecording() {
    let error = asyncReply("transcribe", ["path": "/no/such.pcm", "modelDir": "/no/models"])
    XCTAssertEqual((error as? FlutterError)?.code, "transcribe")
  }

  func testTranscribeReportsMissingModels() throws {
    let error = asyncReply(
      "transcribe", ["path": try writePCM().path, "modelDir": temporaryURL("models").path])
    XCTAssertEqual((error as? FlutterError)?.code, "transcribe")
  }

  func testRecordingReportsLevelsAndStopsAtItsLimit() throws {
    let url = temporaryURL("take.pcm")
    recorder.seconds = 0.4
    XCTAssertNil(reply("startRecording", ["path": url.path, "maxSeconds": 0.2]))
    recorder.onLevel?(0.5)
    RunLoop.current.run(until: Date().addingTimeInterval(0.35))
    let stopped = reply("stopRecording") as? [String: Any]
    XCTAssertEqual(stopped?["path"] as? String, url.path)
    XCTAssertEqual(stopped?["seconds"] as? Double, 0.4)
    let levels = messenger.sentCalls.filter { $0.method == "level" }
    let last = try XCTUnwrap(levels.last?.arguments as? [String: Double])
    XCTAssertEqual(try XCTUnwrap(last["level"]), 0.5, accuracy: 0.001)
    XCTAssertEqual(messenger.sentMethods.filter { $0 == "limitReached" }.count, 1)
  }

  func testRecordingThatCannotStartIsReported() {
    recorder.failure = RecorderError.noInput
    let error = reply("startRecording", ["path": temporaryURL("take.pcm").path]) as? FlutterError
    XCTAssertEqual(error?.code, "record")
    XCTAssertEqual(error?.message, "No microphone is available.")
  }

  func testACallTakingTheMicrophoneEndsTheRecording() {
    XCTAssertNil(reply("startRecording", ["path": temporaryURL("take.pcm").path]))
    NotificationCenter.default.post(
      name: AVAudioSession.interruptionNotification, object: nil,
      userInfo: [AVAudioSessionInterruptionTypeKey: AVAudioSession.InterruptionType.began.rawValue])
    XCTAssertEqual(messenger.sentMethods, ["recordingFailed"])
    XCTAssertNotNil(reply("stopRecording"))
  }

  func testRecorderFailuresReachDart() {
    recorder.onFailure?("The microphone changed while recording.")
    XCTAssertEqual(messenger.sentMethods, ["recordingFailed"])
  }

  @MainActor
  func testRecordRequestsReachDartOnceItAsks() async throws {
    XCTAssertEqual(reply("takeRecordRequest") as? Bool, false)
    _ = try await RecordWithCaptureIntent().perform()
    XCTAssertEqual(messenger.sentMethods, ["recordRequested"])
  }

  func testHomeScreenQuickActionStartsARecording() throws {
    let scene = try XCTUnwrap(UIApplication.shared.connectedScenes.first as? UIWindowScene)
    _ = reply("takeRecordRequest")
    var completed: Bool?
    let record = UIApplicationShortcutItem(
      type: CaptureNativePlugin.recordShortcut, localizedTitle: "Record")
    XCTAssertTrue(
      plugin.windowScene(scene, performActionFor: record) { completed = $0 })
    XCTAssertEqual(completed, true)
    XCTAssertEqual(messenger.sentMethods, ["recordRequested"])
    let other = UIApplicationShortcutItem(type: "other", localizedTitle: "Other")
    XCTAssertFalse(plugin.windowScene(scene, performActionFor: other) { _ in })
  }

  func testLaunchWithoutAQuickActionIsIgnored() throws {
    let scene = try XCTUnwrap(UIApplication.shared.connectedScenes.first)
    XCTAssertFalse(plugin.scene(scene, willConnectTo: scene.session, options: nil))
  }
}

@MainActor
final class RecordRequestsTests: XCTestCase {
  func testARequestWaitsUntilDartAsks() {
    let requests = RecordRequests()
    var delivered = 0
    requests.request()
    XCTAssertTrue(requests.take { delivered += 1 })
    XCTAssertEqual(delivered, 0)
    XCTAssertFalse(requests.take { delivered += 1 })
  }

  func testLaterRequestsGoStraightToDart() {
    let requests = RecordRequests()
    var delivered = 0
    XCTAssertFalse(requests.take { delivered += 1 })
    requests.request()
    requests.request()
    XCTAssertEqual(delivered, 2)
  }

  func testShortcutsOfferRecordingWithCapture() {
    XCTAssertEqual(CaptureShortcuts.appShortcuts.count, 1)
  }
}
