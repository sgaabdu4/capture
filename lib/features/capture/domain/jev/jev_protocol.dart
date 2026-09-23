/// TypeSafe `POST /v1/systemone` request/response contract (Jev).
///
/// Verified against docs.typesafe.ai (2026-09): body `{state, model,
/// questions}`; Noul answers `{type:"noul", noul: P(yes)}`; Choice answers
/// `{type:"choice", choice, confidence, probabilities}`; response `{model,
/// answers, usage:{input_tokens, output_tokens}}`. Question keys are not seen
/// by the model, so every instruction names its target unit/thought.
library;

import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/capture/domain/jev/jev_keys.dart';
import 'package:capture/features/capture/domain/jev/jev_protocol_failure.dart';
import 'package:capture/features/capture/domain/jev/jev_result.dart';
import 'package:capture/features/capture/domain/jev/jev_usage.dart';
import 'package:capture/features/capture/domain/values/jev_answer.dart';
import 'package:capture/features/capture/domain/values/jev_model.dart';
import 'package:capture/features/capture/domain/values/jev_question.dart';

export 'package:capture/features/capture/domain/jev/jev_protocol_failure.dart';
export 'package:capture/features/capture/domain/jev/jev_result.dart';
export 'package:capture/features/capture/domain/jev/jev_usage.dart';
export 'package:capture/features/capture/domain/values/jev_answer.dart';
export 'package:capture/features/capture/domain/values/jev_question.dart';

/// The single place the Jev model is configured. Pinned to a documented
/// version (not the moving `jev-latest` alias) so thresholds stay comparable.
const jevModel = 'jev-1.13.0';

Map<String, Object?> buildRequest(
  Object state,
  Map<String, JevQuestion> questions, {
  String model = jevModel,
}) => {
  jevStateField: state,
  jevModelField: model,
  jevQuestionsField: {
    for (final MapEntry(:key, :value) in questions.entries) key: _questionFields(value),
  },
};

Map<String, Object?> _questionFields(JevQuestion question) => switch (question) {
  NoulQuestion(:final instructions, :final yes, :final no) => {
    jevTypeField: jevNoulType,
    jevInstructionsField: instructions,
    if (yes != null || no != null) jevCriteriaField: {jevYesCriterion: yes, jevNoCriterion: no},
  },
  ChoiceQuestion(:final instructions, :final options) => {
    jevTypeField: jevChoiceType,
    jevInstructionsField: instructions,
    jevCriteriaField: options,
  },
};

/// Validates a real response against the questions that were asked: every
/// key present, matching type, numbers in [0, 1], choice among the options.
Result<JevResult, JevProtocolFailure> decodeResponse(Object? json, Map<String, JevQuestion> asked) {
  if (json case {jevAnswersField: final Map<String, Object?> answers}) {
    final decoded = <String, JevAnswer>{};
    for (final MapEntry(:key, value: question) in asked.entries) {
      switch (_decodeAnswer(answers[key], question)) {
        case Ok(:final value):
          decoded[key] = value;
        case Err(:final failure):
          return .err(failure);
      }
    }
    return .ok(.new(_model(json), decoded, _usage(json)));
  }
  return const .err(.notAnObject);
}

JevModel _model(Object? response) => switch (response) {
  {jevModelField: final String model} when model.trim().isNotEmpty => .new(model),
  _ => .new(jevUnknownModel),
};

JevUsage _usage(Object? response) => switch (response) {
  {jevUsageField: final Map<String, Object?> usage} => .new(
    _tokens(usage[jevInputTokensField]),
    _tokens(usage[jevOutputTokensField]),
  ),
  _ => const .new(0, 0),
};

/// Reported token count; an absent or non-numeric count is not billed.
int _tokens(Object? count) => switch (count) {
  final num tokens => tokens.toInt(),
  _ => 0,
};

Result<JevAnswer, JevProtocolFailure> _decodeAnswer(Object? raw, JevQuestion question) =>
    switch (raw) {
      null => const .err(.missingAnswer),
      final Map<String, Object?> answer => _decodeAs(answer, question),
      _ => const .err(.notAnObject),
    };

Result<JevAnswer, JevProtocolFailure> _decodeAs(
  Map<String, Object?> answer,
  JevQuestion question,
) => switch (question) {
  NoulQuestion() => _decodeNoul(answer),
  ChoiceQuestion(:final options) => _decodeChoice(answer, options),
};

Result<JevAnswer, JevProtocolFailure> _decodeNoul(Map<String, Object?> answer) {
  if (answer[jevTypeField] != jevNoulType) return const .err(.wrongAnswerType);
  return switch (_probability(answer[jevNoulField])) {
    final yes? => .ok(NoulAnswer(yes)),
    null => const .err(.notAProbability),
  };
}

Result<JevAnswer, JevProtocolFailure> _decodeChoice(
  Map<String, Object?> answer,
  Map<String, String?> options,
) {
  if (answer[jevTypeField] != jevChoiceType) {
    return const .err(.wrongAnswerType);
  }
  final choice = answer[jevChoiceField];
  if (choice is! String || !options.containsKey(choice)) {
    return const .err(.choiceOutsideOptions);
  }
  final confidence = _probability(answer[jevConfidenceField]);
  if (confidence == null) return const .err(.notAProbability);
  return switch (_probabilities(answer[jevProbabilitiesField], options)) {
    Ok(value: final probabilities) => .ok(ChoiceAnswer(choice, confidence, probabilities)),
    Err(:final failure) => .err(failure),
  };
}

Result<Map<String, double>, JevProtocolFailure> _probabilities(
  Object? raw,
  Map<String, String?> options,
) {
  if (raw is! Map<String, Object?>) return const .ok({});
  final probabilities = <String, double>{};
  for (final MapEntry(:key, :value) in raw.entries) {
    if (!options.containsKey(key)) return const .err(.unknownOption);
    final probability = _probability(value);
    if (probability == null) return const .err(.notAProbability);
    probabilities[key] = probability;
  }
  return .ok(probabilities);
}

/// [value] as a probability, or null when it is not a number in [0, 1].
double? _probability(Object? value) => switch (value) {
  final num p when !p.isNaN && p >= 0 && p <= 1 => p.toDouble(),
  _ => null,
};

/// Conservative token estimate (≈3 characters per token for English text
/// plus JSON overhead).
int estimateTokens(String text) => (text.length / 3).ceil() + 8;

/// Documented limits: 64k tokens for state + all questions; state + longest
/// question ≤ 32k. Batches stay well inside with a safety margin.
const maxRequestTokens = 48000;
const maxStatePlusQuestionTokens = 24000;

/// Splits questions into requests that respect the limits without dropping
/// any question. Each batch repeats the full state (boundary context is never
/// cut). Fails when the state itself is too large to send with a question.
Result<List<Map<String, JevQuestion>>, JevProtocolFailure> batchQuestions(
  String state,
  Map<String, JevQuestion> questions,
) {
  final stateTokens = estimateTokens(state);
  final batches = <Map<String, JevQuestion>>[];
  Map<String, JevQuestion> current = {};
  int questionTokens = 0;
  for (final MapEntry(:key, :value) in questions.entries) {
    final cost = estimateTokens(_questionFields(value).toString());
    if (stateTokens + cost > maxStatePlusQuestionTokens) {
      return const .err(.transcriptTooLong);
    }
    if (current.isNotEmpty && stateTokens + questionTokens + cost > maxRequestTokens) {
      batches.add(current);
      current = {};
      questionTokens = 0;
    }
    current[key] = value;
    questionTokens += cost;
  }
  return .ok([...batches, if (current.isNotEmpty) current]);
}
