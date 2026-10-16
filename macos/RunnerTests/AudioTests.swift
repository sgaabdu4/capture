import AVFoundation
import XCTest

@testable import Capture

final class AudioTests: XCTestCase {
  private func outputURL() -> URL {
    let url = FileManager.default.temporaryDirectory.appendingPathComponent(
      "\(UUID().uuidString).m4a")
    addTeardownBlock { try? FileManager.default.removeItem(at: url) }
    return url
  }

  func testEncodedFileIsReadableAndSizedAsReported() throws {
    let output = outputURL()
    let bytes = try M4AEncoder.encode(pcm: try writePCM(), to: output, bitRate: 32000)
    let file = try AVAudioFile(forReading: output)
    XCTAssertEqual(
      bytes, try FileManager.default.attributesOfItem(atPath: output.path)[.size] as? Int)
    XCTAssertEqual(file.fileFormat.sampleRate, Recorder.sampleRate)
    XCTAssertGreaterThan(file.length, 0)
  }

  func testLowerBitRateGivesASmallerFile() throws {
    let pcm = try writePCM(seconds: 2)
    let low = try M4AEncoder.encode(pcm: pcm, to: outputURL(), bitRate: 24000)
    let high = try M4AEncoder.encode(pcm: pcm, to: outputURL(), bitRate: 32000)
    XCTAssertLessThan(low, high)
  }

  func testMissingInputFails() {
    XCTAssertThrowsError(
      try M4AEncoder.encode(
        pcm: URL(fileURLWithPath: "/no/such.pcm"), to: outputURL(), bitRate: 32000))
  }

  func testUnwritableOutputNamesTheStatus() throws {
    let blocked = URL(fileURLWithPath: "/no/such/folder/out.m4a")
    XCTAssertThrowsError(try M4AEncoder.encode(pcm: try writePCM(), to: blocked, bitRate: 32000)) {
      XCTAssertTrue($0.localizedDescription.hasPrefix("Audio encoding failed ("))
    }
  }

  func testRecorderErrorsExplainThemselves() {
    XCTAssertEqual(RecorderError.busy.errorDescription, "A recording is already running.")
    XCTAssertEqual(RecorderError.noInput.errorDescription, "No microphone is available.")
    XCTAssertEqual(
      RecorderError.unsupportedFormat.errorDescription, "The microphone format is not supported.")
  }

  func testIdleRecorderHasRecordedNothing() {
    let recorder = Recorder()
    XCTAssertFalse(recorder.isRecording)
    XCTAssertEqual(recorder.seconds, 0)
    XCTAssertEqual(Recorder.format.channelCount, 1)
    XCTAssertEqual(Recorder.format.sampleRate, 16000)
  }
}
