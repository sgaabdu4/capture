import AVFoundation
import Cocoa
import FlutterMacOS
import Sparkle

/// Bridge between the Dart app (which owns all capture state) and the
/// native pieces Flutter can't provide: the global shortcut, microphone
/// capture, the floating overlay, the menu-bar popover, AAC encoding and
/// Sparkle updates.
///
/// Dart → native: methods below. Native → Dart: `hotkey`, `stopRequested`,
/// `limitReached`, `recordingFailed`, `review`, `menu` and `updateAvailable`
/// calls.
public class CaptureNativePlugin: NSObject, FlutterPlugin, SPUUpdaterDelegate {
  private let channel: FlutterMethodChannel
  private let hotKey = HotKey()
  private let recorder = Recorder()
  private let overlay = OverlayController()
  private let menu = StatusMenu()
  private var ticker: Timer?
  private var maxSeconds = 300.0
  private var limitSent = false
  private lazy var updater = SPUStandardUpdaterController(
    startingUpdater: true, updaterDelegate: self, userDriverDelegate: nil)

  init(channel: FlutterMethodChannel) {
    self.channel = channel
    super.init()
    Theme.registerFonts()
    hotKey.onPress = { [weak self] in self?.channel.invokeMethod("hotkey", arguments: nil) }
    overlay.model.onStop = { [weak self] in
      self?.channel.invokeMethod("stopRequested", arguments: nil)
    }
    overlay.model.onReview = { [weak self] action in
      self?.channel.invokeMethod("review", arguments: action)
    }
    menu.model.onAction = { [weak self] action in
      if action == "quit" {
        NSApp.terminate(nil)
        return
      }
      self?.channel.invokeMethod("menu", arguments: action)
    }
    recorder.onLevel = { [weak self] level in
      DispatchQueue.main.async { self?.overlay.model.push(level: level) }
    }
    recorder.onFailure = { [weak self] message in
      self?.channel.invokeMethod("recordingFailed", arguments: message)
    }
    _ = updater
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "capture_native", binaryMessenger: registrar.messenger)
    let instance = CaptureNativePlugin(channel: channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any] ?? [:]
    switch call.method {
    case "installMenu":
      menu.install()
      result(nil)
    case "setHotKey":
      let ok = hotKey.register(
        keyCode: (args["keyCode"] as? Int).map(UInt32.init),
        modifiers: UInt32(args["modifiers"] as? Int ?? 0))
      let label = args["label"] as? String ?? ""
      overlay.model.shortcut = label
      menu.model.shortcut = label
      result(ok)
    case "pauseHotKey":
      hotKey.paused = args["paused"] as? Bool ?? false
      result(nil)
    case "micPermission":
      result(Self.micStatus())
    case "requestMic":
      AVCaptureDevice.requestAccess(for: .audio) { granted in
        DispatchQueue.main.async { result(granted) }
      }
    case "startRecording":
      startRecording(args, result)
    case "stopRecording":
      result(stopRecording())
    case "showWorking":
      overlay.model.status = args["status"] as? String ?? ""
      overlay.show(.working)
      result(nil)
    case "showReview":
      overlay.model.review = ReviewPayload(args)
      overlay.show(.review)
      result(nil)
    case "hideOverlay":
      overlay.show(.hidden)
      result(nil)
    case "setMenuState":
      menu.model.nextUp = args["nextUp"] as? String ?? menu.model.nextUp
      menu.model.latest = args["latest"] as? String ?? menu.model.latest
      menu.model.canRecord = args["canRecord"] as? Bool ?? true
      result(nil)
    case "encodeM4a":
      encode(args, result)
    case "showMainWindow":
      showMainWindow()
      result(nil)
    case "checkForUpdates":
      updater.checkForUpdates(nil)
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func startRecording(_ args: [String: Any], _ result: FlutterResult) {
    guard let path = args["path"] as? String else {
      result(FlutterError(code: "args", message: "path is required", details: nil))
      return
    }
    maxSeconds = args["maxSeconds"] as? Double ?? 300
    limitSent = false
    do {
      try recorder.start(url: URL(fileURLWithPath: path))
    } catch {
      result(FlutterError(code: "record", message: error.localizedDescription, details: nil))
      return
    }
    overlay.model.elapsed = 0
    overlay.model.levels = Array(repeating: 0, count: overlay.model.levels.count)
    overlay.show(.recording)
    menu.setRecording(true)
    ticker = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
      self?.tick()
    }
    result(nil)
  }

  private func tick() {
    let seconds = recorder.seconds
    overlay.model.elapsed = seconds
    if seconds >= maxSeconds && !limitSent {
      limitSent = true
      channel.invokeMethod("limitReached", arguments: nil)
    }
  }

  private func stopRecording() -> [String: Any]? {
    ticker?.invalidate()
    ticker = nil
    menu.setRecording(false)
    guard let (url, seconds) = recorder.stop() else { return nil }
    return ["path": url.path, "seconds": seconds]
  }

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

  private func showMainWindow() {
    NSApp.activate(ignoringOtherApps: true)
    let main = NSApp.windows.first { !($0 is NSPanel) && $0.contentViewController is FlutterViewController }
    main?.makeKeyAndOrderFront(nil)
  }

  private static func micStatus() -> String {
    switch AVCaptureDevice.authorizationStatus(for: .audio) {
    case .authorized: return "granted"
    case .notDetermined: return "undetermined"
    default: return "denied"
    }
  }

  // `flutter run` builds are build 1, so every release would look newer and
  // offer to replace the development app.
  public func updater(_ updater: SPUUpdater, mayPerform updateCheck: SPUUpdateCheck) throws {
    #if DEBUG
    throw NSError(
      domain: SUSparkleErrorDomain, code: Int(SUError.noUpdateError.rawValue),
      userInfo: [NSLocalizedDescriptionKey: "Debug builds do not update."])
    #endif
  }

  public func updater(_ updater: SPUUpdater, didFindValidUpdate item: SUAppcastItem) {
    channel.invokeMethod("updateAvailable", arguments: nil)
  }
}
