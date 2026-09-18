/// Wire names of the TypeSafe `POST /v1/systemone` contract (Jev) and the
/// question keys this app sends. Keys are part of each request body, so any
/// change here changes what Jev is asked.
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

/// Classification question keys for thought [id]. Jev never sees keys, so
/// each question's instructions name the thought too.
String groupQuestionKey(String id) => '${id}_group';
String taskQuestionKey(String id) => '${id}_task';
String alertQuestionKey(String id) => '${id}_alert';
String recallQuestionKey(String id) => '${id}_recall';
String dayQuestionKey(String id) => '${id}_day';
String timeQuestionKey(String id) => '${id}_time';
