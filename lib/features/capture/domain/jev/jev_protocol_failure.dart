enum JevProtocolFailure {
  /// The response, its answers or one answer is not a JSON object.
  notAnObject,

  /// An asked question has no answer.
  missingAnswer,

  /// An answer's type differs from the question's type.
  wrongAnswerType,

  /// A choice answer names an option that was not offered.
  choiceOutsideOptions,

  unknownOption,

  /// A number that must be a probability is missing or outside [0, 1].
  notAProbability,

  /// The state plus one question exceeds the documented request limit.
  transcriptTooLong,
}
