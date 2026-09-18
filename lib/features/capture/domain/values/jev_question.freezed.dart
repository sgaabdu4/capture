// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'jev_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JevQuestion {

 String get instructions;
/// Create a copy of JevQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JevQuestionCopyWith<JevQuestion> get copyWith => _$JevQuestionCopyWithImpl<JevQuestion>(this as JevQuestion, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as JevQuestion;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JevQuestion&&(identical(other.instructions, _this.instructions) || other.instructions == _this.instructions));
}


@override
int get hashCode {
  final _this = this as JevQuestion;
  return Object.hash(runtimeType,_this.instructions);
}

@override
String toString() {
  final _this = this as JevQuestion;
  return 'JevQuestion(instructions: ${_this.instructions})';
}


}

/// @nodoc
abstract mixin class $JevQuestionCopyWith<$Res>  {
  factory $JevQuestionCopyWith(JevQuestion value, $Res Function(JevQuestion) _then) = _$JevQuestionCopyWithImpl;
@useResult
$Res call({
 String instructions
});




}
/// @nodoc
class _$JevQuestionCopyWithImpl<$Res>
    implements $JevQuestionCopyWith<$Res> {
  _$JevQuestionCopyWithImpl(this._self, this._then);

  final JevQuestion _self;
  final $Res Function(JevQuestion) _then;

/// Create a copy of JevQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? instructions = null,}) {
  return _then(_self.copyWith(
instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}



/// @nodoc


class NoulQuestion implements JevQuestion {
  const NoulQuestion(this.instructions, {this.yes, this.no});
  

@override final  String instructions;
 final  String? yes;
 final  String? no;

/// Create a copy of JevQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NoulQuestionCopyWith<NoulQuestion> get copyWith => _$NoulQuestionCopyWithImpl<NoulQuestion>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is NoulQuestion&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.yes, yes) || other.yes == yes)&&(identical(other.no, no) || other.no == no));
}


@override
int get hashCode {
    return Object.hash(runtimeType,instructions,yes,no);
}

@override
String toString() {
    return 'JevQuestion.noul(instructions: $instructions, yes: $yes, no: $no)';
}


}

/// @nodoc
abstract mixin class $NoulQuestionCopyWith<$Res> implements $JevQuestionCopyWith<$Res> {
  factory $NoulQuestionCopyWith(NoulQuestion value, $Res Function(NoulQuestion) _then) = _$NoulQuestionCopyWithImpl;
@override @useResult
$Res call({
 String instructions, String? yes, String? no
});




}
/// @nodoc
class _$NoulQuestionCopyWithImpl<$Res>
    implements $NoulQuestionCopyWith<$Res> {
  _$NoulQuestionCopyWithImpl(this._self, this._then);

  final NoulQuestion _self;
  final $Res Function(NoulQuestion) _then;

/// Create a copy of JevQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? instructions = null,Object? yes = freezed,Object? no = freezed,}) {
  return _then(NoulQuestion(
null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,yes: freezed == yes ? _self.yes : yes // ignore: cast_nullable_to_non_nullable
as String?,no: freezed == no ? _self.no : no // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ChoiceQuestion implements JevQuestion {
   ChoiceQuestion(this.instructions,  Map<String, String?> options): assert(options.length >= 2 && options.length <= 255),_options = options;
  

@override final  String instructions;
 final  Map<String, String?> _options;
 Map<String, String?> get options {
  if (_options is EqualUnmodifiableMapView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_options);
}


/// Create a copy of JevQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChoiceQuestionCopyWith<ChoiceQuestion> get copyWith => _$ChoiceQuestionCopyWithImpl<ChoiceQuestion>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ChoiceQuestion&&(identical(other.instructions, instructions) || other.instructions == instructions)&&const DeepCollectionEquality().equals(other.options, _options));
}


@override
int get hashCode {
    return Object.hash(runtimeType,instructions,const DeepCollectionEquality().hash(_options));
}

@override
String toString() {
    return 'JevQuestion.choice(instructions: $instructions, options: $options)';
}


}

/// @nodoc
abstract mixin class $ChoiceQuestionCopyWith<$Res> implements $JevQuestionCopyWith<$Res> {
  factory $ChoiceQuestionCopyWith(ChoiceQuestion value, $Res Function(ChoiceQuestion) _then) = _$ChoiceQuestionCopyWithImpl;
@override @useResult
$Res call({
 String instructions, Map<String, String?> options
});




}
/// @nodoc
class _$ChoiceQuestionCopyWithImpl<$Res>
    implements $ChoiceQuestionCopyWith<$Res> {
  _$ChoiceQuestionCopyWithImpl(this._self, this._then);

  final ChoiceQuestion _self;
  final $Res Function(ChoiceQuestion) _then;

/// Create a copy of JevQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? instructions = null,Object? options = null,}) {
  return _then(ChoiceQuestion(
null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as Map<String, String?>,
  ));
}


}

// dart format on
