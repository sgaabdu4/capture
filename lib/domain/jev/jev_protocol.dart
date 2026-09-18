/// TypeSafe `POST /v1/systemone` request/response contract (Jev).
///
/// Verified against docs.typesafe.ai (2026-09): body `{state, model,
/// questions}`; Noul answers `{type:"noul", noul: P(yes)}`; Choice answers
/// `{type:"choice", choice, confidence, probabilities}`; response `{model,
/// answers, usage:{input_tokens, output_tokens}}`. Question keys are not seen
/// by the model, so every instruction names its target unit/thought.
library;

/// The single place the Jev model is configured. Pinned to a documented
/// version (not the moving `jev-latest` alias) so thresholds stay comparable.
const jevModel = 'jev-1.13.0';

sealed class JevQuestion {
  const JevQuestion(this.instructions);
  final String instructions;
  Map<String, Object?> toJson();
}

class NoulQuestion extends JevQuestion {
  const NoulQuestion(super.instructions, {this.yes, this.no});
  final String? yes;
  final String? no;

  @override
  Map<String, Object?> toJson() => {
    'type': 'noul',
    'instructions': instructions,
    if (yes != null || no != null) 'criteria': {'true': yes, 'false': no},
  };
}

class ChoiceQuestion extends JevQuestion {
  ChoiceQuestion(super.instructions, this.options)
    : assert(options.length >= 2 && options.length <= 255);

  /// Option name → meaningful description (both are seen by the model).
  final Map<String, String?> options;

  @override
  Map<String, Object?> toJson() => {
    'type': 'choice',
    'instructions': instructions,
    'criteria': options,
  };
}

sealed class JevAnswer {
  const JevAnswer();
}

class NoulAnswer extends JevAnswer {
  const NoulAnswer(this.yes);

  /// Probability that the answer is yes. Not a boolean, not a confidence.
  final double yes;
}

class ChoiceAnswer extends JevAnswer {
  const ChoiceAnswer(this.choice, this.confidence, this.probabilities);
  final String choice;

  /// Peakedness statistic of the distribution; distinct from
  /// `probabilities[choice]`. Neither is a guarantee of accuracy.
  final double confidence;
  final Map<String, double> probabilities;
}

class JevUsage {
  const JevUsage(this.inputTokens, this.outputTokens);
  final int inputTokens;
  final int outputTokens;
}

class JevResult {
  const JevResult(this.model, this.answers, this.usage);
  final String model;
  final Map<String, JevAnswer> answers;
  final JevUsage usage;
}

class JevDecodeException implements Exception {
  const JevDecodeException(this.message);
  final String message;
  @override
  String toString() => 'JevDecodeException: $message';
}

Map<String, Object?> buildRequest(
  Object state,
  Map<String, JevQuestion> questions, {
  String model = jevModel,
}) => {
  'state': state,
  'model': model,
  'questions': {for (final e in questions.entries) e.key: e.value.toJson()},
};

/// Validates a real response against the questions that were asked: every
/// key present, matching type, numbers in [0, 1], choice among the options.
JevResult decodeResponse(Object? json, Map<String, JevQuestion> asked) {
  final body = _map(json, 'response');
  final answers = _map(body['answers'], 'answers');
  final decoded = <String, JevAnswer>{};
  for (final entry in asked.entries) {
    final raw = answers[entry.key];
    if (raw == null) throw JevDecodeException('missing answer ${entry.key}');
    decoded[entry.key] = _decodeAnswer(entry.key, raw, entry.value);
  }
  final usage = body['usage'];
  final usageMap = usage is Map<String, Object?>
      ? usage
      : const <String, Object?>{};
  return JevResult(
    body['model'] is String ? body['model']! as String : 'unknown',
    decoded,
    JevUsage(
      (usageMap['input_tokens'] as num?)?.toInt() ?? 0,
      (usageMap['output_tokens'] as num?)?.toInt() ?? 0,
    ),
  );
}

JevAnswer _decodeAnswer(String key, Object raw, JevQuestion question) {
  final answer = _map(raw, key);
  return switch (question) {
    NoulQuestion() => _decodeNoul(key, answer),
    ChoiceQuestion(:final options) => _decodeChoice(key, answer, options),
  };
}

NoulAnswer _decodeNoul(String key, Map<String, Object?> answer) {
  if (answer['type'] != 'noul') {
    throw JevDecodeException('$key: expected noul');
  }
  return NoulAnswer(_probability(answer['noul'], '$key.noul'));
}

ChoiceAnswer _decodeChoice(
  String key,
  Map<String, Object?> answer,
  Map<String, String?> options,
) {
  if (answer['type'] != 'choice') {
    throw JevDecodeException('$key: expected choice');
  }
  final choice = answer['choice'];
  if (choice is! String || !options.containsKey(choice)) {
    throw JevDecodeException('$key: choice outside options');
  }
  return ChoiceAnswer(
    choice,
    _probability(answer['confidence'], '$key.confidence'),
    _probabilities(key, answer['probabilities'], options),
  );
}

Map<String, double> _probabilities(
  String key,
  Object? raw,
  Map<String, String?> options,
) {
  if (raw is! Map<String, Object?>) return const {};
  return {
    for (final e in raw.entries)
      if (options.containsKey(e.key))
        e.key: _probability(e.value, '$key.${e.key}')
      else
        e.key: throw JevDecodeException('$key: unknown option ${e.key}'),
  };
}

Map<String, Object?> _map(Object? value, String name) {
  if (value is Map<String, Object?>) return value;
  throw JevDecodeException('$name is not an object');
}

double _probability(Object? value, String name) {
  if (value is! num || value.isNaN || value < 0 || value > 1) {
    throw JevDecodeException('$name is not a probability');
  }
  return value.toDouble();
}

/// Conservative token estimate (≈3 characters per token for English text
/// plus JSON overhead).
int estimateTokens(String text) => (text.length / 3).ceil() + 8;

/// Documented limits: 64k tokens for state + all questions; state + longest
/// question ≤ 32k. Batches stay well inside with a safety margin.
const maxRequestTokens = 48000;
const maxStatePlusQuestionTokens = 24000;

/// Splits questions into requests that respect the limits without dropping
/// any question. Each batch repeats the full state (boundary context is never
/// cut). Throws if the state itself is too large to send with a question.
List<Map<String, JevQuestion>> batchQuestions(
  String state,
  Map<String, JevQuestion> questions,
) {
  final stateTokens = estimateTokens(state);
  final batches = <Map<String, JevQuestion>>[];
  var current = <String, JevQuestion>{};
  var tokens = stateTokens;
  for (final entry in questions.entries) {
    final cost = estimateTokens(entry.value.toJson().toString());
    if (stateTokens + cost > maxStatePlusQuestionTokens) {
      throw const JevDecodeException('transcript too long for one request');
    }
    if (current.isNotEmpty && tokens + cost > maxRequestTokens) {
      batches.add(current);
      current = {};
      tokens = stateTokens;
    }
    current[entry.key] = entry.value;
    tokens += cost;
  }
  if (current.isNotEmpty) batches.add(current);
  return batches;
}
