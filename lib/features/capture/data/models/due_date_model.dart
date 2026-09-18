import 'package:capture/features/capture/domain/entities/due_date.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'due_date_model.freezed.dart';
part 'due_date_model.g.dart';

@freezed
sealed class DueDateModel with _$DueDateModel {
  const DueDateModel._();

  const factory DueDateModel({
    required int year,
    required int month,
    required int day,
    int? hour,
    int? minute,
  }) = _DueDateModel;

  factory DueDateModel.fromJson(Map<String, dynamic> json) => _$DueDateModelFromJson(json);

  factory DueDateModel.fromEntity(DueDate d) =>
      DueDateModel(year: d.year, month: d.month, day: d.day, hour: d.hour, minute: d.minute);

  DueDate toEntity() => .new(year, month, day, hour: hour, minute: minute);
}
