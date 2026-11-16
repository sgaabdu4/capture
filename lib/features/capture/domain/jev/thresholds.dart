import 'package:capture/features/capture/domain/jev/band.dart';

export 'package:capture/features/capture/domain/jev/band.dart';

/// Provisional until evaluated on representative recordings (test/eval).
const boundaryBand = Band(0.5, 0.3, 0.7);
const taskBand = Band(0.5, 0.35, 0.65);
const alertBand = Band(0.5, 0.35, 0.65);
const retrievalBand = Band(0.6, 0.4, 0.8);
const correctionBand = Band(0.6, 0.4, 0.8);

/// Choice confidence below which a group or date selection is flagged.
const minGroupConfidence = 0.4;
const minDateConfidence = 0.4;
