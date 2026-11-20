// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leave_balance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeaveBalance {

 double get earned; double get used; double get planned; double get remaining;/// Days dropped at year end if unused (657 only, otherwise 0).
 double get expiringAtYearEnd;
/// Create a copy of LeaveBalance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveBalanceCopyWith<LeaveBalance> get copyWith => _$LeaveBalanceCopyWithImpl<LeaveBalance>(this as LeaveBalance, _$identity);

  /// Serializes this LeaveBalance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LeaveBalance;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveBalance&&(identical(other.earned, _this.earned) || other.earned == _this.earned)&&(identical(other.used, _this.used) || other.used == _this.used)&&(identical(other.planned, _this.planned) || other.planned == _this.planned)&&(identical(other.remaining, _this.remaining) || other.remaining == _this.remaining)&&(identical(other.expiringAtYearEnd, _this.expiringAtYearEnd) || other.expiringAtYearEnd == _this.expiringAtYearEnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LeaveBalance;
  return Object.hash(runtimeType,_this.earned,_this.used,_this.planned,_this.remaining,_this.expiringAtYearEnd);
}

@override
String toString() {
  final _this = this as LeaveBalance;
  return 'LeaveBalance(earned: ${_this.earned}, used: ${_this.used}, planned: ${_this.planned}, remaining: ${_this.remaining}, expiringAtYearEnd: ${_this.expiringAtYearEnd})';
}


}

/// @nodoc
abstract mixin class $LeaveBalanceCopyWith<$Res>  {
  factory $LeaveBalanceCopyWith(LeaveBalance value, $Res Function(LeaveBalance) _then) = _$LeaveBalanceCopyWithImpl;
@useResult
$Res call({
 double earned, double used, double planned, double remaining, double expiringAtYearEnd
});




}
/// @nodoc
class _$LeaveBalanceCopyWithImpl<$Res>
    implements $LeaveBalanceCopyWith<$Res> {
  _$LeaveBalanceCopyWithImpl(this._self, this._then);

  final LeaveBalance _self;
  final $Res Function(LeaveBalance) _then;

/// Create a copy of LeaveBalance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? earned = null,Object? used = null,Object? planned = null,Object? remaining = null,Object? expiringAtYearEnd = null,}) {
  return _then(LeaveBalance(
earned: null == earned ? _self.earned : earned // ignore: cast_nullable_to_non_nullable
as double,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as double,planned: null == planned ? _self.planned : planned // ignore: cast_nullable_to_non_nullable
as double,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as double,expiringAtYearEnd: null == expiringAtYearEnd ? _self.expiringAtYearEnd : expiringAtYearEnd // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaveBalance].
extension LeaveBalancePatterns on LeaveBalance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveBalance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveBalance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveBalance value)  $default,){
final _that = this;
switch (_that) {
case _LeaveBalance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveBalance value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveBalance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double earned,  double used,  double planned,  double remaining,  double expiringAtYearEnd)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveBalance() when $default != null:
return $default(_that.earned,_that.used,_that.planned,_that.remaining,_that.expiringAtYearEnd);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double earned,  double used,  double planned,  double remaining,  double expiringAtYearEnd)  $default,) {final _that = this;
switch (_that) {
case _LeaveBalance():
return $default(_that.earned,_that.used,_that.planned,_that.remaining,_that.expiringAtYearEnd);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double earned,  double used,  double planned,  double remaining,  double expiringAtYearEnd)?  $default,) {final _that = this;
switch (_that) {
case _LeaveBalance() when $default != null:
return $default(_that.earned,_that.used,_that.planned,_that.remaining,_that.expiringAtYearEnd);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaveBalance implements LeaveBalance {
  const _LeaveBalance({required this.earned, required this.used, required this.planned, required this.remaining, this.expiringAtYearEnd = 0});
  factory _LeaveBalance.fromJson(Map<String, dynamic> json) => _$LeaveBalanceFromJson(json);

@override final  double earned;
@override final  double used;
@override final  double planned;
@override final  double remaining;
/// Days dropped at year end if unused (657 only, otherwise 0).
@override@JsonKey() final  double expiringAtYearEnd;

/// Create a copy of LeaveBalance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveBalanceCopyWith<_LeaveBalance> get copyWith => __$LeaveBalanceCopyWithImpl<_LeaveBalance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveBalanceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveBalance&&(identical(other.earned, earned) || other.earned == earned)&&(identical(other.used, used) || other.used == used)&&(identical(other.planned, planned) || other.planned == planned)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.expiringAtYearEnd, expiringAtYearEnd) || other.expiringAtYearEnd == expiringAtYearEnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,earned,used,planned,remaining,expiringAtYearEnd);
}

@override
String toString() {
    return 'LeaveBalance(earned: $earned, used: $used, planned: $planned, remaining: $remaining, expiringAtYearEnd: $expiringAtYearEnd)';
}


}

/// @nodoc
abstract mixin class _$LeaveBalanceCopyWith<$Res> implements $LeaveBalanceCopyWith<$Res> {
  factory _$LeaveBalanceCopyWith(_LeaveBalance value, $Res Function(_LeaveBalance) _then) = __$LeaveBalanceCopyWithImpl;
@override @useResult
$Res call({
 double earned, double used, double planned, double remaining, double expiringAtYearEnd
});




}
/// @nodoc
class __$LeaveBalanceCopyWithImpl<$Res>
    implements _$LeaveBalanceCopyWith<$Res> {
  __$LeaveBalanceCopyWithImpl(this._self, this._then);

  final _LeaveBalance _self;
  final $Res Function(_LeaveBalance) _then;

/// Create a copy of LeaveBalance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? earned = null,Object? used = null,Object? planned = null,Object? remaining = null,Object? expiringAtYearEnd = null,}) {
  return _then(_LeaveBalance(
earned: null == earned ? _self.earned : earned // ignore: cast_nullable_to_non_nullable
as double,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as double,planned: null == planned ? _self.planned : planned // ignore: cast_nullable_to_non_nullable
as double,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as double,expiringAtYearEnd: null == expiringAtYearEnd ? _self.expiringAtYearEnd : expiringAtYearEnd // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
