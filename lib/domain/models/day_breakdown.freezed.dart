// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'day_breakdown.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DayBreakdown {

@DateOnlyConverter() DateTime get date;/// Days deducted for this date: 0, 0.5 or 1.
 double get value; DayReason get reason;/// Holiday name when [reason] relates to a holiday.
 String? get holidayName;
/// Create a copy of DayBreakdown
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayBreakdownCopyWith<DayBreakdown> get copyWith => _$DayBreakdownCopyWithImpl<DayBreakdown>(this as DayBreakdown, _$identity);

  /// Serializes this DayBreakdown to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DayBreakdown;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayBreakdown&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.value, _this.value) || other.value == _this.value)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.holidayName, _this.holidayName) || other.holidayName == _this.holidayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DayBreakdown;
  return Object.hash(runtimeType,_this.date,_this.value,_this.reason,_this.holidayName);
}

@override
String toString() {
  final _this = this as DayBreakdown;
  return 'DayBreakdown(date: ${_this.date}, value: ${_this.value}, reason: ${_this.reason}, holidayName: ${_this.holidayName})';
}


}

/// @nodoc
abstract mixin class $DayBreakdownCopyWith<$Res>  {
  factory $DayBreakdownCopyWith(DayBreakdown value, $Res Function(DayBreakdown) _then) = _$DayBreakdownCopyWithImpl;
@useResult
$Res call({
@DateOnlyConverter() DateTime date, double value, DayReason reason, String? holidayName
});




}
/// @nodoc
class _$DayBreakdownCopyWithImpl<$Res>
    implements $DayBreakdownCopyWith<$Res> {
  _$DayBreakdownCopyWithImpl(this._self, this._then);

  final DayBreakdown _self;
  final $Res Function(DayBreakdown) _then;

/// Create a copy of DayBreakdown
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? value = null,Object? reason = null,Object? holidayName = freezed,}) {
  return _then(DayBreakdown(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as DayReason,holidayName: freezed == holidayName ? _self.holidayName : holidayName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DayBreakdown].
extension DayBreakdownPatterns on DayBreakdown {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DayBreakdown value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DayBreakdown() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DayBreakdown value)  $default,){
final _that = this;
switch (_that) {
case _DayBreakdown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DayBreakdown value)?  $default,){
final _that = this;
switch (_that) {
case _DayBreakdown() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime date,  double value,  DayReason reason,  String? holidayName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DayBreakdown() when $default != null:
return $default(_that.date,_that.value,_that.reason,_that.holidayName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime date,  double value,  DayReason reason,  String? holidayName)  $default,) {final _that = this;
switch (_that) {
case _DayBreakdown():
return $default(_that.date,_that.value,_that.reason,_that.holidayName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DateOnlyConverter()  DateTime date,  double value,  DayReason reason,  String? holidayName)?  $default,) {final _that = this;
switch (_that) {
case _DayBreakdown() when $default != null:
return $default(_that.date,_that.value,_that.reason,_that.holidayName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DayBreakdown implements DayBreakdown {
  const _DayBreakdown({@DateOnlyConverter() required this.date, required this.value, required this.reason, this.holidayName});
  factory _DayBreakdown.fromJson(Map<String, dynamic> json) => _$DayBreakdownFromJson(json);

@override@DateOnlyConverter() final  DateTime date;
/// Days deducted for this date: 0, 0.5 or 1.
@override final  double value;
@override final  DayReason reason;
/// Holiday name when [reason] relates to a holiday.
@override final  String? holidayName;

/// Create a copy of DayBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayBreakdownCopyWith<_DayBreakdown> get copyWith => __$DayBreakdownCopyWithImpl<_DayBreakdown>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DayBreakdownToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DayBreakdown&&(identical(other.date, date) || other.date == date)&&(identical(other.value, value) || other.value == value)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.holidayName, holidayName) || other.holidayName == holidayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,date,value,reason,holidayName);
}

@override
String toString() {
    return 'DayBreakdown(date: $date, value: $value, reason: $reason, holidayName: $holidayName)';
}


}

/// @nodoc
abstract mixin class _$DayBreakdownCopyWith<$Res> implements $DayBreakdownCopyWith<$Res> {
  factory _$DayBreakdownCopyWith(_DayBreakdown value, $Res Function(_DayBreakdown) _then) = __$DayBreakdownCopyWithImpl;
@override @useResult
$Res call({
@DateOnlyConverter() DateTime date, double value, DayReason reason, String? holidayName
});




}
/// @nodoc
class __$DayBreakdownCopyWithImpl<$Res>
    implements _$DayBreakdownCopyWith<$Res> {
  __$DayBreakdownCopyWithImpl(this._self, this._then);

  final _DayBreakdown _self;
  final $Res Function(_DayBreakdown) _then;

/// Create a copy of DayBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? value = null,Object? reason = null,Object? holidayName = freezed,}) {
  return _then(_DayBreakdown(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as DayReason,holidayName: freezed == holidayName ? _self.holidayName : holidayName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
