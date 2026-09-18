// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'proposal_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProposalItemModel {

 String get id; List<SourceSpanModel> get sources; ItemKind get kind; String? get groupId; String get title; String get body; DueDateModel? get due; DueDateModel? get reminder; Set<ReviewFlag> get flags; Set<EditedField> get edited; bool get included;
/// Create a copy of ProposalItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProposalItemModelCopyWith<ProposalItemModel> get copyWith => _$ProposalItemModelCopyWithImpl<ProposalItemModel>(this as ProposalItemModel, _$identity);

  /// Serializes this ProposalItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProposalItemModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProposalItemModel&&(identical(other.id, _this.id) || other.id == _this.id)&&const DeepCollectionEquality().equals(other.sources, _this.sources)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.groupId, _this.groupId) || other.groupId == _this.groupId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.due, _this.due) || other.due == _this.due)&&(identical(other.reminder, _this.reminder) || other.reminder == _this.reminder)&&const DeepCollectionEquality().equals(other.flags, _this.flags)&&const DeepCollectionEquality().equals(other.edited, _this.edited)&&(identical(other.included, _this.included) || other.included == _this.included));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProposalItemModel;
  return Object.hash(runtimeType,_this.id,const DeepCollectionEquality().hash(_this.sources),_this.kind,_this.groupId,_this.title,_this.body,_this.due,_this.reminder,const DeepCollectionEquality().hash(_this.flags),const DeepCollectionEquality().hash(_this.edited),_this.included);
}

@override
String toString() {
  final _this = this as ProposalItemModel;
  return 'ProposalItemModel(id: ${_this.id}, sources: ${_this.sources}, kind: ${_this.kind}, groupId: ${_this.groupId}, title: ${_this.title}, body: ${_this.body}, due: ${_this.due}, reminder: ${_this.reminder}, flags: ${_this.flags}, edited: ${_this.edited}, included: ${_this.included})';
}


}

/// @nodoc
abstract mixin class $ProposalItemModelCopyWith<$Res>  {
  factory $ProposalItemModelCopyWith(ProposalItemModel value, $Res Function(ProposalItemModel) _then) = _$ProposalItemModelCopyWithImpl;
@useResult
$Res call({
 String id, List<SourceSpanModel> sources, ItemKind kind, String? groupId, String title, String body, DueDateModel? due, DueDateModel? reminder, Set<ReviewFlag> flags, Set<EditedField> edited, bool included
});


$DueDateModelCopyWith<$Res>? get due;$DueDateModelCopyWith<$Res>? get reminder;

}
/// @nodoc
class _$ProposalItemModelCopyWithImpl<$Res>
    implements $ProposalItemModelCopyWith<$Res> {
  _$ProposalItemModelCopyWithImpl(this._self, this._then);

  final ProposalItemModel _self;
  final $Res Function(ProposalItemModel) _then;

/// Create a copy of ProposalItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sources = null,Object? kind = null,Object? groupId = freezed,Object? title = null,Object? body = null,Object? due = freezed,Object? reminder = freezed,Object? flags = null,Object? edited = null,Object? included = null,}) {
  return _then(ProposalItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<SourceSpanModel>,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ItemKind,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,due: freezed == due ? _self.due : due // ignore: cast_nullable_to_non_nullable
as DueDateModel?,reminder: freezed == reminder ? _self.reminder : reminder // ignore: cast_nullable_to_non_nullable
as DueDateModel?,flags: null == flags ? _self.flags : flags // ignore: cast_nullable_to_non_nullable
as Set<ReviewFlag>,edited: null == edited ? _self.edited : edited // ignore: cast_nullable_to_non_nullable
as Set<EditedField>,included: null == included ? _self.included : included // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ProposalItemModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DueDateModelCopyWith<$Res>? get due {
    if (_self.due == null) {
    return null;
  }

  return $DueDateModelCopyWith<$Res>(_self.due!, (value) {
    return _then(_self.copyWith(due: value));
  });
}/// Create a copy of ProposalItemModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DueDateModelCopyWith<$Res>? get reminder {
    if (_self.reminder == null) {
    return null;
  }

  return $DueDateModelCopyWith<$Res>(_self.reminder!, (value) {
    return _then(_self.copyWith(reminder: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProposalItemModel].
extension ProposalItemModelPatterns on ProposalItemModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProposalItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProposalItemModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProposalItemModel value)  $default,){
final _that = this;
switch (_that) {
case _ProposalItemModel():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProposalItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProposalItemModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  List<SourceSpanModel> sources,  ItemKind kind,  String? groupId,  String title,  String body,  DueDateModel? due,  DueDateModel? reminder,  Set<ReviewFlag> flags,  Set<EditedField> edited,  bool included)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProposalItemModel() when $default != null:
return $default(_that.id,_that.sources,_that.kind,_that.groupId,_that.title,_that.body,_that.due,_that.reminder,_that.flags,_that.edited,_that.included);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  List<SourceSpanModel> sources,  ItemKind kind,  String? groupId,  String title,  String body,  DueDateModel? due,  DueDateModel? reminder,  Set<ReviewFlag> flags,  Set<EditedField> edited,  bool included)  $default,) {final _that = this;
switch (_that) {
case _ProposalItemModel():
return $default(_that.id,_that.sources,_that.kind,_that.groupId,_that.title,_that.body,_that.due,_that.reminder,_that.flags,_that.edited,_that.included);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  List<SourceSpanModel> sources,  ItemKind kind,  String? groupId,  String title,  String body,  DueDateModel? due,  DueDateModel? reminder,  Set<ReviewFlag> flags,  Set<EditedField> edited,  bool included)?  $default,) {final _that = this;
switch (_that) {
case _ProposalItemModel() when $default != null:
return $default(_that.id,_that.sources,_that.kind,_that.groupId,_that.title,_that.body,_that.due,_that.reminder,_that.flags,_that.edited,_that.included);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProposalItemModel extends ProposalItemModel {
  const _ProposalItemModel({required this.id, required  List<SourceSpanModel> sources, required this.kind, required this.groupId, required this.title, required this.body, this.due, this.reminder,  Set<ReviewFlag> flags = const {},  Set<EditedField> edited = const {}, this.included = true}): _sources = sources,_flags = flags,_edited = edited,super._();
  factory _ProposalItemModel.fromJson(Map<String, dynamic> json) => _$ProposalItemModelFromJson(json);

@override final  String id;
 final  List<SourceSpanModel> _sources;
@override List<SourceSpanModel> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}

@override final  ItemKind kind;
@override final  String? groupId;
@override final  String title;
@override final  String body;
@override final  DueDateModel? due;
@override final  DueDateModel? reminder;
 final  Set<ReviewFlag> _flags;
@override@JsonKey() Set<ReviewFlag> get flags {
  if (_flags is EqualUnmodifiableSetView) return _flags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_flags);
}

 final  Set<EditedField> _edited;
@override@JsonKey() Set<EditedField> get edited {
  if (_edited is EqualUnmodifiableSetView) return _edited;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_edited);
}

@override@JsonKey() final  bool included;

/// Create a copy of ProposalItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProposalItemModelCopyWith<_ProposalItemModel> get copyWith => __$ProposalItemModelCopyWithImpl<_ProposalItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProposalItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProposalItemModel&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.sources, _sources)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.due, due) || other.due == due)&&(identical(other.reminder, reminder) || other.reminder == reminder)&&const DeepCollectionEquality().equals(other.flags, _flags)&&const DeepCollectionEquality().equals(other.edited, _edited)&&(identical(other.included, included) || other.included == included));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_sources),kind,groupId,title,body,due,reminder,const DeepCollectionEquality().hash(_flags),const DeepCollectionEquality().hash(_edited),included);
}

@override
String toString() {
    return 'ProposalItemModel(id: $id, sources: $sources, kind: $kind, groupId: $groupId, title: $title, body: $body, due: $due, reminder: $reminder, flags: $flags, edited: $edited, included: $included)';
}


}

/// @nodoc
abstract mixin class _$ProposalItemModelCopyWith<$Res> implements $ProposalItemModelCopyWith<$Res> {
  factory _$ProposalItemModelCopyWith(_ProposalItemModel value, $Res Function(_ProposalItemModel) _then) = __$ProposalItemModelCopyWithImpl;
@override @useResult
$Res call({
 String id, List<SourceSpanModel> sources, ItemKind kind, String? groupId, String title, String body, DueDateModel? due, DueDateModel? reminder, Set<ReviewFlag> flags, Set<EditedField> edited, bool included
});


@override $DueDateModelCopyWith<$Res>? get due;@override $DueDateModelCopyWith<$Res>? get reminder;

}
/// @nodoc
class __$ProposalItemModelCopyWithImpl<$Res>
    implements _$ProposalItemModelCopyWith<$Res> {
  __$ProposalItemModelCopyWithImpl(this._self, this._then);

  final _ProposalItemModel _self;
  final $Res Function(_ProposalItemModel) _then;

/// Create a copy of ProposalItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sources = null,Object? kind = null,Object? groupId = freezed,Object? title = null,Object? body = null,Object? due = freezed,Object? reminder = freezed,Object? flags = null,Object? edited = null,Object? included = null,}) {
  return _then(_ProposalItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<SourceSpanModel>,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ItemKind,groupId: freezed == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,due: freezed == due ? _self.due : due // ignore: cast_nullable_to_non_nullable
as DueDateModel?,reminder: freezed == reminder ? _self.reminder : reminder // ignore: cast_nullable_to_non_nullable
as DueDateModel?,flags: null == flags ? _self._flags : flags // ignore: cast_nullable_to_non_nullable
as Set<ReviewFlag>,edited: null == edited ? _self._edited : edited // ignore: cast_nullable_to_non_nullable
as Set<EditedField>,included: null == included ? _self.included : included // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ProposalItemModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DueDateModelCopyWith<$Res>? get due {
    if (_self.due == null) {
    return null;
  }

  return $DueDateModelCopyWith<$Res>(_self.due!, (value) {
    return _then(_self.copyWith(due: value));
  });
}/// Create a copy of ProposalItemModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DueDateModelCopyWith<$Res>? get reminder {
    if (_self.reminder == null) {
    return null;
  }

  return $DueDateModelCopyWith<$Res>(_self.reminder!, (value) {
    return _then(_self.copyWith(reminder: value));
  });
}
}

// dart format on
