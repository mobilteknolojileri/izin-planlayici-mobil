// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entitlement_period.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EntitlementPeriod {

/// Day the right is earned.
@DateOnlyConverter() DateTime get accrualDate;/// Days earned on [accrualDate].
 int get days;/// Calendar year the right belongs to (657), or null for 4857.
 int? get calendarYear;/// Day the unused part is dropped (657 art. 103), or null if never.
@DateOnlyConverter() DateTime? get expiresOn; List<AppliedRule> get rules;
/// Create a copy of EntitlementPeriod
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EntitlementPeriodCopyWith<EntitlementPeriod> get copyWith => _$EntitlementPeriodCopyWithImpl<EntitlementPeriod>(this as EntitlementPeriod, _$identity);

  /// Serializes this EntitlementPeriod to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EntitlementPeriod;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EntitlementPeriod&&(identical(other.accrualDate, _this.accrualDate) || other.accrualDate == _this.accrualDate)&&(identical(other.days, _this.days) || other.days == _this.days)&&(identical(other.calendarYear, _this.calendarYear) || other.calendarYear == _this.calendarYear)&&(identical(other.expiresOn, _this.expiresOn) || other.expiresOn == _this.expiresOn)&&const DeepCollectionEquality().equals(other.rules, _this.rules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EntitlementPeriod;
  return Object.hash(runtimeType,_this.accrualDate,_this.days,_this.calendarYear,_this.expiresOn,const DeepCollectionEquality().hash(_this.rules));
}

@override
String toString() {
  final _this = this as EntitlementPeriod;
  return 'EntitlementPeriod(accrualDate: ${_this.accrualDate}, days: ${_this.days}, calendarYear: ${_this.calendarYear}, expiresOn: ${_this.expiresOn}, rules: ${_this.rules})';
}


}

/// @nodoc
abstract mixin class $EntitlementPeriodCopyWith<$Res>  {
  factory $EntitlementPeriodCopyWith(EntitlementPeriod value, $Res Function(EntitlementPeriod) _then) = _$EntitlementPeriodCopyWithImpl;
@useResult
$Res call({
@DateOnlyConverter() DateTime accrualDate, int days, int? calendarYear,@DateOnlyConverter() DateTime? expiresOn, List<AppliedRule> rules
});




}
/// @nodoc
class _$EntitlementPeriodCopyWithImpl<$Res>
    implements $EntitlementPeriodCopyWith<$Res> {
  _$EntitlementPeriodCopyWithImpl(this._self, this._then);

  final EntitlementPeriod _self;
  final $Res Function(EntitlementPeriod) _then;

/// Create a copy of EntitlementPeriod
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accrualDate = null,Object? days = null,Object? calendarYear = freezed,Object? expiresOn = freezed,Object? rules = null,}) {
  return _then(EntitlementPeriod(
accrualDate: null == accrualDate ? _self.accrualDate : accrualDate // ignore: cast_nullable_to_non_nullable
as DateTime,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,calendarYear: freezed == calendarYear ? _self.calendarYear : calendarYear // ignore: cast_nullable_to_non_nullable
as int?,expiresOn: freezed == expiresOn ? _self.expiresOn : expiresOn // ignore: cast_nullable_to_non_nullable
as DateTime?,rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as List<AppliedRule>,
  ));
}

}


/// Adds pattern-matching-related methods to [EntitlementPeriod].
extension EntitlementPeriodPatterns on EntitlementPeriod {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EntitlementPeriod value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EntitlementPeriod() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EntitlementPeriod value)  $default,){
final _that = this;
switch (_that) {
case _EntitlementPeriod():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EntitlementPeriod value)?  $default,){
final _that = this;
switch (_that) {
case _EntitlementPeriod() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime accrualDate,  int days,  int? calendarYear, @DateOnlyConverter()  DateTime? expiresOn,  List<AppliedRule> rules)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EntitlementPeriod() when $default != null:
return $default(_that.accrualDate,_that.days,_that.calendarYear,_that.expiresOn,_that.rules);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime accrualDate,  int days,  int? calendarYear, @DateOnlyConverter()  DateTime? expiresOn,  List<AppliedRule> rules)  $default,) {final _that = this;
switch (_that) {
case _EntitlementPeriod():
return $default(_that.accrualDate,_that.days,_that.calendarYear,_that.expiresOn,_that.rules);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DateOnlyConverter()  DateTime accrualDate,  int days,  int? calendarYear, @DateOnlyConverter()  DateTime? expiresOn,  List<AppliedRule> rules)?  $default,) {final _that = this;
switch (_that) {
case _EntitlementPeriod() when $default != null:
return $default(_that.accrualDate,_that.days,_that.calendarYear,_that.expiresOn,_that.rules);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EntitlementPeriod implements EntitlementPeriod {
  const _EntitlementPeriod({@DateOnlyConverter() required this.accrualDate, required this.days, this.calendarYear, @DateOnlyConverter() this.expiresOn,  List<AppliedRule> rules = const <AppliedRule>[]}): _rules = rules;
  factory _EntitlementPeriod.fromJson(Map<String, dynamic> json) => _$EntitlementPeriodFromJson(json);

/// Day the right is earned.
@override@DateOnlyConverter() final  DateTime accrualDate;
/// Days earned on [accrualDate].
@override final  int days;
/// Calendar year the right belongs to (657), or null for 4857.
@override final  int? calendarYear;
/// Day the unused part is dropped (657 art. 103), or null if never.
@override@DateOnlyConverter() final  DateTime? expiresOn;
 final  List<AppliedRule> _rules;
@override@JsonKey() List<AppliedRule> get rules {
  if (_rules is EqualUnmodifiableListView) return _rules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rules);
}


/// Create a copy of EntitlementPeriod
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EntitlementPeriodCopyWith<_EntitlementPeriod> get copyWith => __$EntitlementPeriodCopyWithImpl<_EntitlementPeriod>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EntitlementPeriodToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EntitlementPeriod&&(identical(other.accrualDate, accrualDate) || other.accrualDate == accrualDate)&&(identical(other.days, days) || other.days == days)&&(identical(other.calendarYear, calendarYear) || other.calendarYear == calendarYear)&&(identical(other.expiresOn, expiresOn) || other.expiresOn == expiresOn)&&const DeepCollectionEquality().equals(other.rules, _rules));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accrualDate,days,calendarYear,expiresOn,const DeepCollectionEquality().hash(_rules));
}

@override
String toString() {
    return 'EntitlementPeriod(accrualDate: $accrualDate, days: $days, calendarYear: $calendarYear, expiresOn: $expiresOn, rules: $rules)';
}


}

/// @nodoc
abstract mixin class _$EntitlementPeriodCopyWith<$Res> implements $EntitlementPeriodCopyWith<$Res> {
  factory _$EntitlementPeriodCopyWith(_EntitlementPeriod value, $Res Function(_EntitlementPeriod) _then) = __$EntitlementPeriodCopyWithImpl;
@override @useResult
$Res call({
@DateOnlyConverter() DateTime accrualDate, int days, int? calendarYear,@DateOnlyConverter() DateTime? expiresOn, List<AppliedRule> rules
});




}
/// @nodoc
class __$EntitlementPeriodCopyWithImpl<$Res>
    implements _$EntitlementPeriodCopyWith<$Res> {
  __$EntitlementPeriodCopyWithImpl(this._self, this._then);

  final _EntitlementPeriod _self;
  final $Res Function(_EntitlementPeriod) _then;

/// Create a copy of EntitlementPeriod
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accrualDate = null,Object? days = null,Object? calendarYear = freezed,Object? expiresOn = freezed,Object? rules = null,}) {
  return _then(_EntitlementPeriod(
accrualDate: null == accrualDate ? _self.accrualDate : accrualDate // ignore: cast_nullable_to_non_nullable
as DateTime,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,calendarYear: freezed == calendarYear ? _self.calendarYear : calendarYear // ignore: cast_nullable_to_non_nullable
as int?,expiresOn: freezed == expiresOn ? _self.expiresOn : expiresOn // ignore: cast_nullable_to_non_nullable
as DateTime?,rules: null == rules ? _self._rules : rules // ignore: cast_nullable_to_non_nullable
as List<AppliedRule>,
  ));
}


}

// dart format on
