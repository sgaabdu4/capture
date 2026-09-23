import 'package:capture/core/domain/values/notion_id.dart';
import 'package:capture/core/domain/values/required_text.dart';
import 'package:capture/features/capture/data/models/due_date_model.dart';
import 'package:capture/features/capture/data/models/source_span_model.dart';
import 'package:capture/features/capture/domain/entities/edited_field.dart';
import 'package:capture/features/capture/domain/entities/item_kind.dart';
import 'package:capture/features/capture/domain/entities/proposal_item.dart';
import 'package:capture/features/capture/domain/entities/review_flag.dart';
import 'package:capture/features/capture/domain/values/item_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'proposal_item_model.freezed.dart';
part 'proposal_item_model.g.dart';

@freezed
sealed class ProposalItemModel with _$ProposalItemModel {
  const ProposalItemModel._();

  const factory ProposalItemModel({
    required String id,
    required List<SourceSpanModel> sources,
    required ItemKind kind,
    required String? groupId,
    required String title,
    required String body,
    DueDateModel? due,
    DueDateModel? reminder,
    @Default({}) Set<ReviewFlag> flags,
    @Default({}) Set<EditedField> edited,
    @Default(true) bool included,
  }) = _ProposalItemModel;

  factory ProposalItemModel.fromJson(Map<String, dynamic> json) =>
      _$ProposalItemModelFromJson(json);

  factory ProposalItemModel.fromEntity(ProposalItem i) => ProposalItemModel(
    id: i.id.value,
    sources: [for (final s in i.sources) SourceSpanModel.fromEntity(s)],
    kind: i.kind,
    groupId: i.groupId?.value,
    title: i.title ?? '',
    body: i.body ?? '',
    due: switch (i.due) {
      final d? => .fromEntity(d),
      null => null,
    },
    reminder: switch (i.reminder) {
      final r? => .fromEntity(r),
      null => null,
    },
    flags: i.flags,
    edited: i.edited,
    included: i.included,
  );

  ProposalItem toEntity() => .new(
    id: ItemId(id),
    sources: [for (final s in sources) s.toEntity()],
    kind: kind,
    groupId: switch (groupId) {
      final g? => NotionId(g),
      null => null,
    },
    title: optionalText(title),
    body: optionalText(body),
    due: due?.toEntity(),
    reminder: reminder?.toEntity(),
    flags: flags,
    edited: edited,
    included: included,
  );
}
