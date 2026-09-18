import Carbon.HIToolbox
import Cocoa

/// One global shortcut: a key with modifiers via Carbon
/// `RegisterEventHotKey`, or modifiers alone via `flagsChanged` monitors.
/// Neither needs Accessibility or Input Monitoring permission. Carbon does
/// not auto-repeat hot keys, and presses closer than 300 ms are ignored so a
/// bouncing key cannot toggle twice.
final class HotKey {
  var onPress: (() -> Void)?

  /// Set while Settings records a new shortcut, so the keys reach it.
  var paused = false {
    didSet {
      guard paused != oldValue, let current else { return }
      if paused {
        unregister()
      } else {
        _ = register(keyCode: current.keyCode, modifiers: current.modifiers)
      }
    }
  }

  private var current: (keyCode: UInt32?, modifiers: UInt32)?

  private var ref: EventHotKeyRef?
  private var handler: EventHandlerRef?
  private var lastPress = Date.distantPast
  private let chord = ModifierChord()

  init() {
    chord.onPress = { [weak self] in self?.pressed() }
  }

  /// `modifiers` uses Carbon flags (cmdKey, shiftKey, optionKey, controlKey);
  /// a nil `keyCode` means the modifiers alone.
  func register(keyCode: UInt32?, modifiers: UInt32) -> Bool {
    unregister()
    current = (keyCode, modifiers)
    if paused { return true }
    guard let keyCode else {
      chord.start(ModifierChord.flags(carbon: modifiers))
      return true
    }
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
    chord.stop()
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

/// Fires when exactly `target` is held and then all modifiers are released
/// within `window`, so holding them for a key combination (⌃⌥←) does not
/// fire. The global monitor sees other apps, the local one Capture itself.
private final class ModifierChord {
  var onPress: (() -> Void)?

  private let window: TimeInterval = 0.6
  private var target: NSEvent.ModifierFlags = []
  private var monitors: [Any] = []
  private var heldSince: Date?

  static func flags(carbon: UInt32) -> NSEvent.ModifierFlags {
    var flags: NSEvent.ModifierFlags = []
    if carbon & UInt32(controlKey) != 0 { flags.insert(.control) }
    if carbon & UInt32(optionKey) != 0 { flags.insert(.option) }
    if carbon & UInt32(shiftKey) != 0 { flags.insert(.shift) }
    if carbon & UInt32(cmdKey) != 0 { flags.insert(.command) }
    return flags
  }

  func start(_ flags: NSEvent.ModifierFlags) {
    stop()
    target = flags
    if let global = NSEvent.addGlobalMonitorForEvents(
      matching: .flagsChanged, handler: { [weak self] in self?.changed($0) })
    {
      monitors.append(global)
    }
    if let local = NSEvent.addLocalMonitorForEvents(
      matching: [.flagsChanged, .keyDown],
      handler: { [weak self] event in
        self?.changed(event)
        return event
      })
    {
      monitors.append(local)
    }
  }

  func stop() {
    monitors.forEach(NSEvent.removeMonitor)
    monitors = []
    heldSince = nil
  }

  private func changed(_ event: NSEvent) {
    // A key pressed while the modifiers are held makes it a combination.
    guard event.type == .flagsChanged else {
      heldSince = nil
      return
    }
    let held = event.modifierFlags.intersection([.control, .option, .shift, .command])
    if held == target {
      heldSince = Date()
    } else if held.isEmpty, let since = heldSince, Date().timeIntervalSince(since) < window {
      heldSince = nil
      onPress?()
    } else if !held.isSubset(of: target) {
      heldSince = nil
    }
  }
}
