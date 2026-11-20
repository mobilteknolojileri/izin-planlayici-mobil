// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leave_warning.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeaveWarning {

 LeaveWarningType get type;/// Values used in the sentence, e.g. `{'days': '3'}`.
 Map<String, String> get params;
/// Create a copy of LeaveWarning
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveWarningCopyWith<LeaveWarning> get copyWith => _$LeaveWarningCopyWithImpl<LeaveWarning>(this as LeaveWarning, _$identity);

  /// Serializes this LeaveWarning to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LeaveWarning;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveWarning&&(identical(other.type, _this.type) || other.type == _this.type)&&const DeepCollectionEquality().equals(other.params, _this.params));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LeaveWarning;
  return Object.hash(runtimeType,_this.type,const DeepCollectionEquality().hash(_this.params));
}

@override
String toString() {
  final _this = this as LeaveWarning;
  return 'LeaveWarning(type: ${_this.type}, params: ${_this.params})';
}


}

/// @nodoc
abstract mixin class $LeaveWarningCopyWith<$Res>  {
  factory $LeaveWarningCopyWith(LeaveWarning value, $Res Function(LeaveWarning) _then) = _$LeaveWarningCopyWithImpl;
@useResult
$Res call({
 LeaveWarningType type, Map<String, String> params
});




}
/// @nodoc
class _$LeaveWarningCopyWithImpl<$Res>
    implements $LeaveWarningCopyWith<$Res> {
  _$LeaveWarningCopyWithImpl(this._self, this._then);

  final LeaveWarning _self;
  final $Res Function(LeaveWarning) _then;

/// Create a copy of LeaveWarning
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? params = null,}) {
  return _then(LeaveWarning(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LeaveWarningType,params: null == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaveWarning].
extension LeaveWarningPatterns on LeaveWarning {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveWarning value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveWarning() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveWarning value)  $default,){
final _that = this;
switch (_that) {
case _LeaveWarning():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveWarning value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveWarning() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LeaveWarningType type,  Map<String, String> params)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveWarning() when $default != null:
return $default(_that.type,_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LeaveWarningType type,  Map<String, String> params)  $default,) {final _that = this;
switch (_that) {
case _LeaveWarning():
return $default(_that.type,_that.params);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LeaveWarningType type,  Map<String, String> params)?  $default,) {final _that = this;
switch (_that) {
case _LeaveWarning() when $default != null:
return $default(_that.type,_that.params);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaveWarning implements LeaveWarning {
  const _LeaveWarning({required this.type,  Map<String, String> params = const <String, String>{}}): _params = params;
  factory _LeaveWarning.fromJson(Map<String, dynamic> json) => _$LeaveWarningFromJson(json);

@override final  LeaveWarningType type;
/// Values used in the sentence, e.g. `{'days': '3'}`.
 final  Map<String, String> _params;
/// Values used in the sentence, e.g. `{'days': '3'}`.
@override@JsonKey() Map<String, String> get params {
  if (_params is EqualUnmodifiableMapView) return _params;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_params);
}


/// Create a copy of LeaveWarning
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveWarningCopyWith<_LeaveWarning> get copyWith => __$LeaveWarningCopyWithImpl<_LeaveWarning>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveWarningToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveWarning&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.params, _params));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,const DeepCollectionEquality().hash(_params));
}

@override
String toString() {
    return 'LeaveWarning(type: $type, params: $params)';
}


}

/// @nodoc
abstract mixin class _$LeaveWarningCopyWith<$Res> implements $LeaveWarningCopyWith<$Res> {
  factory _$LeaveWarningCopyWith(_LeaveWarning value, $Res Function(_LeaveWarning) _then) = __$LeaveWarningCopyWithImpl;
@override @useResult
$Res call({
 LeaveWarningType type, Map<String, String> params
});




}
/// @nodoc
class __$LeaveWarningCopyWithImpl<$Res>
    implements _$LeaveWarningCopyWith<$Res> {
  __$LeaveWarningCopyWithImpl(this._self, this._then);

  final _LeaveWarning _self;
  final $Res Function(_LeaveWarning) _then;

/// Create a copy of LeaveWarning
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? params = null,}) {
  return _then(_LeaveWarning(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LeaveWarningType,params: null == params ? _self._params : params // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
