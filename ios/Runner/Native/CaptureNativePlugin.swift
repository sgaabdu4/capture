import AVFoundation
import Flutter
import UIKit

/// Bridge between the Dart app (which owns all capture state) and what
/// Flutter can't provide on iPhone: microphone capture, AAC encoding, local
/// Parakeet transcription and "Record with Capture" requests. The Mac's
/// shortcut, overlay, menu and updater calls are answered and ignored; the
/// app draws its own pill and review card.
///
/// Dart → native: methods below. Native → Dart: `level`, `limitReached`,
/// `recordingFailed` and `recordRequested` calls.
public class CaptureNativePlugin: NSObject, FlutterPlugin, FlutterSceneLifeCycleDelegate {
  static let recordShortcut = "com.afenso.capture.record"

  private let channel: FlutterMethodChannel
  private let recorder = Recorder()
  private var ticker: Timer?
  private var maxSeconds = 300.0
  private var limitSent = false
  private var level: Float = 0
  private var interruption: NSObjectProtocol?

  init(channel: FlutterMethodChannel) {
    self.channel = channel
    super.init()
    recorder.onLevel = { [weak self] level in
      DispatchQueue.main.async { self?.level = level }
    }
    recorder.onFailure = { [weak self] message in
      self?.channel.invokeMethod("recordingFailed", arguments: message)
    }
    Self.excludeModelsFromBackup()
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "capture_native", binaryMessenger: registrar.messenger())
    let instance = CaptureNativePlugin(channel: channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.addSceneDelegate(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any] ?? [:]
    switch call.method {
    case "micPermission":
      result(Self.micStatus())
    case "requestMic":
      AVAudioApplication.requestRecordPermission { granted in
        DispatchQueue.main.async { result(granted) }
      }
    case "startRecording":
      startRecording(args, result)
    case "stopRecording":
      result(stopRecording())
    case "encodeM4a":
      encode(args, result)
    case "transcribe":
      transcribe(args, result)
    case "takeRecordRequest":
      // Flutter calls plugins on the main thread.
      result(MainActor.assumeIsolated {
        RecordRequests.shared.take { [weak self] in
          self?.channel.invokeMethod("recordRequested", arguments: nil)
        }
      })
    case "setHotKey":
      result(true)
    case "installMenu", "pauseHotKey", "showWorking", "showReview", "hideOverlay", "setMenuState",
      "showMainWindow", "checkForUpdates":
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: Home Screen quick action

  public func scene(
    _ scene: UIScene, willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions?
  ) -> Bool {
    guard connectionOptions?.shortcutItem?.type == Self.recordShortcut else { return false }
    MainActor.assumeIsolated { RecordRequests.shared.request() }
    return true
  }

  public func windowScene(
    _ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem,
    completionHandler: @escaping (Bool) -> Void
  ) -> Bool {
    guard shortcutItem.type == Self.recordShortcut else { return false }
    MainActor.assumeIsolated { RecordRequests.shared.request() }
    completionHandler(true)
    return true
  }

  // MARK: Recording

  private func startRecording(_ args: [String: Any], _ result: FlutterResult) {
    guard let path = args["path"] as? String else {
      result(FlutterError(code: "args", message: "path is required", details: nil))
      return
    }
    maxSeconds = args["maxSeconds"] as? Double ?? 300
    limitSent = false
    level = 0
    do {
      // Recording continues while the screen is locked (audio background mode).
      let session = AVAudioSession.sharedInstance()
      try session.setCategory(.record, mode: .default)
      try session.setActive(true)
      try recorder.start(url: URL(fileURLWithPath: path))
    } catch {
      try? AVAudioSession.sharedInstance().setActive(false)
      result(FlutterError(code: "record", message: error.localizedDescription, details: nil))
      return
    }
    // A call or Siri takes the microphone: stop and keep what was recorded.
    interruption = NotificationCenter.default.addObserver(
      forName: AVAudioSession.interruptionNotification, object: nil, queue: .main
    ) { [weak self] note in
      let type = note.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt
      guard type == AVAudioSession.InterruptionType.began.rawValue else { return }
      self?.channel.invokeMethod("recordingFailed", arguments: "The recording was interrupted.")
    }
    ticker = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
      self?.tick()
    }
    result(nil)
  }

  private func tick() {
    let seconds = recorder.seconds
    channel.invokeMethod("level", arguments: ["level": Double(level), "seconds": seconds])
    if seconds >= maxSeconds && !limitSent {
      limitSent = true
      channel.invokeMethod("limitReached", arguments: nil)
    }
  }

  private func stopRecording() -> [String: Any]? {
    ticker?.invalidate()
    ticker = nil
    if let interruption { NotificationCenter.default.removeObserver(interruption) }
    interruption = nil
    let stopped = recorder.stop()
    try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    guard let (url, seconds) = stopped else { return nil }
    return ["path": url.path, "seconds": seconds]
  }

  // MARK: Encoding and transcription

  private func encode(_ args: [String: Any], _ result: @escaping FlutterResult) {
    guard let input = args["input"] as? String, let output = args["output"] as? String else {
      result(FlutterError(code: "args", message: "input and output are required", details: nil))
      return
    }
    let bitRate = UInt32(args["bitRate"] as? Int ?? 32000)
    DispatchQueue.global(qos: .userInitiated).async {
      do {
        let bytes = try M4AEncoder.encode(
          pcm: URL(fileURLWithPath: input), to: URL(fileURLWithPath: output), bitRate: bitRate)
        DispatchQueue.main.async { result(bytes) }
      } catch {
        DispatchQueue.main.async {
          result(FlutterError(code: "encode", message: error.localizedDescription, details: nil))
        }
      }
    }
  }

  private func transcribe(_ args: [String: Any], _ result: @escaping FlutterResult) {
    guard let path = args["path"] as? String, let modelDir = args["modelDir"] as? String else {
      result(FlutterError(code: "args", message: "path and modelDir are required", details: nil))
      return
    }
    Task.detached(priority: .userInitiated) {
      do {
        let text = try await Transcriber.transcribe(
          pcm: URL(fileURLWithPath: path), models: URL(fileURLWithPath: modelDir, isDirectory: true))
        await MainActor.run { result(text) }
      } catch {
        await MainActor.run {
          result(FlutterError(code: "transcribe", message: error.localizedDescription, details: nil))
        }
      }
    }
  }

  // MARK: Helpers

  /// The 480 MB speech model can be downloaded again, so it stays out of
  /// iCloud backups.
  private static func excludeModelsFromBackup() {
    guard
      let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        .first
    else { return }
    var models = support.appendingPathComponent("com.afenso.capture/models", isDirectory: true)
    try? FileManager.default.createDirectory(at: models, withIntermediateDirectories: true)
    var values = URLResourceValues()
    values.isExcludedFromBackup = true
    try? models.setResourceValues(values)
  }

  private static func micStatus() -> String {
    switch AVAudioApplication.shared.recordPermission {
    case .granted: return "granted"
    case .undetermined: return "undetermined"
    default: return "denied"
    }
  }
}
