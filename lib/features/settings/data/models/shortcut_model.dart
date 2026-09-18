import 'package:capture/features/settings/domain/entities/modifier.dart';
import 'package:capture/features/settings/domain/entities/shortcut.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shortcut_model.freezed.dart';
part 'shortcut_model.g.dart';

@freezed
sealed class ShortcutModel with _$ShortcutModel {
  const ShortcutModel._();

  const factory ShortcutModel({required String? key, required Set<Modifier> modifiers}) =
      _ShortcutModel;

  factory ShortcutModel.fromJson(Map<String, dynamic> json) => _$ShortcutModelFromJson(json);

  factory ShortcutModel.fromEntity(Shortcut s) => ShortcutModel(key: s.key, modifiers: s.modifiers);

  Shortcut toEntity() => .new(key, modifiers: modifiers);
}
