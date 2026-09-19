import 'package:capture/features/capture/domain/entities/capture_failure.dart';
import 'package:capture/features/capture/domain/entities/capture_record.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_notice.dart';
import 'package:capture/features/capture/presentation/notifiers/capture_phase.dart';
import 'package:capture/features/capture/presentation/notifiers/shell_destination.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'capture_flow_state.freezed.dart';

@freezed
sealed class CaptureFlowState with _$CaptureFlowState {
  const CaptureFlowState._();

  const factory CaptureFlowState({
    /// Newest first.
    required List<CaptureRecord> captures,
    @Default(CapturePhase.idle) CapturePhase phase,
    String? activeId,
    CaptureNotice? notice,
    CaptureFailure? failure,

    /// Page the main window should open; acted on once per serial.
    ShellDestination? destination,
    String? editId,
    @Default(0) int destinationSerial,

    /// The latest capture saved without the review card, for its
    /// notification.
    String? autoSavedId,
  }) = _CaptureFlowState;

  CaptureRecord? byId(String? id) => captures.where((c) => c.id == id).firstOrNull;

  CaptureRecord? get active => byId(activeId);

  /// The capture on the review card, if one is showing.
  CaptureRecord? get reviewing => phase == .review ? active : null;

  bool get busyWith => phase != .idle;
}
