import Carbon.HIToolbox
import Foundation

/// One global shortcut via Carbon `RegisterEventHotKey`. It needs no
/// Accessibility or Input Monitoring permission. Only key-down events are
/// handled; Carbon does not auto-repeat hot keys, and presses closer than
/// 300 ms are ignored so a bouncing key cannot toggle twice.
final class HotKey {
  var onPress: (() -> Void)?

  private var ref: EventHotKeyRef?
  private var handler: EventHandlerRef?
  private var lastPress = Date.distantPast

  /// `modifiers` uses Carbon flags (cmdKey, shiftKey, optionKey, controlKey).
  func register(keyCode: UInt32, modifiers: UInt32) -> Bool {
    unregister()
    guard installHandler() else { return false }
    let id = EventHotKeyID(signature: OSType(0x4350_5452), id: 1)  // "CPTR"
    let status = RegisterEventHotKey(
      keyCode, modifiers, id, GetApplicationEventTarget(), 0, &ref)
    if status != noErr { ref = nil }
    return status == noErr
  }

  func unregister() {
    if let ref { UnregisterEventHotKey(ref) }
    ref = nil
  }

  private func installHandler() -> Bool {
    if handler != nil { return true }
    var spec = EventTypeSpec(
      eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
    let status = InstallEventHandler(
      GetApplicationEventTarget(),
      { _, _, userData in
        guard let userData else { return noErr }
        let hotKey = Unmanaged<HotKey>.fromOpaque(userData).takeUnretainedValue()
        DispatchQueue.main.async { hotKey.pressed() }
        return noErr
      }, 1, &spec, Unmanaged.passUnretained(self).toOpaque(), &handler)
    return status == noErr
  }

  private func pressed() {
    let now = Date()
    guard now.timeIntervalSince(lastPress) > 0.3 else { return }
    lastPress = now
    onPress?()
  }
}
