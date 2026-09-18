import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:flutter/material.dart';

/// Date and time pickers for a task's date, shared by the capture editor and
/// the saved-item editor.
extension WhenPickers on BuildContext {
  static const _datePickerRoute = 'when-date-picker';
  static const _timePickerRoute = 'when-time-picker';
  static const _pickerPastYears = 1;
  static const _pickerFutureYears = 5;
  static const _defaultHour = 9;
  static const _defaultMinute = 0;

  /// Asks for a new day for [base], keeping its time; [onPicked] is not
  /// called when cancelled.
  Future<void> pickDay(DueDate? base, DateTime today, ValueChanged<DueDate> onPicked) async {
    final picked = await showDatePicker(
      context: this,
      routeSettings: const .new(name: _datePickerRoute),
      initialDate: switch (base) {
        DueDate(:final year, :final month, :final day) => .new(year, month, day),
        null => today,
      },
      firstDate: .new(today.year - _pickerPastYears),
      lastDate: .new(today.year + _pickerFutureYears),
    );
    if (picked == null || !mounted) return;
    final DateTime(:year, :month, :day) = picked;
    onPicked(.new(year, month, day, hour: base?.hour, minute: base?.minute));
  }

  /// Asks for a new time for [base]; [onPicked] is not called when cancelled.
  Future<void> pickTime(DueDate base, ValueChanged<DueDate> onPicked) async {
    final picked = await showTimePicker(
      context: this,
      routeSettings: const .new(name: _timePickerRoute),
      initialTime: switch (base) {
        DueDate(hour: final int hour, minute: final int minute) => .new(hour: hour, minute: minute),
        DueDate(hour: final int hour) => .new(hour: hour, minute: _defaultMinute),
        DueDate() => const .new(hour: _defaultHour, minute: _defaultMinute),
      },
    );
    if (picked == null || !mounted) return;
    onPicked(base.withTime(picked.hour, picked.minute));
  }
}
