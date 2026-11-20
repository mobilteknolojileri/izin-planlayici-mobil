// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'next_accrual.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NextAccrual {

@DateOnlyConverter() DateTime get date; int get days;
/// Create a copy of NextAccrual
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NextAccrualCopyWith<NextAccrual> get copyWith => _$NextAccrualCopyWithImpl<NextAccrual>(this as NextAccrual, _$identity);

  /// Serializes this NextAccrual to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NextAccrual;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NextAccrual&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.days, _this.days) || other.days == _this.days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NextAccrual;
  return Object.hash(runtimeType,_this.date,_this.days);
}

@override
String toString() {
  final _this = this as NextAccrual;
  return 'NextAccrual(date: ${_this.date}, days: ${_this.days})';
}


}

/// @nodoc
abstract mixin class $NextAccrualCopyWith<$Res>  {
  factory $NextAccrualCopyWith(NextAccrual value, $Res Function(NextAccrual) _then) = _$NextAccrualCopyWithImpl;
@useResult
$Res call({
@DateOnlyConverter() DateTime date, int days
});




}
/// @nodoc
class _$NextAccrualCopyWithImpl<$Res>
    implements $NextAccrualCopyWith<$Res> {
  _$NextAccrualCopyWithImpl(this._self, this._then);

  final NextAccrual _self;
  final $Res Function(NextAccrual) _then;

/// Create a copy of NextAccrual
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? days = null,}) {
  return _then(NextAccrual(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NextAccrual].
extension NextAccrualPatterns on NextAccrual {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NextAccrual value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NextAccrual() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NextAccrual value)  $default,){
final _that = this;
switch (_that) {
case _NextAccrual():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NextAccrual value)?  $default,){
final _that = this;
switch (_that) {
case _NextAccrual() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime date,  int days)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NextAccrual() when $default != null:
return $default(_that.date,_that.days);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime date,  int days)  $default,) {final _that = this;
switch (_that) {
case _NextAccrual():
return $default(_that.date,_that.days);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DateOnlyConverter()  DateTime date,  int days)?  $default,) {final _that = this;
switch (_that) {
case _NextAccrual() when $default != null:
return $default(_that.date,_that.days);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NextAccrual implements NextAccrual {
  const _NextAccrual({@DateOnlyConverter() required this.date, required this.days});
  factory _NextAccrual.fromJson(Map<String, dynamic> json) => _$NextAccrualFromJson(json);

@override@DateOnlyConverter() final  DateTime date;
@override final  int days;

/// Create a copy of NextAccrual
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NextAccrualCopyWith<_NextAccrual> get copyWith => __$NextAccrualCopyWithImpl<_NextAccrual>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NextAccrualToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NextAccrual&&(identical(other.date, date) || other.date == date)&&(identical(other.days, days) || other.days == days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,date,days);
}

@override
String toString() {
    return 'NextAccrual(date: $date, days: $days)';
}


}

/// @nodoc
abstract mixin class _$NextAccrualCopyWith<$Res> implements $NextAccrualCopyWith<$Res> {
  factory _$NextAccrualCopyWith(_NextAccrual value, $Res Function(_NextAccrual) _then) = __$NextAccrualCopyWithImpl;
@override @useResult
$Res call({
@DateOnlyConverter() DateTime date, int days
});




}
/// @nodoc
class __$NextAccrualCopyWithImpl<$Res>
    implements _$NextAccrualCopyWith<$Res> {
  __$NextAccrualCopyWithImpl(this._self, this._then);

  final _NextAccrual _self;
  final $Res Function(_NextAccrual) _then;

/// Create a copy of NextAccrual
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? days = null,}) {
  return _then(_NextAccrual(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
