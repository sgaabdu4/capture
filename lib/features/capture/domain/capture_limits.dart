/// A capture stops by itself at this length.
const maxCaptureDuration = Duration(minutes: 5);

/// Shorter clips are treated as accidental taps and discarded.
const minCaptureDuration = Duration(milliseconds: 600);
