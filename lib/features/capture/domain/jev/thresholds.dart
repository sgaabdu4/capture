/// PROVISIONAL decision thresholds, kept together so they can be evaluated
/// on representative recordings (see test/eval). They only shape the
/// proposal and its review flags; nothing bypasses user approval.
///
/// Noul values are P(yes). A value inside [low, high) is treated as
/// uncertain and flagged for review; the provisional decision is still
/// `p >= decide`.
class Band {
  const Band(this.decide, this.low, this.high);
  final double decide;
  final double low;
  final double high;

  bool yes(double p) => p >= decide;
  bool uncertain(double p) => p >= low && p < high;
}

const boundaryBand = Band(0.5, 0.3, 0.7);
const taskBand = Band(0.5, 0.35, 0.65);
const alertBand = Band(0.5, 0.35, 0.65);
const retrievalBand = Band(0.6, 0.4, 0.8);
const correctionBand = Band(0.6, 0.4, 0.8);

/// Choice confidence below which a group or date selection is flagged.
const minGroupConfidence = 0.4;
const minDateConfidence = 0.4;
