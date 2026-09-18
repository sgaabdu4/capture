// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shortcut.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Shortcut {

 String get key; Set<Modifier> get modifiers;
/// Create a copy of Shortcut
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShortcutCopyWith<Shortcut> get copyWith => _$ShortcutCopyWithImpl<Shortcut>(this as Shortcut, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Shortcut;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Shortcut&&(identical(other.key, _this.key) || other.key == _this.key)&&const DeepCollectionEquality().equals(other.modifiers, _this.modifiers));
}


@override
int get hashCode {
  final _this = this as Shortcut;
  return Object.hash(runtimeType,_this.key,const DeepCollectionEquality().hash(_this.modifiers));
}

@override
String toString() {
  final _this = this as Shortcut;
  return 'Shortcut(key: ${_this.key}, modifiers: ${_this.modifiers})';
}


}

/// @nodoc
abstract mixin class $ShortcutCopyWith<$Res>  {
  factory $ShortcutCopyWith(Shortcut value, $Res Function(Shortcut) _then) = _$ShortcutCopyWithImpl;
@useResult
$Res call({
 String key, Set<Modifier> modifiers
});




}
/// @nodoc
class _$ShortcutCopyWithImpl<$Res>
    implements $ShortcutCopyWith<$Res> {
  _$ShortcutCopyWithImpl(this._self, this._then);

  final Shortcut _self;
  final $Res Function(Shortcut) _then;

/// Create a copy of Shortcut
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? modifiers = null,}) {
  return _then(Shortcut(
null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,modifiers: null == modifiers ? _self.modifiers : modifiers // ignore: cast_nullable_to_non_nullable
as Set<Modifier>,
  ));
}

}


/// Adds pattern-matching-related methods to [Shortcut].
extension ShortcutPatterns on Shortcut {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Shortcut value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Shortcut() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Shortcut value)  $default,){
final _that = this;
switch (_that) {
case _Shortcut():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Shortcut value)?  $default,){
final _that = this;
switch (_that) {
case _Shortcut() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  Set<Modifier> modifiers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Shortcut() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  Set<Modifier> modifiers)  $default,) {final _that = this;
switch (_that) {
case _Shortcut():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  Set<Modifier> modifiers)?  $default,) {final _that = this;
switch (_that) {
case _Shortcut() when $default != null:
return $default(_that.key,_that.modifiers);case _:
  return null;

}
}

}

/// @nodoc


class _Shortcut extends Shortcut {
  const _Shortcut(this.key, {required  Set<Modifier> modifiers}): _modifiers = modifiers,super._();
  

@override final  String key;
 final  Set<Modifier> _modifiers;
@override Set<Modifier> get modifiers {
  if (_modifiers is EqualUnmodifiableSetView) return _modifiers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_modifiers);
}


/// Create a copy of Shortcut
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShortcutCopyWith<_Shortcut> get copyWith => __$ShortcutCopyWithImpl<_Shortcut>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Shortcut&&(identical(other.key, key) || other.key == key)&&const DeepCollectionEquality().equals(other.modifiers, _modifiers));
}


@override
int get hashCode {
    return Object.hash(runtimeType,key,const DeepCollectionEquality().hash(_modifiers));
}

@override
String toString() {
    return 'Shortcut(key: $key, modifiers: $modifiers)';
}


}

/// @nodoc
abstract mixin class _$ShortcutCopyWith<$Res> implements $ShortcutCopyWith<$Res> {
  factory _$ShortcutCopyWith(_Shortcut value, $Res Function(_Shortcut) _then) = __$ShortcutCopyWithImpl;
@override @useResult
$Res call({
 String key, Set<Modifier> modifiers
});




}
/// @nodoc
class __$ShortcutCopyWithImpl<$Res>
    implements _$ShortcutCopyWith<$Res> {
  __$ShortcutCopyWithImpl(this._self, this._then);

  final _Shortcut _self;
  final $Res Function(_Shortcut) _then;

/// Create a copy of Shortcut
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? modifiers = null,}) {
  return _then(_Shortcut(
null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,modifiers: null == modifiers ? _self._modifiers : modifiers // ignore: cast_nullable_to_non_nullable
as Set<Modifier>,
  ));
}


}

// dart format on
