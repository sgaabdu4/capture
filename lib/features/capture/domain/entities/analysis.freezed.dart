// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analysis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Analysis {

 List<ProposalItem> get items; List<Thought> get thoughts; List<TranscriptUnit> get units; List<JevCallMetrics> get calls;
/// Create a copy of Analysis
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalysisCopyWith<Analysis> get copyWith => _$AnalysisCopyWithImpl<Analysis>(this as Analysis, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Analysis;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Analysis&&const DeepCollectionEquality().equals(other.items, _this.items)&&const DeepCollectionEquality().equals(other.thoughts, _this.thoughts)&&const DeepCollectionEquality().equals(other.units, _this.units)&&const DeepCollectionEquality().equals(other.calls, _this.calls));
}


@override
int get hashCode {
  final _this = this as Analysis;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),const DeepCollectionEquality().hash(_this.thoughts),const DeepCollectionEquality().hash(_this.units),const DeepCollectionEquality().hash(_this.calls));
}

@override
String toString() {
  final _this = this as Analysis;
  return 'Analysis(items: ${_this.items}, thoughts: ${_this.thoughts}, units: ${_this.units}, calls: ${_this.calls})';
}


}

/// @nodoc
abstract mixin class $AnalysisCopyWith<$Res>  {
  factory $AnalysisCopyWith(Analysis value, $Res Function(Analysis) _then) = _$AnalysisCopyWithImpl;
@useResult
$Res call({
 List<ProposalItem> items, List<Thought> thoughts, List<TranscriptUnit> units, List<JevCallMetrics> calls
});




}
/// @nodoc
class _$AnalysisCopyWithImpl<$Res>
    implements $AnalysisCopyWith<$Res> {
  _$AnalysisCopyWithImpl(this._self, this._then);

  final Analysis _self;
  final $Res Function(Analysis) _then;

/// Create a copy of Analysis
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? thoughts = null,Object? units = null,Object? calls = null,}) {
  return _then(Analysis(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ProposalItem>,thoughts: null == thoughts ? _self.thoughts : thoughts // ignore: cast_nullable_to_non_nullable
as List<Thought>,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as List<TranscriptUnit>,calls: null == calls ? _self.calls : calls // ignore: cast_nullable_to_non_nullable
as List<JevCallMetrics>,
  ));
}

}


/// Adds pattern-matching-related methods to [Analysis].
extension AnalysisPatterns on Analysis {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Analysis value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Analysis() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Analysis value)  $default,){
final _that = this;
switch (_that) {
case _Analysis():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Analysis value)?  $default,){
final _that = this;
switch (_that) {
case _Analysis() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ProposalItem> items,  List<Thought> thoughts,  List<TranscriptUnit> units,  List<JevCallMetrics> calls)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Analysis() when $default != null:
return $default(_that.items,_that.thoughts,_that.units,_that.calls);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ProposalItem> items,  List<Thought> thoughts,  List<TranscriptUnit> units,  List<JevCallMetrics> calls)  $default,) {final _that = this;
switch (_that) {
case _Analysis():
return $default(_that.items,_that.thoughts,_that.units,_that.calls);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ProposalItem> items,  List<Thought> thoughts,  List<TranscriptUnit> units,  List<JevCallMetrics> calls)?  $default,) {final _that = this;
switch (_that) {
case _Analysis() when $default != null:
return $default(_that.items,_that.thoughts,_that.units,_that.calls);case _:
  return null;

}
}

}

/// @nodoc


class _Analysis extends Analysis {
  const _Analysis({required  List<ProposalItem> items, required  List<Thought> thoughts, required  List<TranscriptUnit> units, required  List<JevCallMetrics> calls}): _items = items,_thoughts = thoughts,_units = units,_calls = calls,super._();
  

 final  List<ProposalItem> _items;
@override List<ProposalItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  List<Thought> _thoughts;
@override List<Thought> get thoughts {
  if (_thoughts is EqualUnmodifiableListView) return _thoughts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_thoughts);
}

 final  List<TranscriptUnit> _units;
@override List<TranscriptUnit> get units {
  if (_units is EqualUnmodifiableListView) return _units;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_units);
}

 final  List<JevCallMetrics> _calls;
@override List<JevCallMetrics> get calls {
  if (_calls is EqualUnmodifiableListView) return _calls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_calls);
}


/// Create a copy of Analysis
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalysisCopyWith<_Analysis> get copyWith => __$AnalysisCopyWithImpl<_Analysis>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Analysis&&const DeepCollectionEquality().equals(other.items, _items)&&const DeepCollectionEquality().equals(other.thoughts, _thoughts)&&const DeepCollectionEquality().equals(other.units, _units)&&const DeepCollectionEquality().equals(other.calls, _calls));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_thoughts),const DeepCollectionEquality().hash(_units),const DeepCollectionEquality().hash(_calls));
}

@override
String toString() {
    return 'Analysis(items: $items, thoughts: $thoughts, units: $units, calls: $calls)';
}


}

/// @nodoc
abstract mixin class _$AnalysisCopyWith<$Res> implements $AnalysisCopyWith<$Res> {
  factory _$AnalysisCopyWith(_Analysis value, $Res Function(_Analysis) _then) = __$AnalysisCopyWithImpl;
@override @useResult
$Res call({
 List<ProposalItem> items, List<Thought> thoughts, List<TranscriptUnit> units, List<JevCallMetrics> calls
});




}
/// @nodoc
class __$AnalysisCopyWithImpl<$Res>
    implements _$AnalysisCopyWith<$Res> {
  __$AnalysisCopyWithImpl(this._self, this._then);

  final _Analysis _self;
  final $Res Function(_Analysis) _then;

/// Create a copy of Analysis
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? thoughts = null,Object? units = null,Object? calls = null,}) {
  return _then(_Analysis(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ProposalItem>,thoughts: null == thoughts ? _self._thoughts : thoughts // ignore: cast_nullable_to_non_nullable
as List<Thought>,units: null == units ? _self._units : units // ignore: cast_nullable_to_non_nullable
as List<TranscriptUnit>,calls: null == calls ? _self._calls : calls // ignore: cast_nullable_to_non_nullable
as List<JevCallMetrics>,
  ));
}


}

// dart format on
