/// Why the speech model download stopped. Every case is retryable; the
/// download resumes where it stopped.
enum SpeechModelFailure { network, diskSpace, checksum, unknown }
