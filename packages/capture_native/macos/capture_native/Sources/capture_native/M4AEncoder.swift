import AudioToolbox
import Foundation

struct EncoderError: LocalizedError {
  let status: OSStatus
  var errorDescription: String? { "Audio encoding failed (\(status))." }
}

/// Encodes the recorder's raw PCM16 16 kHz mono file to AAC in an M4A
/// container at an explicit bit rate (32 kbps keeps five minutes near
/// 1.2 MB, inside Notion's 5 MiB free-plan upload limit).
enum M4AEncoder {
  static func encode(pcm: URL, to output: URL, bitRate: UInt32) throws -> Int {
    var aac = AudioStreamBasicDescription(
      mSampleRate: Recorder.sampleRate, mFormatID: kAudioFormatMPEG4AAC, mFormatFlags: 0,
      mBytesPerPacket: 0, mFramesPerPacket: 1024, mBytesPerFrame: 0, mChannelsPerFrame: 1,
      mBitsPerChannel: 0, mReserved: 0)
    var fileRef: ExtAudioFileRef?
    try check(
      ExtAudioFileCreateWithURL(
        output as CFURL, kAudioFileM4AType, &aac, nil, AudioFileFlags.eraseFile.rawValue,
        &fileRef))
    guard let file = fileRef else { throw EncoderError(status: -1) }
    var closed = false
    defer { if !closed { ExtAudioFileDispose(file) } }

    var client = AudioStreamBasicDescription(
      mSampleRate: Recorder.sampleRate, mFormatID: kAudioFormatLinearPCM,
      mFormatFlags: kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked,
      mBytesPerPacket: 2, mFramesPerPacket: 1, mBytesPerFrame: 2, mChannelsPerFrame: 1,
      mBitsPerChannel: 16, mReserved: 0)
    try check(
      ExtAudioFileSetProperty(
        file, kExtAudioFileProperty_ClientDataFormat,
        UInt32(MemoryLayout<AudioStreamBasicDescription>.size), &client))
    try setBitRate(file, bitRate)

    let input = try FileHandle(forReadingFrom: pcm)
    defer { try? input.close() }
    while let chunk = try input.read(upToCount: 64 * 1024), chunk.count >= 2 {
      let frames = UInt32(chunk.count / 2)
      try chunk.withUnsafeBytes { raw in
        var list = AudioBufferList(
          mNumberBuffers: 1,
          mBuffers: AudioBuffer(
            mNumberChannels: 1, mDataByteSize: frames * 2,
            mData: UnsafeMutableRawPointer(mutating: raw.baseAddress)))
        try check(ExtAudioFileWrite(file, frames, &list))
      }
    }
    closed = true
    try check(ExtAudioFileDispose(file))
    let attributes = try FileManager.default.attributesOfItem(atPath: output.path)
    return (attributes[.size] as? NSNumber)?.intValue ?? 0
  }

  private static func setBitRate(_ file: ExtAudioFileRef, _ bitRate: UInt32) throws {
    var converter: AudioConverterRef?
    var size = UInt32(MemoryLayout<AudioConverterRef?>.size)
    try check(ExtAudioFileGetProperty(file, kExtAudioFileProperty_AudioConverter, &size, &converter))
    guard let converter else { return }
    var rate = bitRate
    try check(
      AudioConverterSetProperty(
        converter, kAudioConverterEncodeBitRate, UInt32(MemoryLayout<UInt32>.size), &rate))
    // A NULL converter config makes ExtAudioFile apply the new bit rate.
    var config: Unmanaged<CFArray>?
    try check(
      ExtAudioFileSetProperty(
        file, kExtAudioFileProperty_ConverterConfig,
        UInt32(MemoryLayout<Unmanaged<CFArray>?>.size), &config))
  }

  private static func check(_ status: OSStatus) throws {
    if status != noErr { throw EncoderError(status: status) }
  }
}
