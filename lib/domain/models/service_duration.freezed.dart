// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_duration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServiceDuration {

 int get years; int get months; int get days;
/// Create a copy of ServiceDuration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceDurationCopyWith<ServiceDuration> get copyWith => _$ServiceDurationCopyWithImpl<ServiceDuration>(this as ServiceDuration, _$identity);

  /// Serializes this ServiceDuration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ServiceDuration;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceDuration&&(identical(other.years, _this.years) || other.years == _this.years)&&(identical(other.months, _this.months) || other.months == _this.months)&&(identical(other.days, _this.days) || other.days == _this.days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ServiceDuration;
  return Object.hash(runtimeType,_this.years,_this.months,_this.days);
}

@override
String toString() {
  final _this = this as ServiceDuration;
  return 'ServiceDuration(years: ${_this.years}, months: ${_this.months}, days: ${_this.days})';
}


}

/// @nodoc
abstract mixin class $ServiceDurationCopyWith<$Res>  {
  factory $ServiceDurationCopyWith(ServiceDuration value, $Res Function(ServiceDuration) _then) = _$ServiceDurationCopyWithImpl;
@useResult
$Res call({
 int years, int months, int days
});




}
/// @nodoc
class _$ServiceDurationCopyWithImpl<$Res>
    implements $ServiceDurationCopyWith<$Res> {
  _$ServiceDurationCopyWithImpl(this._self, this._then);

  final ServiceDuration _self;
  final $Res Function(ServiceDuration) _then;

/// Create a copy of ServiceDuration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? years = null,Object? months = null,Object? days = null,}) {
  return _then(ServiceDuration(
years: null == years ? _self.years : years // ignore: cast_nullable_to_non_nullable
as int,months: null == months ? _self.months : months // ignore: cast_nullable_to_non_nullable
as int,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceDuration].
extension ServiceDurationPatterns on ServiceDuration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceDuration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceDuration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceDuration value)  $default,){
final _that = this;
switch (_that) {
case _ServiceDuration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceDuration value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceDuration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int years,  int months,  int days)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceDuration() when $default != null:
return $default(_that.years,_that.months,_that.days);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int years,  int months,  int days)  $default,) {final _that = this;
switch (_that) {
case _ServiceDuration():
return $default(_that.years,_that.months,_that.days);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int years,  int months,  int days)?  $default,) {final _that = this;
switch (_that) {
case _ServiceDuration() when $default != null:
return $default(_that.years,_that.months,_that.days);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServiceDuration implements ServiceDuration {
  const _ServiceDuration({this.years = 0, this.months = 0, this.days = 0});
  factory _ServiceDuration.fromJson(Map<String, dynamic> json) => _$ServiceDurationFromJson(json);

@override@JsonKey() final  int years;
@override@JsonKey() final  int months;
@override@JsonKey() final  int days;

/// Create a copy of ServiceDuration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceDurationCopyWith<_ServiceDuration> get copyWith => __$ServiceDurationCopyWithImpl<_ServiceDuration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServiceDurationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceDuration&&(identical(other.years, years) || other.years == years)&&(identical(other.months, months) || other.months == months)&&(identical(other.days, days) || other.days == days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,years,months,days);
}

@override
String toString() {
    return 'ServiceDuration(years: $years, months: $months, days: $days)';
}


}

/// @nodoc
abstract mixin class _$ServiceDurationCopyWith<$Res> implements $ServiceDurationCopyWith<$Res> {
  factory _$ServiceDurationCopyWith(_ServiceDuration value, $Res Function(_ServiceDuration) _then) = __$ServiceDurationCopyWithImpl;
@override @useResult
$Res call({
 int years, int months, int days
});




}
/// @nodoc
class __$ServiceDurationCopyWithImpl<$Res>
    implements _$ServiceDurationCopyWith<$Res> {
  __$ServiceDurationCopyWithImpl(this._self, this._then);

  final _ServiceDuration _self;
  final $Res Function(_ServiceDuration) _then;

/// Create a copy of ServiceDuration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? years = null,Object? months = null,Object? days = null,}) {
  return _then(_ServiceDuration(
years: null == years ? _self.years : years // ignore: cast_nullable_to_non_nullable
as int,months: null == months ? _self.months : months // ignore: cast_nullable_to_non_nullable
as int,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
