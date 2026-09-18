// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shortcut_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShortcutModel {

 String? get key; Set<Modifier> get modifiers;
/// Create a copy of ShortcutModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShortcutModelCopyWith<ShortcutModel> get copyWith => _$ShortcutModelCopyWithImpl<ShortcutModel>(this as ShortcutModel, _$identity);

  /// Serializes this ShortcutModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ShortcutModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShortcutModel&&(identical(other.key, _this.key) || other.key == _this.key)&&const DeepCollectionEquality().equals(other.modifiers, _this.modifiers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ShortcutModel;
  return Object.hash(runtimeType,_this.key,const DeepCollectionEquality().hash(_this.modifiers));
}

@override
String toString() {
  final _this = this as ShortcutModel;
  return 'ShortcutModel(key: ${_this.key}, modifiers: ${_this.modifiers})';
}


}

/// @nodoc
abstract mixin class $ShortcutModelCopyWith<$Res>  {
  factory $ShortcutModelCopyWith(ShortcutModel value, $Res Function(ShortcutModel) _then) = _$ShortcutModelCopyWithImpl;
@useResult
$Res call({
 String? key, Set<Modifier> modifiers
});




}
/// @nodoc
class _$ShortcutModelCopyWithImpl<$Res>
    implements $ShortcutModelCopyWith<$Res> {
  _$ShortcutModelCopyWithImpl(this._self, this._then);

  final ShortcutModel _self;
  final $Res Function(ShortcutModel) _then;

/// Create a copy of ShortcutModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = freezed,Object? modifiers = null,}) {
  return _then(ShortcutModel(
key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String?,modifiers: null == modifiers ? _self.modifiers : modifiers // ignore: cast_nullable_to_non_nullable
as Set<Modifier>,
  ));
}

}


/// Adds pattern-matching-related methods to [ShortcutModel].
extension ShortcutModelPatterns on ShortcutModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShortcutModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShortcutModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShortcutModel value)  $default,){
final _that = this;
switch (_that) {
case _ShortcutModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShortcutModel value)?  $default,){
final _that = this;
switch (_that) {
case _ShortcutModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? key,  Set<Modifier> modifiers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShortcutModel() when $default != null:
return $default(_that.key,_that.modifiers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? key,  Set<Modifier> modifiers)  $default,) {final _that = this;
switch (_that) {
case _ShortcutModel():
return $default(_that.key,_that.modifiers);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? key,  Set<Modifier> modifiers)?  $default,) {final _that = this;
switch (_that) {
case _ShortcutModel() when $default != null:
return $default(_that.key,_that.modifiers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShortcutModel extends ShortcutModel {
  const _ShortcutModel({required this.key, required  Set<Modifier> modifiers}): _modifiers = modifiers,super._();
  factory _ShortcutModel.fromJson(Map<String, dynamic> json) => _$ShortcutModelFromJson(json);

@override final  String? key;
 final  Set<Modifier> _modifiers;
@override Set<Modifier> get modifiers {
  if (_modifiers is EqualUnmodifiableSetView) return _modifiers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_modifiers);
}


/// Create a copy of ShortcutModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShortcutModelCopyWith<_ShortcutModel> get copyWith => __$ShortcutModelCopyWithImpl<_ShortcutModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShortcutModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShortcutModel&&(identical(other.key, key) || other.key == key)&&const DeepCollectionEquality().equals(other.modifiers, _modifiers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,key,const DeepCollectionEquality().hash(_modifiers));
}

@override
String toString() {
    return 'ShortcutModel(key: $key, modifiers: $modifiers)';
}


}

/// @nodoc
abstract mixin class _$ShortcutModelCopyWith<$Res> implements $ShortcutModelCopyWith<$Res> {
  factory _$ShortcutModelCopyWith(_ShortcutModel value, $Res Function(_ShortcutModel) _then) = __$ShortcutModelCopyWithImpl;
@override @useResult
$Res call({
 String? key, Set<Modifier> modifiers
});




}
/// @nodoc
class __$ShortcutModelCopyWithImpl<$Res>
    implements _$ShortcutModelCopyWith<$Res> {
  __$ShortcutModelCopyWithImpl(this._self, this._then);

  final _ShortcutModel _self;
  final $Res Function(_ShortcutModel) _then;

/// Create a copy of ShortcutModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = freezed,Object? modifiers = null,}) {
  return _then(_ShortcutModel(
key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String?,modifiers: null == modifiers ? _self._modifiers : modifiers // ignore: cast_nullable_to_non_nullable
as Set<Modifier>,
  ));
}


}

// dart format on
