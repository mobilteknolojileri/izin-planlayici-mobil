// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'year_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$YearSummary {

 int get year;/// Annual leave days earned in [year].
 double get earned;/// Annual leave days used in [year].
 double get used;/// Leave, holidays and weekends together, in calendar days.
 int get totalDaysOff;/// Days used per leave type.
 Map<LeaveType, double> get usedByType;/// Annual leave days used per month, keys 1-12.
 Map<int, double> get usedByMonth;
/// Create a copy of YearSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearSummaryCopyWith<YearSummary> get copyWith => _$YearSummaryCopyWithImpl<YearSummary>(this as YearSummary, _$identity);

  /// Serializes this YearSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as YearSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearSummary&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.earned, _this.earned) || other.earned == _this.earned)&&(identical(other.used, _this.used) || other.used == _this.used)&&(identical(other.totalDaysOff, _this.totalDaysOff) || other.totalDaysOff == _this.totalDaysOff)&&const DeepCollectionEquality().equals(other.usedByType, _this.usedByType)&&const DeepCollectionEquality().equals(other.usedByMonth, _this.usedByMonth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as YearSummary;
  return Object.hash(runtimeType,_this.year,_this.earned,_this.used,_this.totalDaysOff,const DeepCollectionEquality().hash(_this.usedByType),const DeepCollectionEquality().hash(_this.usedByMonth));
}

@override
String toString() {
  final _this = this as YearSummary;
  return 'YearSummary(year: ${_this.year}, earned: ${_this.earned}, used: ${_this.used}, totalDaysOff: ${_this.totalDaysOff}, usedByType: ${_this.usedByType}, usedByMonth: ${_this.usedByMonth})';
}


}

/// @nodoc
abstract mixin class $YearSummaryCopyWith<$Res>  {
  factory $YearSummaryCopyWith(YearSummary value, $Res Function(YearSummary) _then) = _$YearSummaryCopyWithImpl;
@useResult
$Res call({
 int year, double earned, double used, int totalDaysOff, Map<LeaveType, double> usedByType, Map<int, double> usedByMonth
});




}
/// @nodoc
class _$YearSummaryCopyWithImpl<$Res>
    implements $YearSummaryCopyWith<$Res> {
  _$YearSummaryCopyWithImpl(this._self, this._then);

  final YearSummary _self;
  final $Res Function(YearSummary) _then;

/// Create a copy of YearSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? earned = null,Object? used = null,Object? totalDaysOff = null,Object? usedByType = null,Object? usedByMonth = null,}) {
  return _then(YearSummary(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,earned: null == earned ? _self.earned : earned // ignore: cast_nullable_to_non_nullable
as double,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as double,totalDaysOff: null == totalDaysOff ? _self.totalDaysOff : totalDaysOff // ignore: cast_nullable_to_non_nullable
as int,usedByType: null == usedByType ? _self.usedByType : usedByType // ignore: cast_nullable_to_non_nullable
as Map<LeaveType, double>,usedByMonth: null == usedByMonth ? _self.usedByMonth : usedByMonth // ignore: cast_nullable_to_non_nullable
as Map<int, double>,
  ));
}

}


/// Adds pattern-matching-related methods to [YearSummary].
extension YearSummaryPatterns on YearSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearSummary value)  $default,){
final _that = this;
switch (_that) {
case _YearSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearSummary value)?  $default,){
final _that = this;
switch (_that) {
case _YearSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  double earned,  double used,  int totalDaysOff,  Map<LeaveType, double> usedByType,  Map<int, double> usedByMonth)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _YearSummary() when $default != null:
return $default(_that.year,_that.earned,_that.used,_that.totalDaysOff,_that.usedByType,_that.usedByMonth);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  double earned,  double used,  int totalDaysOff,  Map<LeaveType, double> usedByType,  Map<int, double> usedByMonth)  $default,) {final _that = this;
switch (_that) {
case _YearSummary():
return $default(_that.year,_that.earned,_that.used,_that.totalDaysOff,_that.usedByType,_that.usedByMonth);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  double earned,  double used,  int totalDaysOff,  Map<LeaveType, double> usedByType,  Map<int, double> usedByMonth)?  $default,) {final _that = this;
switch (_that) {
case _YearSummary() when $default != null:
return $default(_that.year,_that.earned,_that.used,_that.totalDaysOff,_that.usedByType,_that.usedByMonth);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _YearSummary implements YearSummary {
  const _YearSummary({required this.year, required this.earned, required this.used, required this.totalDaysOff,  Map<LeaveType, double> usedByType = const <LeaveType, double>{},  Map<int, double> usedByMonth = const <int, double>{}}): _usedByType = usedByType,_usedByMonth = usedByMonth;
  factory _YearSummary.fromJson(Map<String, dynamic> json) => _$YearSummaryFromJson(json);

@override final  int year;
/// Annual leave days earned in [year].
@override final  double earned;
/// Annual leave days used in [year].
@override final  double used;
/// Leave, holidays and weekends together, in calendar days.
@override final  int totalDaysOff;
/// Days used per leave type.
 final  Map<LeaveType, double> _usedByType;
/// Days used per leave type.
@override@JsonKey() Map<LeaveType, double> get usedByType {
  if (_usedByType is EqualUnmodifiableMapView) return _usedByType;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_usedByType);
}

/// Annual leave days used per month, keys 1-12.
 final  Map<int, double> _usedByMonth;
/// Annual leave days used per month, keys 1-12.
@override@JsonKey() Map<int, double> get usedByMonth {
  if (_usedByMonth is EqualUnmodifiableMapView) return _usedByMonth;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_usedByMonth);
}


/// Create a copy of YearSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearSummaryCopyWith<_YearSummary> get copyWith => __$YearSummaryCopyWithImpl<_YearSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YearSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearSummary&&(identical(other.year, year) || other.year == year)&&(identical(other.earned, earned) || other.earned == earned)&&(identical(other.used, used) || other.used == used)&&(identical(other.totalDaysOff, totalDaysOff) || other.totalDaysOff == totalDaysOff)&&const DeepCollectionEquality().equals(other.usedByType, _usedByType)&&const DeepCollectionEquality().equals(other.usedByMonth, _usedByMonth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,year,earned,used,totalDaysOff,const DeepCollectionEquality().hash(_usedByType),const DeepCollectionEquality().hash(_usedByMonth));
}

@override
String toString() {
    return 'YearSummary(year: $year, earned: $earned, used: $used, totalDaysOff: $totalDaysOff, usedByType: $usedByType, usedByMonth: $usedByMonth)';
}


}

/// @nodoc
abstract mixin class _$YearSummaryCopyWith<$Res> implements $YearSummaryCopyWith<$Res> {
  factory _$YearSummaryCopyWith(_YearSummary value, $Res Function(_YearSummary) _then) = __$YearSummaryCopyWithImpl;
@override @useResult
$Res call({
 int year, double earned, double used, int totalDaysOff, Map<LeaveType, double> usedByType, Map<int, double> usedByMonth
});




}
/// @nodoc
class __$YearSummaryCopyWithImpl<$Res>
    implements _$YearSummaryCopyWith<$Res> {
  __$YearSummaryCopyWithImpl(this._self, this._then);

  final _YearSummary _self;
  final $Res Function(_YearSummary) _then;

/// Create a copy of YearSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? earned = null,Object? used = null,Object? totalDaysOff = null,Object? usedByType = null,Object? usedByMonth = null,}) {
  return _then(_YearSummary(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,earned: null == earned ? _self.earned : earned // ignore: cast_nullable_to_non_nullable
as double,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as double,totalDaysOff: null == totalDaysOff ? _self.totalDaysOff : totalDaysOff // ignore: cast_nullable_to_non_nullable
as int,usedByType: null == usedByType ? _self._usedByType : usedByType // ignore: cast_nullable_to_non_nullable
as Map<LeaveType, double>,usedByMonth: null == usedByMonth ? _self._usedByMonth : usedByMonth // ignore: cast_nullable_to_non_nullable
as Map<int, double>,
  ));
}


}

// dart format on
