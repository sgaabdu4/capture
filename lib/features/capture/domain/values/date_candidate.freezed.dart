// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'date_candidate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DateCandidate {

 String get id; SourceSpan get span; Enum get kind; DayPeriod get period;
/// Create a copy of DateCandidate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DateCandidateCopyWith<DateCandidate> get copyWith => _$DateCandidateCopyWithImpl<DateCandidate>(this as DateCandidate, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DateCandidate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DateCandidate&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.span, _this.span) || other.span == _this.span)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.period, _this.period) || other.period == _this.period));
}


@override
int get hashCode {
  final _this = this as DateCandidate;
  return Object.hash(runtimeType,_this.id,_this.span,_this.kind,_this.period);
}

@override
String toString() {
  final _this = this as DateCandidate;
  return 'DateCandidate(id: ${_this.id}, span: ${_this.span}, kind: ${_this.kind}, period: ${_this.period})';
}


}

/// @nodoc
abstract mixin class $DateCandidateCopyWith<$Res>  {
  factory $DateCandidateCopyWith(DateCandidate value, $Res Function(DateCandidate) _then) = _$DateCandidateCopyWithImpl;
@useResult
$Res call({
 String id, SourceSpan span, DayPeriod period
});


$SourceSpanCopyWith<$Res> get span;

}
/// @nodoc
class _$DateCandidateCopyWithImpl<$Res>
    implements $DateCandidateCopyWith<$Res> {
  _$DateCandidateCopyWithImpl(this._self, this._then);

  final DateCandidate _self;
  final $Res Function(DateCandidate) _then;

/// Create a copy of DateCandidate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? span = null,Object? period = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,span: null == span ? _self.span : span // ignore: cast_nullable_to_non_nullable
as SourceSpan,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as DayPeriod,
  ));
}
/// Create a copy of DateCandidate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SourceSpanCopyWith<$Res> get span {
  
  return $SourceSpanCopyWith<$Res>(_self.span, (value) {
    return _then(_self.copyWith(span: value));
  });
}
}



/// @nodoc


class DayCandidate implements DateCandidate {
  const DayCandidate(this.id, this.span, this.kind, {this.weekday, this.nextQualifier = false, this.month, this.day, this.year, this.first, this.second, this.days, this.period = DayPeriod.none});
  

@override final  String id;
@override final  SourceSpan span;
@override final  DayKind kind;
 final  int? weekday;
@JsonKey() final  bool nextQualifier;
 final  int? month;
 final  int? day;
 final  int? year;
 final  int? first;
 final  int? second;
 final  int? days;
@override@JsonKey() final  DayPeriod period;

/// Create a copy of DateCandidate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayCandidateCopyWith<DayCandidate> get copyWith => _$DayCandidateCopyWithImpl<DayCandidate>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is DayCandidate&&(identical(other.id, id) || other.id == id)&&(identical(other.span, span) || other.span == span)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.nextQualifier, nextQualifier) || other.nextQualifier == nextQualifier)&&(identical(other.month, month) || other.month == month)&&(identical(other.day, day) || other.day == day)&&(identical(other.year, year) || other.year == year)&&(identical(other.first, first) || other.first == first)&&(identical(other.second, second) || other.second == second)&&(identical(other.days, days) || other.days == days)&&(identical(other.period, period) || other.period == period));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,span,kind,weekday,nextQualifier,month,day,year,first,second,days,period);
}

@override
String toString() {
    return 'DateCandidate.day(id: $id, span: $span, kind: $kind, weekday: $weekday, nextQualifier: $nextQualifier, month: $month, day: $day, year: $year, first: $first, second: $second, days: $days, period: $period)';
}


}

/// @nodoc
abstract mixin class $DayCandidateCopyWith<$Res> implements $DateCandidateCopyWith<$Res> {
  factory $DayCandidateCopyWith(DayCandidate value, $Res Function(DayCandidate) _then) = _$DayCandidateCopyWithImpl;
@override @useResult
$Res call({
 String id, SourceSpan span, DayKind kind, int? weekday, bool nextQualifier, int? month, int? day, int? year, int? first, int? second, int? days, DayPeriod period
});


@override $SourceSpanCopyWith<$Res> get span;

}
/// @nodoc
class _$DayCandidateCopyWithImpl<$Res>
    implements $DayCandidateCopyWith<$Res> {
  _$DayCandidateCopyWithImpl(this._self, this._then);

  final DayCandidate _self;
  final $Res Function(DayCandidate) _then;

/// Create a copy of DateCandidate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? span = null,Object? kind = null,Object? weekday = freezed,Object? nextQualifier = null,Object? month = freezed,Object? day = freezed,Object? year = freezed,Object? first = freezed,Object? second = freezed,Object? days = freezed,Object? period = null,}) {
  return _then(DayCandidate(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == span ? _self.span : span // ignore: cast_nullable_to_non_nullable
as SourceSpan,null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DayKind,weekday: freezed == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int?,nextQualifier: null == nextQualifier ? _self.nextQualifier : nextQualifier // ignore: cast_nullable_to_non_nullable
as bool,month: freezed == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int?,day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,first: freezed == first ? _self.first : first // ignore: cast_nullable_to_non_nullable
as int?,second: freezed == second ? _self.second : second // ignore: cast_nullable_to_non_nullable
as int?,days: freezed == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int?,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as DayPeriod,
  ));
}

/// Create a copy of DateCandidate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SourceSpanCopyWith<$Res> get span {
  
  return $SourceSpanCopyWith<$Res>(_self.span, (value) {
    return _then(_self.copyWith(span: value));
  });
}
}

/// @nodoc


class TimeCandidate implements DateCandidate {
  const TimeCandidate(this.id, this.span, this.kind, {this.hour, this.minute = 0, this.minutes, this.period = DayPeriod.none});
  

@override final  String id;
@override final  SourceSpan span;
@override final  TimeKind kind;
 final  int? hour;
@JsonKey() final  int minute;
 final  int? minutes;
@override@JsonKey() final  DayPeriod period;

/// Create a copy of DateCandidate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeCandidateCopyWith<TimeCandidate> get copyWith => _$TimeCandidateCopyWithImpl<TimeCandidate>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeCandidate&&(identical(other.id, id) || other.id == id)&&(identical(other.span, span) || other.span == span)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minute, minute) || other.minute == minute)&&(identical(other.minutes, minutes) || other.minutes == minutes)&&(identical(other.period, period) || other.period == period));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,span,kind,hour,minute,minutes,period);
}

@override
String toString() {
    return 'DateCandidate.time(id: $id, span: $span, kind: $kind, hour: $hour, minute: $minute, minutes: $minutes, period: $period)';
}


}

/// @nodoc
abstract mixin class $TimeCandidateCopyWith<$Res> implements $DateCandidateCopyWith<$Res> {
  factory $TimeCandidateCopyWith(TimeCandidate value, $Res Function(TimeCandidate) _then) = _$TimeCandidateCopyWithImpl;
@override @useResult
$Res call({
 String id, SourceSpan span, TimeKind kind, int? hour, int minute, int? minutes, DayPeriod period
});


@override $SourceSpanCopyWith<$Res> get span;

}
/// @nodoc
class _$TimeCandidateCopyWithImpl<$Res>
    implements $TimeCandidateCopyWith<$Res> {
  _$TimeCandidateCopyWithImpl(this._self, this._then);

  final TimeCandidate _self;
  final $Res Function(TimeCandidate) _then;

/// Create a copy of DateCandidate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? span = null,Object? kind = null,Object? hour = freezed,Object? minute = null,Object? minutes = freezed,Object? period = null,}) {
  return _then(TimeCandidate(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == span ? _self.span : span // ignore: cast_nullable_to_non_nullable
as SourceSpan,null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TimeKind,hour: freezed == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int?,minute: null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,minutes: freezed == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int?,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as DayPeriod,
  ));
}

/// Create a copy of DateCandidate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SourceSpanCopyWith<$Res> get span {
  
  return $SourceSpanCopyWith<$Res>(_self.span, (value) {
    return _then(_self.copyWith(span: value));
  });
}
}

// dart format on
