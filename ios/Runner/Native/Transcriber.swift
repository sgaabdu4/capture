import FluidAudio
import Foundation
import os

/// Parakeet TDT 0.6B v3 through FluidAudio and Core ML, from the verified
/// local model folder only (no download, no network). The model is loaded
/// for each capture and released afterwards, so an idle app holds none of
/// its memory.
enum Transcriber {
  private static let log = Logger(subsystem: "com.afenso.capture", category: "transcribe")

  static func transcribe(pcm: URL, models directory: URL) async throws -> String {
    let started = ContinuousClock.now
    let samples = try samples(pcm)
    let models = try AsrModels.loadLocal(from: directory, version: .v3, encoderPrecision: .int8)
    let manager = AsrManager(models: models)
    var state = TdtDecoderState.make(decoderLayers: await manager.decoderLayerCount)
    let text: String
    do {
      text = try await manager.transcribe(samples, decoderState: &state).text
    } catch {
      await manager.cleanup()
      throw error
    }
    await manager.cleanup()
    let seconds = Double(samples.count) / Recorder.sampleRate
    log.info(
      "\(seconds, format: .fixed(precision: 1)) s audio in \(ContinuousClock.now - started), peak \(peakFootprintMB()) MB"
    )
    return text
  }

  /// The recorder's PCM16 16 kHz mono file as floats in -1...1.
  private static func samples(_ url: URL) throws -> [Float] {
    let data = try Data(contentsOf: url)
    return data.withUnsafeBytes { raw in
      raw.bindMemory(to: Int16.self).map { Float(Int16(littleEndian: $0)) / 32768 }
    }
  }

  /// The process's peak memory, as Xcode's memory gauge counts it.
  private static func peakFootprintMB() -> Int64 {
    var info = task_vm_info_data_t()
    var count = mach_msg_type_number_t(
      MemoryLayout<task_vm_info_data_t>.size / MemoryLayout<natural_t>.size)
    let status = withUnsafeMutablePointer(to: &info) {
      $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
        task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
      }
    }
    return status == KERN_SUCCESS ? info.ledger_phys_footprint_peak >> 20 : 0
  }
}
