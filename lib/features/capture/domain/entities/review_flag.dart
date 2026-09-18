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
  classificationFailed,
}

/// Flags a date/time/reminder decision raises.
const dateReviewFlags = {
  ReviewFlag.chooseTime,
  ReviewFlag.chooseAmPm,
  ReviewFlag.chooseDate,
  ReviewFlag.checkDate,
  ReviewFlag.timePassed,
  ReviewFlag.clockChange,
  ReviewFlag.checkReminder,
};

/// Flags a new due date replaces.
const dueReviewFlags = {
  ReviewFlag.chooseDate,
  ReviewFlag.checkDate,
  ReviewFlag.chooseAmPm,
  ReviewFlag.chooseTime,
  ReviewFlag.timePassed,
  ReviewFlag.clockChange,
};
