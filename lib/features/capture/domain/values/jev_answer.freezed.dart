// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'jev_answer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JevAnswer {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is JevAnswer);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'JevAnswer()';
}


}

/// @nodoc
class $JevAnswerCopyWith<$Res>  {
$JevAnswerCopyWith(JevAnswer _, $Res Function(JevAnswer) __);
}



/// @nodoc


class NoulAnswer implements JevAnswer {
  const NoulAnswer(this.yes);
  

 final  double yes;

/// Create a copy of JevAnswer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoulAnswerCopyWith<NoulAnswer> get copyWith => _$NoulAnswerCopyWithImpl<NoulAnswer>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is NoulAnswer&&(identical(other.yes, yes) || other.yes == yes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,yes);
}

@override
String toString() {
    return 'JevAnswer.noul(yes: $yes)';
}


}

/// @nodoc
abstract mixin class $NoulAnswerCopyWith<$Res> implements $JevAnswerCopyWith<$Res> {
  factory $NoulAnswerCopyWith(NoulAnswer value, $Res Function(NoulAnswer) _then) = _$NoulAnswerCopyWithImpl;
@useResult
$Res call({
 double yes
});




}
/// @nodoc
class _$NoulAnswerCopyWithImpl<$Res>
    implements $NoulAnswerCopyWith<$Res> {
  _$NoulAnswerCopyWithImpl(this._self, this._then);

  final NoulAnswer _self;
  final $Res Function(NoulAnswer) _then;

/// Create a copy of JevAnswer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? yes = null,}) {
  return _then(NoulAnswer(
null == yes ? _self.yes : yes // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class ChoiceAnswer implements JevAnswer {
  const ChoiceAnswer(this.choice, this.confidence,  Map<String, double> probabilities): _probabilities = probabilities;
  

 final  String choice;
 final  double confidence;
 final  Map<String, double> _probabilities;
 Map<String, double> get probabilities {
  if (_probabilities is EqualUnmodifiableMapView) return _probabilities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_probabilities);
}


/// Create a copy of JevAnswer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChoiceAnswerCopyWith<ChoiceAnswer> get copyWith => _$ChoiceAnswerCopyWithImpl<ChoiceAnswer>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ChoiceAnswer&&(identical(other.choice, choice) || other.choice == choice)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&const DeepCollectionEquality().equals(other.probabilities, _probabilities));
}


@override
int get hashCode {
    return Object.hash(runtimeType,choice,confidence,const DeepCollectionEquality().hash(_probabilities));
}

@override
String toString() {
    return 'JevAnswer.choice(choice: $choice, confidence: $confidence, probabilities: $probabilities)';
}


}

/// @nodoc
abstract mixin class $ChoiceAnswerCopyWith<$Res> implements $JevAnswerCopyWith<$Res> {
  factory $ChoiceAnswerCopyWith(ChoiceAnswer value, $Res Function(ChoiceAnswer) _then) = _$ChoiceAnswerCopyWithImpl;
@useResult
$Res call({
 String choice, double confidence, Map<String, double> probabilities
});




}
/// @nodoc
class _$ChoiceAnswerCopyWithImpl<$Res>
    implements $ChoiceAnswerCopyWith<$Res> {
  _$ChoiceAnswerCopyWithImpl(this._self, this._then);

  final ChoiceAnswer _self;
  final $Res Function(ChoiceAnswer) _then;

/// Create a copy of JevAnswer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? choice = null,Object? confidence = null,Object? probabilities = null,}) {
  return _then(ChoiceAnswer(
null == choice ? _self.choice : choice // ignore: cast_nullable_to_non_nullable
as String,null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,null == probabilities ? _self._probabilities : probabilities // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}


}

// dart format on
