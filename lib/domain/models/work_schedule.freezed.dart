// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkSchedule {

/// Working weekdays as [DateTime.monday] ... [DateTime.sunday].
 List<int> get workDays;/// Legal weekly rest day (hafta tatili), see 4857 art. 46.
 int get weeklyRestDay;/// Whether a non-working Saturday counts as a leave day (4857 only).
/// See `docs/mevzuat.md` section 1.10.
 bool get saturdayCountsAsLeave;/// Cost of an eve or 28 October morning, see `docs/mevzuat.md` 4.
 HalfDayDeduction get halfDayDeduction;/// Working hours per day, used to convert hourly leave to days.
 double get dailyWorkingHours;
/// Create a copy of WorkSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkScheduleCopyWith<WorkSchedule> get copyWith => _$WorkScheduleCopyWithImpl<WorkSchedule>(this as WorkSchedule, _$identity);

  /// Serializes this WorkSchedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkSchedule;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkSchedule&&const DeepCollectionEquality().equals(other.workDays, _this.workDays)&&(identical(other.weeklyRestDay, _this.weeklyRestDay) || other.weeklyRestDay == _this.weeklyRestDay)&&(identical(other.saturdayCountsAsLeave, _this.saturdayCountsAsLeave) || other.saturdayCountsAsLeave == _this.saturdayCountsAsLeave)&&(identical(other.halfDayDeduction, _this.halfDayDeduction) || other.halfDayDeduction == _this.halfDayDeduction)&&(identical(other.dailyWorkingHours, _this.dailyWorkingHours) || other.dailyWorkingHours == _this.dailyWorkingHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkSchedule;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.workDays),_this.weeklyRestDay,_this.saturdayCountsAsLeave,_this.halfDayDeduction,_this.dailyWorkingHours);
}

@override
String toString() {
  final _this = this as WorkSchedule;
  return 'WorkSchedule(workDays: ${_this.workDays}, weeklyRestDay: ${_this.weeklyRestDay}, saturdayCountsAsLeave: ${_this.saturdayCountsAsLeave}, halfDayDeduction: ${_this.halfDayDeduction}, dailyWorkingHours: ${_this.dailyWorkingHours})';
}


}

/// @nodoc
abstract mixin class $WorkScheduleCopyWith<$Res>  {
  factory $WorkScheduleCopyWith(WorkSchedule value, $Res Function(WorkSchedule) _then) = _$WorkScheduleCopyWithImpl;
@useResult
$Res call({
 List<int> workDays, int weeklyRestDay, bool saturdayCountsAsLeave, HalfDayDeduction halfDayDeduction, double dailyWorkingHours
});




}
/// @nodoc
class _$WorkScheduleCopyWithImpl<$Res>
    implements $WorkScheduleCopyWith<$Res> {
  _$WorkScheduleCopyWithImpl(this._self, this._then);

  final WorkSchedule _self;
  final $Res Function(WorkSchedule) _then;

/// Create a copy of WorkSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workDays = null,Object? weeklyRestDay = null,Object? saturdayCountsAsLeave = null,Object? halfDayDeduction = null,Object? dailyWorkingHours = null,}) {
  return _then(WorkSchedule(
workDays: null == workDays ? _self.workDays : workDays // ignore: cast_nullable_to_non_nullable
as List<int>,weeklyRestDay: null == weeklyRestDay ? _self.weeklyRestDay : weeklyRestDay // ignore: cast_nullable_to_non_nullable
as int,saturdayCountsAsLeave: null == saturdayCountsAsLeave ? _self.saturdayCountsAsLeave : saturdayCountsAsLeave // ignore: cast_nullable_to_non_nullable
as bool,halfDayDeduction: null == halfDayDeduction ? _self.halfDayDeduction : halfDayDeduction // ignore: cast_nullable_to_non_nullable
as HalfDayDeduction,dailyWorkingHours: null == dailyWorkingHours ? _self.dailyWorkingHours : dailyWorkingHours // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkSchedule].
extension WorkSchedulePatterns on WorkSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkSchedule value)  $default,){
final _that = this;
switch (_that) {
case _WorkSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _WorkSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<int> workDays,  int weeklyRestDay,  bool saturdayCountsAsLeave,  HalfDayDeduction halfDayDeduction,  double dailyWorkingHours)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkSchedule() when $default != null:
return $default(_that.workDays,_that.weeklyRestDay,_that.saturdayCountsAsLeave,_that.halfDayDeduction,_that.dailyWorkingHours);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<int> workDays,  int weeklyRestDay,  bool saturdayCountsAsLeave,  HalfDayDeduction halfDayDeduction,  double dailyWorkingHours)  $default,) {final _that = this;
switch (_that) {
case _WorkSchedule():
return $default(_that.workDays,_that.weeklyRestDay,_that.saturdayCountsAsLeave,_that.halfDayDeduction,_that.dailyWorkingHours);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<int> workDays,  int weeklyRestDay,  bool saturdayCountsAsLeave,  HalfDayDeduction halfDayDeduction,  double dailyWorkingHours)?  $default,) {final _that = this;
switch (_that) {
case _WorkSchedule() when $default != null:
return $default(_that.workDays,_that.weeklyRestDay,_that.saturdayCountsAsLeave,_that.halfDayDeduction,_that.dailyWorkingHours);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkSchedule implements WorkSchedule {
  const _WorkSchedule({ List<int> workDays = const <int>[1, 2, 3, 4, 5], this.weeklyRestDay = DateTime.sunday, this.saturdayCountsAsLeave = true, this.halfDayDeduction = HalfDayDeduction.half, this.dailyWorkingHours = 8}): _workDays = workDays;
  factory _WorkSchedule.fromJson(Map<String, dynamic> json) => _$WorkScheduleFromJson(json);

/// Working weekdays as [DateTime.monday] ... [DateTime.sunday].
 final  List<int> _workDays;
/// Working weekdays as [DateTime.monday] ... [DateTime.sunday].
@override@JsonKey() List<int> get workDays {
  if (_workDays is EqualUnmodifiableListView) return _workDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_workDays);
}

/// Legal weekly rest day (hafta tatili), see 4857 art. 46.
@override@JsonKey() final  int weeklyRestDay;
/// Whether a non-working Saturday counts as a leave day (4857 only).
/// See `docs/mevzuat.md` section 1.10.
@override@JsonKey() final  bool saturdayCountsAsLeave;
/// Cost of an eve or 28 October morning, see `docs/mevzuat.md` 4.
@override@JsonKey() final  HalfDayDeduction halfDayDeduction;
/// Working hours per day, used to convert hourly leave to days.
@override@JsonKey() final  double dailyWorkingHours;

/// Create a copy of WorkSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkScheduleCopyWith<_WorkSchedule> get copyWith => __$WorkScheduleCopyWithImpl<_WorkSchedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkSchedule&&const DeepCollectionEquality().equals(other.workDays, _workDays)&&(identical(other.weeklyRestDay, weeklyRestDay) || other.weeklyRestDay == weeklyRestDay)&&(identical(other.saturdayCountsAsLeave, saturdayCountsAsLeave) || other.saturdayCountsAsLeave == saturdayCountsAsLeave)&&(identical(other.halfDayDeduction, halfDayDeduction) || other.halfDayDeduction == halfDayDeduction)&&(identical(other.dailyWorkingHours, dailyWorkingHours) || other.dailyWorkingHours == dailyWorkingHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_workDays),weeklyRestDay,saturdayCountsAsLeave,halfDayDeduction,dailyWorkingHours);
}

@override
String toString() {
    return 'WorkSchedule(workDays: $workDays, weeklyRestDay: $weeklyRestDay, saturdayCountsAsLeave: $saturdayCountsAsLeave, halfDayDeduction: $halfDayDeduction, dailyWorkingHours: $dailyWorkingHours)';
}


}

/// @nodoc
abstract mixin class _$WorkScheduleCopyWith<$Res> implements $WorkScheduleCopyWith<$Res> {
  factory _$WorkScheduleCopyWith(_WorkSchedule value, $Res Function(_WorkSchedule) _then) = __$WorkScheduleCopyWithImpl;
@override @useResult
$Res call({
 List<int> workDays, int weeklyRestDay, bool saturdayCountsAsLeave, HalfDayDeduction halfDayDeduction, double dailyWorkingHours
});




}
/// @nodoc
class __$WorkScheduleCopyWithImpl<$Res>
    implements _$WorkScheduleCopyWith<$Res> {
  __$WorkScheduleCopyWithImpl(this._self, this._then);

  final _WorkSchedule _self;
  final $Res Function(_WorkSchedule) _then;

/// Create a copy of WorkSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workDays = null,Object? weeklyRestDay = null,Object? saturdayCountsAsLeave = null,Object? halfDayDeduction = null,Object? dailyWorkingHours = null,}) {
  return _then(_WorkSchedule(
workDays: null == workDays ? _self._workDays : workDays // ignore: cast_nullable_to_non_nullable
as List<int>,weeklyRestDay: null == weeklyRestDay ? _self.weeklyRestDay : weeklyRestDay // ignore: cast_nullable_to_non_nullable
as int,saturdayCountsAsLeave: null == saturdayCountsAsLeave ? _self.saturdayCountsAsLeave : saturdayCountsAsLeave // ignore: cast_nullable_to_non_nullable
as bool,halfDayDeduction: null == halfDayDeduction ? _self.halfDayDeduction : halfDayDeduction // ignore: cast_nullable_to_non_nullable
as HalfDayDeduction,dailyWorkingHours: null == dailyWorkingHours ? _self.dailyWorkingHours : dailyWorkingHours // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
