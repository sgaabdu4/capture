/// Template review reasons. The app never generates clarification prose;
/// the UI renders each flag with fixed localized copy.
enum ReviewFlag {
  checkSplit,
  checkGroup,
  checkTask,
  checkReminder,
  chooseTime,
  chooseAmPm,
  chooseDate,
  checkDate,
  timePassed,
  clockChange,
  correctionElsewhere,
  recallUnsupported,
  newPiece,
  classificationFailed;

  /// Flags a date/time/reminder decision raises.
  static const dateFlags = {
    chooseTime,
    chooseAmPm,
    chooseDate,
    checkDate,
    timePassed,
    clockChange,
    checkReminder,
  };

  /// Flags a new due date replaces.
  static const dueFlags = {chooseDate, checkDate, chooseAmPm, chooseTime, timePassed, clockChange};
}
