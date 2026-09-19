// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsState {

 Shortcut get shortcut; bool get modelReady; NotionWorkspace? get workspace;/// False until Keychain, microphone and hotkey state have been read.
 bool get loaded; bool get hasTypesafeKey; bool get hasNotionToken; bool get shortcutRegistered; ShortcutProblem? get shortcutProblem; MicPermission get mic;/// Save a finished recording to Notion without the review card when
/// nothing on it needs a decision.
 bool get autoSave;/// Latest download event while the model downloads or after it failed.
 SpeechModelEvent? get modelDownload; bool get savingKey; JevFailure? get keyFailure; bool get connecting; NotionFailure? get notionFailure; bool get pageLinkInvalid;
/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsStateCopyWith<SettingsState> get copyWith => _$SettingsStateCopyWithImpl<SettingsState>(this as SettingsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SettingsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsState&&(identical(other.shortcut, _this.shortcut) || other.shortcut == _this.shortcut)&&(identical(other.modelReady, _this.modelReady) || other.modelReady == _this.modelReady)&&(identical(other.workspace, _this.workspace) || other.workspace == _this.workspace)&&(identical(other.loaded, _this.loaded) || other.loaded == _this.loaded)&&(identical(other.hasTypesafeKey, _this.hasTypesafeKey) || other.hasTypesafeKey == _this.hasTypesafeKey)&&(identical(other.hasNotionToken, _this.hasNotionToken) || other.hasNotionToken == _this.hasNotionToken)&&(identical(other.shortcutRegistered, _this.shortcutRegistered) || other.shortcutRegistered == _this.shortcutRegistered)&&(identical(other.shortcutProblem, _this.shortcutProblem) || other.shortcutProblem == _this.shortcutProblem)&&(identical(other.mic, _this.mic) || other.mic == _this.mic)&&(identical(other.autoSave, _this.autoSave) || other.autoSave == _this.autoSave)&&(identical(other.modelDownload, _this.modelDownload) || other.modelDownload == _this.modelDownload)&&(identical(other.savingKey, _this.savingKey) || other.savingKey == _this.savingKey)&&(identical(other.keyFailure, _this.keyFailure) || other.keyFailure == _this.keyFailure)&&(identical(other.connecting, _this.connecting) || other.connecting == _this.connecting)&&(identical(other.notionFailure, _this.notionFailure) || other.notionFailure == _this.notionFailure)&&(identical(other.pageLinkInvalid, _this.pageLinkInvalid) || other.pageLinkInvalid == _this.pageLinkInvalid));
}


@override
int get hashCode {
  final _this = this as SettingsState;
  return Object.hash(runtimeType,_this.shortcut,_this.modelReady,_this.workspace,_this.loaded,_this.hasTypesafeKey,_this.hasNotionToken,_this.shortcutRegistered,_this.shortcutProblem,_this.mic,_this.autoSave,_this.modelDownload,_this.savingKey,_this.keyFailure,_this.connecting,_this.notionFailure,_this.pageLinkInvalid);
}

@override
String toString() {
  final _this = this as SettingsState;
  return 'SettingsState(shortcut: ${_this.shortcut}, modelReady: ${_this.modelReady}, workspace: ${_this.workspace}, loaded: ${_this.loaded}, hasTypesafeKey: ${_this.hasTypesafeKey}, hasNotionToken: ${_this.hasNotionToken}, shortcutRegistered: ${_this.shortcutRegistered}, shortcutProblem: ${_this.shortcutProblem}, mic: ${_this.mic}, autoSave: ${_this.autoSave}, modelDownload: ${_this.modelDownload}, savingKey: ${_this.savingKey}, keyFailure: ${_this.keyFailure}, connecting: ${_this.connecting}, notionFailure: ${_this.notionFailure}, pageLinkInvalid: ${_this.pageLinkInvalid})';
}


}

/// @nodoc
abstract mixin class $SettingsStateCopyWith<$Res>  {
  factory $SettingsStateCopyWith(SettingsState value, $Res Function(SettingsState) _then) = _$SettingsStateCopyWithImpl;
@useResult
$Res call({
 Shortcut shortcut, bool modelReady, NotionWorkspace? workspace, bool loaded, bool hasTypesafeKey, bool hasNotionToken, bool shortcutRegistered, ShortcutProblem? shortcutProblem, MicPermission mic, bool autoSave, SpeechModelEvent? modelDownload, bool savingKey, JevFailure? keyFailure, bool connecting, NotionFailure? notionFailure, bool pageLinkInvalid
});


$ShortcutCopyWith<$Res> get shortcut;$NotionWorkspaceCopyWith<$Res>? get workspace;$SpeechModelEventCopyWith<$Res>? get modelDownload;

}
/// @nodoc
class _$SettingsStateCopyWithImpl<$Res>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._self, this._then);

  final SettingsState _self;
  final $Res Function(SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shortcut = null,Object? modelReady = null,Object? workspace = freezed,Object? loaded = null,Object? hasTypesafeKey = null,Object? hasNotionToken = null,Object? shortcutRegistered = null,Object? shortcutProblem = freezed,Object? mic = null,Object? autoSave = null,Object? modelDownload = freezed,Object? savingKey = null,Object? keyFailure = freezed,Object? connecting = null,Object? notionFailure = freezed,Object? pageLinkInvalid = null,}) {
  return _then(SettingsState(
shortcut: null == shortcut ? _self.shortcut : shortcut // ignore: cast_nullable_to_non_nullable
as Shortcut,modelReady: null == modelReady ? _self.modelReady : modelReady // ignore: cast_nullable_to_non_nullable
as bool,workspace: freezed == workspace ? _self.workspace : workspace // ignore: cast_nullable_to_non_nullable
as NotionWorkspace?,loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,hasTypesafeKey: null == hasTypesafeKey ? _self.hasTypesafeKey : hasTypesafeKey // ignore: cast_nullable_to_non_nullable
as bool,hasNotionToken: null == hasNotionToken ? _self.hasNotionToken : hasNotionToken // ignore: cast_nullable_to_non_nullable
as bool,shortcutRegistered: null == shortcutRegistered ? _self.shortcutRegistered : shortcutRegistered // ignore: cast_nullable_to_non_nullable
as bool,shortcutProblem: freezed == shortcutProblem ? _self.shortcutProblem : shortcutProblem // ignore: cast_nullable_to_non_nullable
as ShortcutProblem?,mic: null == mic ? _self.mic : mic // ignore: cast_nullable_to_non_nullable
as MicPermission,autoSave: null == autoSave ? _self.autoSave : autoSave // ignore: cast_nullable_to_non_nullable
as bool,modelDownload: freezed == modelDownload ? _self.modelDownload : modelDownload // ignore: cast_nullable_to_non_nullable
as SpeechModelEvent?,savingKey: null == savingKey ? _self.savingKey : savingKey // ignore: cast_nullable_to_non_nullable
as bool,keyFailure: freezed == keyFailure ? _self.keyFailure : keyFailure // ignore: cast_nullable_to_non_nullable
as JevFailure?,connecting: null == connecting ? _self.connecting : connecting // ignore: cast_nullable_to_non_nullable
as bool,notionFailure: freezed == notionFailure ? _self.notionFailure : notionFailure // ignore: cast_nullable_to_non_nullable
as NotionFailure?,pageLinkInvalid: null == pageLinkInvalid ? _self.pageLinkInvalid : pageLinkInvalid // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShortcutCopyWith<$Res> get shortcut {
  
  return $ShortcutCopyWith<$Res>(_self.shortcut, (value) {
    return _then(_self.copyWith(shortcut: value));
  });
}/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotionWorkspaceCopyWith<$Res>? get workspace {
    if (_self.workspace == null) {
    return null;
  }

  return $NotionWorkspaceCopyWith<$Res>(_self.workspace!, (value) {
    return _then(_self.copyWith(workspace: value));
  });
}/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpeechModelEventCopyWith<$Res>? get modelDownload {
    if (_self.modelDownload == null) {
    return null;
  }

  return $SpeechModelEventCopyWith<$Res>(_self.modelDownload!, (value) {
    return _then(_self.copyWith(modelDownload: value));
  });
}
}


/// Adds pattern-matching-related methods to [SettingsState].
extension SettingsStatePatterns on SettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsState value)  $default,){
final _that = this;
switch (_that) {
case _SettingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Shortcut shortcut,  bool modelReady,  NotionWorkspace? workspace,  bool loaded,  bool hasTypesafeKey,  bool hasNotionToken,  bool shortcutRegistered,  ShortcutProblem? shortcutProblem,  MicPermission mic,  bool autoSave,  SpeechModelEvent? modelDownload,  bool savingKey,  JevFailure? keyFailure,  bool connecting,  NotionFailure? notionFailure,  bool pageLinkInvalid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.shortcut,_that.modelReady,_that.workspace,_that.loaded,_that.hasTypesafeKey,_that.hasNotionToken,_that.shortcutRegistered,_that.shortcutProblem,_that.mic,_that.autoSave,_that.modelDownload,_that.savingKey,_that.keyFailure,_that.connecting,_that.notionFailure,_that.pageLinkInvalid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Shortcut shortcut,  bool modelReady,  NotionWorkspace? workspace,  bool loaded,  bool hasTypesafeKey,  bool hasNotionToken,  bool shortcutRegistered,  ShortcutProblem? shortcutProblem,  MicPermission mic,  bool autoSave,  SpeechModelEvent? modelDownload,  bool savingKey,  JevFailure? keyFailure,  bool connecting,  NotionFailure? notionFailure,  bool pageLinkInvalid)  $default,) {final _that = this;
switch (_that) {
case _SettingsState():
return $default(_that.shortcut,_that.modelReady,_that.workspace,_that.loaded,_that.hasTypesafeKey,_that.hasNotionToken,_that.shortcutRegistered,_that.shortcutProblem,_that.mic,_that.autoSave,_that.modelDownload,_that.savingKey,_that.keyFailure,_that.connecting,_that.notionFailure,_that.pageLinkInvalid);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Shortcut shortcut,  bool modelReady,  NotionWorkspace? workspace,  bool loaded,  bool hasTypesafeKey,  bool hasNotionToken,  bool shortcutRegistered,  ShortcutProblem? shortcutProblem,  MicPermission mic,  bool autoSave,  SpeechModelEvent? modelDownload,  bool savingKey,  JevFailure? keyFailure,  bool connecting,  NotionFailure? notionFailure,  bool pageLinkInvalid)?  $default,) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.shortcut,_that.modelReady,_that.workspace,_that.loaded,_that.hasTypesafeKey,_that.hasNotionToken,_that.shortcutRegistered,_that.shortcutProblem,_that.mic,_that.autoSave,_that.modelDownload,_that.savingKey,_that.keyFailure,_that.connecting,_that.notionFailure,_that.pageLinkInvalid);case _:
  return null;

}
}

}

/// @nodoc


class _SettingsState extends SettingsState {
  const _SettingsState({required this.shortcut, required this.modelReady, this.workspace, this.loaded = false, this.hasTypesafeKey = false, this.hasNotionToken = false, this.shortcutRegistered = false, this.shortcutProblem, this.mic = MicPermission.undetermined, this.autoSave = false, this.modelDownload, this.savingKey = false, this.keyFailure, this.connecting = false, this.notionFailure, this.pageLinkInvalid = false}): super._();
  

@override final  Shortcut shortcut;
@override final  bool modelReady;
@override final  NotionWorkspace? workspace;
/// False until Keychain, microphone and hotkey state have been read.
@override@JsonKey() final  bool loaded;
@override@JsonKey() final  bool hasTypesafeKey;
@override@JsonKey() final  bool hasNotionToken;
@override@JsonKey() final  bool shortcutRegistered;
@override final  ShortcutProblem? shortcutProblem;
@override@JsonKey() final  MicPermission mic;
/// Save a finished recording to Notion without the review card when
/// nothing on it needs a decision.
@override@JsonKey() final  bool autoSave;
/// Latest download event while the model downloads or after it failed.
@override final  SpeechModelEvent? modelDownload;
@override@JsonKey() final  bool savingKey;
@override final  JevFailure? keyFailure;
@override@JsonKey() final  bool connecting;
@override final  NotionFailure? notionFailure;
@override@JsonKey() final  bool pageLinkInvalid;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsStateCopyWith<_SettingsState> get copyWith => __$SettingsStateCopyWithImpl<_SettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsState&&(identical(other.shortcut, shortcut) || other.shortcut == shortcut)&&(identical(other.modelReady, modelReady) || other.modelReady == modelReady)&&(identical(other.workspace, workspace) || other.workspace == workspace)&&(identical(other.loaded, loaded) || other.loaded == loaded)&&(identical(other.hasTypesafeKey, hasTypesafeKey) || other.hasTypesafeKey == hasTypesafeKey)&&(identical(other.hasNotionToken, hasNotionToken) || other.hasNotionToken == hasNotionToken)&&(identical(other.shortcutRegistered, shortcutRegistered) || other.shortcutRegistered == shortcutRegistered)&&(identical(other.shortcutProblem, shortcutProblem) || other.shortcutProblem == shortcutProblem)&&(identical(other.mic, mic) || other.mic == mic)&&(identical(other.autoSave, autoSave) || other.autoSave == autoSave)&&(identical(other.modelDownload, modelDownload) || other.modelDownload == modelDownload)&&(identical(other.savingKey, savingKey) || other.savingKey == savingKey)&&(identical(other.keyFailure, keyFailure) || other.keyFailure == keyFailure)&&(identical(other.connecting, connecting) || other.connecting == connecting)&&(identical(other.notionFailure, notionFailure) || other.notionFailure == notionFailure)&&(identical(other.pageLinkInvalid, pageLinkInvalid) || other.pageLinkInvalid == pageLinkInvalid));
}


@override
int get hashCode {
    return Object.hash(runtimeType,shortcut,modelReady,workspace,loaded,hasTypesafeKey,hasNotionToken,shortcutRegistered,shortcutProblem,mic,autoSave,modelDownload,savingKey,keyFailure,connecting,notionFailure,pageLinkInvalid);
}

@override
String toString() {
    return 'SettingsState(shortcut: $shortcut, modelReady: $modelReady, workspace: $workspace, loaded: $loaded, hasTypesafeKey: $hasTypesafeKey, hasNotionToken: $hasNotionToken, shortcutRegistered: $shortcutRegistered, shortcutProblem: $shortcutProblem, mic: $mic, autoSave: $autoSave, modelDownload: $modelDownload, savingKey: $savingKey, keyFailure: $keyFailure, connecting: $connecting, notionFailure: $notionFailure, pageLinkInvalid: $pageLinkInvalid)';
}


}

/// @nodoc
abstract mixin class _$SettingsStateCopyWith<$Res> implements $SettingsStateCopyWith<$Res> {
  factory _$SettingsStateCopyWith(_SettingsState value, $Res Function(_SettingsState) _then) = __$SettingsStateCopyWithImpl;
@override @useResult
$Res call({
 Shortcut shortcut, bool modelReady, NotionWorkspace? workspace, bool loaded, bool hasTypesafeKey, bool hasNotionToken, bool shortcutRegistered, ShortcutProblem? shortcutProblem, MicPermission mic, bool autoSave, SpeechModelEvent? modelDownload, bool savingKey, JevFailure? keyFailure, bool connecting, NotionFailure? notionFailure, bool pageLinkInvalid
});


@override $ShortcutCopyWith<$Res> get shortcut;@override $NotionWorkspaceCopyWith<$Res>? get workspace;@override $SpeechModelEventCopyWith<$Res>? get modelDownload;

}
/// @nodoc
class __$SettingsStateCopyWithImpl<$Res>
    implements _$SettingsStateCopyWith<$Res> {
  __$SettingsStateCopyWithImpl(this._self, this._then);

  final _SettingsState _self;
  final $Res Function(_SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shortcut = null,Object? modelReady = null,Object? workspace = freezed,Object? loaded = null,Object? hasTypesafeKey = null,Object? hasNotionToken = null,Object? shortcutRegistered = null,Object? shortcutProblem = freezed,Object? mic = null,Object? autoSave = null,Object? modelDownload = freezed,Object? savingKey = null,Object? keyFailure = freezed,Object? connecting = null,Object? notionFailure = freezed,Object? pageLinkInvalid = null,}) {
  return _then(_SettingsState(
shortcut: null == shortcut ? _self.shortcut : shortcut // ignore: cast_nullable_to_non_nullable
as Shortcut,modelReady: null == modelReady ? _self.modelReady : modelReady // ignore: cast_nullable_to_non_nullable
as bool,workspace: freezed == workspace ? _self.workspace : workspace // ignore: cast_nullable_to_non_nullable
as NotionWorkspace?,loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,hasTypesafeKey: null == hasTypesafeKey ? _self.hasTypesafeKey : hasTypesafeKey // ignore: cast_nullable_to_non_nullable
as bool,hasNotionToken: null == hasNotionToken ? _self.hasNotionToken : hasNotionToken // ignore: cast_nullable_to_non_nullable
as bool,shortcutRegistered: null == shortcutRegistered ? _self.shortcutRegistered : shortcutRegistered // ignore: cast_nullable_to_non_nullable
as bool,shortcutProblem: freezed == shortcutProblem ? _self.shortcutProblem : shortcutProblem // ignore: cast_nullable_to_non_nullable
as ShortcutProblem?,mic: null == mic ? _self.mic : mic // ignore: cast_nullable_to_non_nullable
as MicPermission,autoSave: null == autoSave ? _self.autoSave : autoSave // ignore: cast_nullable_to_non_nullable
as bool,modelDownload: freezed == modelDownload ? _self.modelDownload : modelDownload // ignore: cast_nullable_to_non_nullable
as SpeechModelEvent?,savingKey: null == savingKey ? _self.savingKey : savingKey // ignore: cast_nullable_to_non_nullable
as bool,keyFailure: freezed == keyFailure ? _self.keyFailure : keyFailure // ignore: cast_nullable_to_non_nullable
as JevFailure?,connecting: null == connecting ? _self.connecting : connecting // ignore: cast_nullable_to_non_nullable
as bool,notionFailure: freezed == notionFailure ? _self.notionFailure : notionFailure // ignore: cast_nullable_to_non_nullable
as NotionFailure?,pageLinkInvalid: null == pageLinkInvalid ? _self.pageLinkInvalid : pageLinkInvalid // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShortcutCopyWith<$Res> get shortcut {
  
  return $ShortcutCopyWith<$Res>(_self.shortcut, (value) {
    return _then(_self.copyWith(shortcut: value));
  });
}/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotionWorkspaceCopyWith<$Res>? get workspace {
    if (_self.workspace == null) {
    return null;
  }

  return $NotionWorkspaceCopyWith<$Res>(_self.workspace!, (value) {
    return _then(_self.copyWith(workspace: value));
  });
}/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpeechModelEventCopyWith<$Res>? get modelDownload {
    if (_self.modelDownload == null) {
    return null;
  }

  return $SpeechModelEventCopyWith<$Res>(_self.modelDownload!, (value) {
    return _then(_self.copyWith(modelDownload: value));
  });
}
}

// dart format on
