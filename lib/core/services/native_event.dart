sealed class NativeEvent {
  const NativeEvent();
}

final class HotkeyPressed extends NativeEvent {
  const HotkeyPressed();
}

final class RecordRequested extends NativeEvent {
  const RecordRequested();
}

final class LevelChanged extends NativeEvent {
  const LevelChanged({required this.level, required this.elapsed});
  final double level;
  final Duration elapsed;
}

/// The stop button on the recording pill.
final class StopRequested extends NativeEvent {
  const StopRequested();
}

/// The recorder hit the capture length limit.
final class LimitReached extends NativeEvent {
  const LimitReached();
}

/// The audio engine stopped unexpectedly (device change, error).
final class RecordingFailed extends NativeEvent {
  const RecordingFailed();
}

/// Sparkle found a release newer than this build.
final class UpdateAvailable extends NativeEvent {
  const UpdateAvailable();
}

final class ReviewCardAction extends NativeEvent {
  const ReviewCardAction(this.action);
  final ReviewAction action;
}

final class MenuCommand extends NativeEvent {
  const MenuCommand(this.action);
  final MenuAction action;
}

/// Buttons on the review card; `later` is the close button.
enum ReviewAction { yes, no, edit, later }

/// Items in the menu-bar popover (Quit is handled natively).
enum MenuAction { record, open, settings, upcoming, recordings }

enum MicPermission { granted, denied, undetermined }
