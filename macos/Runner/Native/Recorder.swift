import AVFoundation
import Foundation

enum RecorderError: LocalizedError {
  case busy
  case noInput
  case unsupportedFormat

  var errorDescription: String? {
    switch self {
    case .busy: return "A recording is already running."
    case .noInput: return "No microphone is available."
    case .unsupportedFormat: return "The microphone format is not supported."
    }
  }
}

/// Microphone capture to raw PCM16, 16 kHz, mono, little-endian. Every
/// converted buffer is appended to the file as it arrives and the file is
/// flushed to disk about once a second, so audio survives a crash or quit.
final class Recorder {
  static let sampleRate = 16000.0
  static let format = AVAudioFormat(
    commonFormat: .pcmFormatInt16, sampleRate: sampleRate, channels: 1, interleaved: true)!

  /// RMS level of each input buffer (audio thread).
  var onLevel: ((Float) -> Void)?
  /// Input stopped unexpectedly (device change or write failure).
  var onFailure: ((String) -> Void)?

  private let engine = AVAudioEngine()
  private let lock = NSLock()
  private var converter: AVAudioConverter?
  private var handle: FileHandle?
  private var url: URL?
  private var frames: Int64 = 0
  private var lastSync = Date()
  private var observer: NSObjectProtocol?

  var isRecording: Bool { lock.withLock { handle != nil } }
  var seconds: Double { lock.withLock { Double(frames) / Recorder.sampleRate } }

  func start(url: URL) throws {
    guard !isRecording else { throw RecorderError.busy }
    let input = engine.inputNode
    let inFormat = input.outputFormat(forBus: 0)
    guard inFormat.sampleRate > 0, inFormat.channelCount > 0 else { throw RecorderError.noInput }
    guard let converter = AVAudioConverter(from: inFormat, to: Recorder.format) else {
      throw RecorderError.unsupportedFormat
    }
    FileManager.default.createFile(atPath: url.path, contents: nil)
    let handle = try FileHandle(forWritingTo: url)
    lock.withLock {
      self.converter = converter
      self.handle = handle
      self.url = url
      self.frames = 0
    }
    input.installTap(onBus: 0, bufferSize: 4096, format: inFormat) { [weak self] buffer, _ in
      self?.process(buffer)
    }
    observer = NotificationCenter.default.addObserver(
      forName: .AVAudioEngineConfigurationChange, object: engine, queue: .main
    ) { [weak self] _ in
      self?.onFailure?("The microphone changed while recording.")
    }
    engine.prepare()
    do {
      try engine.start()
    } catch {
      input.removeTap(onBus: 0)
      _ = finish()
      throw error
    }
  }

  /// Stops capture and returns the file and its duration in seconds.
  func stop() -> (URL, Double)? {
    engine.inputNode.removeTap(onBus: 0)
    engine.stop()
    if let observer { NotificationCenter.default.removeObserver(observer) }
    observer = nil
    return finish()
  }

  private func finish() -> (URL, Double)? {
    lock.withLock {
      guard let handle, let url else { return nil }
      try? handle.synchronize()
      try? handle.close()
      self.handle = nil
      self.converter = nil
      return (url, Double(frames) / Recorder.sampleRate)
    }
  }

  private func process(_ buffer: AVAudioPCMBuffer) {
    onLevel?(Recorder.rms(buffer))
    lock.lock()
    defer { lock.unlock() }
    guard let converter, let handle else { return }
    let ratio = Recorder.sampleRate / buffer.format.sampleRate
    let capacity = AVAudioFrameCount(Double(buffer.frameLength) * ratio) + 64
    guard let out = AVAudioPCMBuffer(pcmFormat: Recorder.format, frameCapacity: capacity) else {
      return
    }
    var supplied = false
    var error: NSError?
    let status = converter.convert(to: out, error: &error) { _, inputStatus in
      if supplied {
        inputStatus.pointee = .noDataNow
        return nil
      }
      supplied = true
      inputStatus.pointee = .haveData
      return buffer
    }
    guard status != .error, out.frameLength > 0, let samples = out.int16ChannelData?[0] else {
      return
    }
    do {
      try handle.write(contentsOf: Data(bytes: samples, count: Int(out.frameLength) * 2))
      frames += Int64(out.frameLength)
      if Date().timeIntervalSince(lastSync) > 1 {
        try handle.synchronize()
        lastSync = Date()
      }
    } catch {
      let message = error.localizedDescription
      DispatchQueue.main.async { self.onFailure?("Couldn't write audio: \(message)") }
    }
  }

  private static func rms(_ buffer: AVAudioPCMBuffer) -> Float {
    guard let channel = buffer.floatChannelData?[0], buffer.frameLength > 0 else { return 0 }
    let count = Int(buffer.frameLength)
    var sum: Float = 0
    for i in 0..<count { sum += channel[i] * channel[i] }
    return (sum / Float(count)).squareRoot()
  }
}
