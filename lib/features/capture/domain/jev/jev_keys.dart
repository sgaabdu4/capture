library;

/// Request fields.
const jevStateField = 'state';
const jevModelField = 'model';
const jevQuestionsField = 'questions';

/// Question fields.
const jevTypeField = 'type';
const jevInstructionsField = 'instructions';
const jevCriteriaField = 'criteria';

/// Question and answer types.
const jevNoulType = 'noul';
const jevChoiceType = 'choice';

/// Criteria names describing a Noul question's yes and no answers.
const jevYesCriterion = 'true';
const jevNoCriterion = 'false';

/// Response fields.
const jevAnswersField = 'answers';
const jevUsageField = 'usage';
const jevInputTokensField = 'input_tokens';
const jevOutputTokensField = 'output_tokens';

/// Answer fields.
const jevNoulField = 'noul';
const jevChoiceField = 'choice';
const jevConfidenceField = 'confidence';
const jevProbabilitiesField = 'probabilities';

/// Model name reported when a response omits it.
const jevUnknownModel = 'unknown';

String groupQuestionKey(String id) => '${id}_group';
String taskQuestionKey(String id) => '${id}_task';
String alertQuestionKey(String id) => '${id}_alert';
String recallQuestionKey(String id) => '${id}_recall';
String dayQuestionKey(String id) => '${id}_day';
String timeQuestionKey(String id) => '${id}_time';
