// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bridge_suggestion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BridgeSuggestion {

/// Days to take as leave.
@DateOnlyConverter() List<DateTime> get leaveDays;/// The whole continuous break.
 DateRange get vacation;/// Calendar days in [vacation].
 int get totalDaysOff;/// Leave days deducted, eves may count as half.
 double get leaveDaysUsed;/// Names of the holidays inside the break.
 List<String> get holidayNames;
/// Create a copy of BridgeSuggestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BridgeSuggestionCopyWith<BridgeSuggestion> get copyWith => _$BridgeSuggestionCopyWithImpl<BridgeSuggestion>(this as BridgeSuggestion, _$identity);

  /// Serializes this BridgeSuggestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BridgeSuggestion;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BridgeSuggestion&&const DeepCollectionEquality().equals(other.leaveDays, _this.leaveDays)&&(identical(other.vacation, _this.vacation) || other.vacation == _this.vacation)&&(identical(other.totalDaysOff, _this.totalDaysOff) || other.totalDaysOff == _this.totalDaysOff)&&(identical(other.leaveDaysUsed, _this.leaveDaysUsed) || other.leaveDaysUsed == _this.leaveDaysUsed)&&const DeepCollectionEquality().equals(other.holidayNames, _this.holidayNames));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BridgeSuggestion;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.leaveDays),_this.vacation,_this.totalDaysOff,_this.leaveDaysUsed,const DeepCollectionEquality().hash(_this.holidayNames));
}

@override
String toString() {
  final _this = this as BridgeSuggestion;
  return 'BridgeSuggestion(leaveDays: ${_this.leaveDays}, vacation: ${_this.vacation}, totalDaysOff: ${_this.totalDaysOff}, leaveDaysUsed: ${_this.leaveDaysUsed}, holidayNames: ${_this.holidayNames})';
}


}

/// @nodoc
abstract mixin class $BridgeSuggestionCopyWith<$Res>  {
  factory $BridgeSuggestionCopyWith(BridgeSuggestion value, $Res Function(BridgeSuggestion) _then) = _$BridgeSuggestionCopyWithImpl;
@useResult
$Res call({
@DateOnlyConverter() List<DateTime> leaveDays, DateRange vacation, int totalDaysOff, double leaveDaysUsed, List<String> holidayNames
});


$DateRangeCopyWith<$Res> get vacation;

}
/// @nodoc
class _$BridgeSuggestionCopyWithImpl<$Res>
    implements $BridgeSuggestionCopyWith<$Res> {
  _$BridgeSuggestionCopyWithImpl(this._self, this._then);

  final BridgeSuggestion _self;
  final $Res Function(BridgeSuggestion) _then;

/// Create a copy of BridgeSuggestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? leaveDays = null,Object? vacation = null,Object? totalDaysOff = null,Object? leaveDaysUsed = null,Object? holidayNames = null,}) {
  return _then(BridgeSuggestion(
leaveDays: null == leaveDays ? _self.leaveDays : leaveDays // ignore: cast_nullable_to_non_nullable
as List<DateTime>,vacation: null == vacation ? _self.vacation : vacation // ignore: cast_nullable_to_non_nullable
as DateRange,totalDaysOff: null == totalDaysOff ? _self.totalDaysOff : totalDaysOff // ignore: cast_nullable_to_non_nullable
as int,leaveDaysUsed: null == leaveDaysUsed ? _self.leaveDaysUsed : leaveDaysUsed // ignore: cast_nullable_to_non_nullable
as double,holidayNames: null == holidayNames ? _self.holidayNames : holidayNames // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of BridgeSuggestion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DateRangeCopyWith<$Res> get vacation {
  
  return $DateRangeCopyWith<$Res>(_self.vacation, (value) {
    return _then(_self.copyWith(vacation: value));
  });
}
}


/// Adds pattern-matching-related methods to [BridgeSuggestion].
extension BridgeSuggestionPatterns on BridgeSuggestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BridgeSuggestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BridgeSuggestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BridgeSuggestion value)  $default,){
final _that = this;
switch (_that) {
case _BridgeSuggestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BridgeSuggestion value)?  $default,){
final _that = this;
switch (_that) {
case _BridgeSuggestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DateOnlyConverter()  List<DateTime> leaveDays,  DateRange vacation,  int totalDaysOff,  double leaveDaysUsed,  List<String> holidayNames)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BridgeSuggestion() when $default != null:
return $default(_that.leaveDays,_that.vacation,_that.totalDaysOff,_that.leaveDaysUsed,_that.holidayNames);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DateOnlyConverter()  List<DateTime> leaveDays,  DateRange vacation,  int totalDaysOff,  double leaveDaysUsed,  List<String> holidayNames)  $default,) {final _that = this;
switch (_that) {
case _BridgeSuggestion():
return $default(_that.leaveDays,_that.vacation,_that.totalDaysOff,_that.leaveDaysUsed,_that.holidayNames);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DateOnlyConverter()  List<DateTime> leaveDays,  DateRange vacation,  int totalDaysOff,  double leaveDaysUsed,  List<String> holidayNames)?  $default,) {final _that = this;
switch (_that) {
case _BridgeSuggestion() when $default != null:
return $default(_that.leaveDays,_that.vacation,_that.totalDaysOff,_that.leaveDaysUsed,_that.holidayNames);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BridgeSuggestion extends BridgeSuggestion {
  const _BridgeSuggestion({@DateOnlyConverter() required  List<DateTime> leaveDays, required this.vacation, required this.totalDaysOff, required this.leaveDaysUsed,  List<String> holidayNames = const <String>[]}): _leaveDays = leaveDays,_holidayNames = holidayNames,super._();
  factory _BridgeSuggestion.fromJson(Map<String, dynamic> json) => _$BridgeSuggestionFromJson(json);

/// Days to take as leave.
 final  List<DateTime> _leaveDays;
/// Days to take as leave.
@override@DateOnlyConverter() List<DateTime> get leaveDays {
  if (_leaveDays is EqualUnmodifiableListView) return _leaveDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_leaveDays);
}

/// The whole continuous break.
@override final  DateRange vacation;
/// Calendar days in [vacation].
@override final  int totalDaysOff;
/// Leave days deducted, eves may count as half.
@override final  double leaveDaysUsed;
/// Names of the holidays inside the break.
 final  List<String> _holidayNames;
/// Names of the holidays inside the break.
@override@JsonKey() List<String> get holidayNames {
  if (_holidayNames is EqualUnmodifiableListView) return _holidayNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_holidayNames);
}


/// Create a copy of BridgeSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BridgeSuggestionCopyWith<_BridgeSuggestion> get copyWith => __$BridgeSuggestionCopyWithImpl<_BridgeSuggestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BridgeSuggestionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BridgeSuggestion&&const DeepCollectionEquality().equals(other.leaveDays, _leaveDays)&&(identical(other.vacation, vacation) || other.vacation == vacation)&&(identical(other.totalDaysOff, totalDaysOff) || other.totalDaysOff == totalDaysOff)&&(identical(other.leaveDaysUsed, leaveDaysUsed) || other.leaveDaysUsed == leaveDaysUsed)&&const DeepCollectionEquality().equals(other.holidayNames, _holidayNames));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_leaveDays),vacation,totalDaysOff,leaveDaysUsed,const DeepCollectionEquality().hash(_holidayNames));
}

@override
String toString() {
    return 'BridgeSuggestion(leaveDays: $leaveDays, vacation: $vacation, totalDaysOff: $totalDaysOff, leaveDaysUsed: $leaveDaysUsed, holidayNames: $holidayNames)';
}


}

/// @nodoc
abstract mixin class _$BridgeSuggestionCopyWith<$Res> implements $BridgeSuggestionCopyWith<$Res> {
  factory _$BridgeSuggestionCopyWith(_BridgeSuggestion value, $Res Function(_BridgeSuggestion) _then) = __$BridgeSuggestionCopyWithImpl;
@override @useResult
$Res call({
@DateOnlyConverter() List<DateTime> leaveDays, DateRange vacation, int totalDaysOff, double leaveDaysUsed, List<String> holidayNames
});


@override $DateRangeCopyWith<$Res> get vacation;

}
/// @nodoc
class __$BridgeSuggestionCopyWithImpl<$Res>
    implements _$BridgeSuggestionCopyWith<$Res> {
  __$BridgeSuggestionCopyWithImpl(this._self, this._then);

  final _BridgeSuggestion _self;
  final $Res Function(_BridgeSuggestion) _then;

/// Create a copy of BridgeSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? leaveDays = null,Object? vacation = null,Object? totalDaysOff = null,Object? leaveDaysUsed = null,Object? holidayNames = null,}) {
  return _then(_BridgeSuggestion(
leaveDays: null == leaveDays ? _self._leaveDays : leaveDays // ignore: cast_nullable_to_non_nullable
as List<DateTime>,vacation: null == vacation ? _self.vacation : vacation // ignore: cast_nullable_to_non_nullable
as DateRange,totalDaysOff: null == totalDaysOff ? _self.totalDaysOff : totalDaysOff // ignore: cast_nullable_to_non_nullable
as int,leaveDaysUsed: null == leaveDaysUsed ? _self.leaveDaysUsed : leaveDaysUsed // ignore: cast_nullable_to_non_nullable
as double,holidayNames: null == holidayNames ? _self._holidayNames : holidayNames // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of BridgeSuggestion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DateRangeCopyWith<$Res> get vacation {
  
  return $DateRangeCopyWith<$Res>(_self.vacation, (value) {
    return _then(_self.copyWith(vacation: value));
  });
}
}

// dart format on
