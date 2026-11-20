// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationPreferences {

 bool get holidayReminder; int get holidayDaysBefore; bool get accrualReminder; bool get plannedLeaveReminder; int get plannedLeaveDaysBefore; bool get yearEndReminder;
/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationPreferencesCopyWith<NotificationPreferences> get copyWith => _$NotificationPreferencesCopyWithImpl<NotificationPreferences>(this as NotificationPreferences, _$identity);

  /// Serializes this NotificationPreferences to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NotificationPreferences;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPreferences&&(identical(other.holidayReminder, _this.holidayReminder) || other.holidayReminder == _this.holidayReminder)&&(identical(other.holidayDaysBefore, _this.holidayDaysBefore) || other.holidayDaysBefore == _this.holidayDaysBefore)&&(identical(other.accrualReminder, _this.accrualReminder) || other.accrualReminder == _this.accrualReminder)&&(identical(other.plannedLeaveReminder, _this.plannedLeaveReminder) || other.plannedLeaveReminder == _this.plannedLeaveReminder)&&(identical(other.plannedLeaveDaysBefore, _this.plannedLeaveDaysBefore) || other.plannedLeaveDaysBefore == _this.plannedLeaveDaysBefore)&&(identical(other.yearEndReminder, _this.yearEndReminder) || other.yearEndReminder == _this.yearEndReminder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NotificationPreferences;
  return Object.hash(runtimeType,_this.holidayReminder,_this.holidayDaysBefore,_this.accrualReminder,_this.plannedLeaveReminder,_this.plannedLeaveDaysBefore,_this.yearEndReminder);
}

@override
String toString() {
  final _this = this as NotificationPreferences;
  return 'NotificationPreferences(holidayReminder: ${_this.holidayReminder}, holidayDaysBefore: ${_this.holidayDaysBefore}, accrualReminder: ${_this.accrualReminder}, plannedLeaveReminder: ${_this.plannedLeaveReminder}, plannedLeaveDaysBefore: ${_this.plannedLeaveDaysBefore}, yearEndReminder: ${_this.yearEndReminder})';
}


}

/// @nodoc
abstract mixin class $NotificationPreferencesCopyWith<$Res>  {
  factory $NotificationPreferencesCopyWith(NotificationPreferences value, $Res Function(NotificationPreferences) _then) = _$NotificationPreferencesCopyWithImpl;
@useResult
$Res call({
 bool holidayReminder, int holidayDaysBefore, bool accrualReminder, bool plannedLeaveReminder, int plannedLeaveDaysBefore, bool yearEndReminder
});




}
/// @nodoc
class _$NotificationPreferencesCopyWithImpl<$Res>
    implements $NotificationPreferencesCopyWith<$Res> {
  _$NotificationPreferencesCopyWithImpl(this._self, this._then);

  final NotificationPreferences _self;
  final $Res Function(NotificationPreferences) _then;

/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? holidayReminder = null,Object? holidayDaysBefore = null,Object? accrualReminder = null,Object? plannedLeaveReminder = null,Object? plannedLeaveDaysBefore = null,Object? yearEndReminder = null,}) {
  return _then(NotificationPreferences(
holidayReminder: null == holidayReminder ? _self.holidayReminder : holidayReminder // ignore: cast_nullable_to_non_nullable
as bool,holidayDaysBefore: null == holidayDaysBefore ? _self.holidayDaysBefore : holidayDaysBefore // ignore: cast_nullable_to_non_nullable
as int,accrualReminder: null == accrualReminder ? _self.accrualReminder : accrualReminder // ignore: cast_nullable_to_non_nullable
as bool,plannedLeaveReminder: null == plannedLeaveReminder ? _self.plannedLeaveReminder : plannedLeaveReminder // ignore: cast_nullable_to_non_nullable
as bool,plannedLeaveDaysBefore: null == plannedLeaveDaysBefore ? _self.plannedLeaveDaysBefore : plannedLeaveDaysBefore // ignore: cast_nullable_to_non_nullable
as int,yearEndReminder: null == yearEndReminder ? _self.yearEndReminder : yearEndReminder // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationPreferences].
extension NotificationPreferencesPatterns on NotificationPreferences {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationPreferences value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationPreferences() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationPreferences value)  $default,){
final _that = this;
switch (_that) {
case _NotificationPreferences():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationPreferences value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationPreferences() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool holidayReminder,  int holidayDaysBefore,  bool accrualReminder,  bool plannedLeaveReminder,  int plannedLeaveDaysBefore,  bool yearEndReminder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationPreferences() when $default != null:
return $default(_that.holidayReminder,_that.holidayDaysBefore,_that.accrualReminder,_that.plannedLeaveReminder,_that.plannedLeaveDaysBefore,_that.yearEndReminder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool holidayReminder,  int holidayDaysBefore,  bool accrualReminder,  bool plannedLeaveReminder,  int plannedLeaveDaysBefore,  bool yearEndReminder)  $default,) {final _that = this;
switch (_that) {
case _NotificationPreferences():
return $default(_that.holidayReminder,_that.holidayDaysBefore,_that.accrualReminder,_that.plannedLeaveReminder,_that.plannedLeaveDaysBefore,_that.yearEndReminder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool holidayReminder,  int holidayDaysBefore,  bool accrualReminder,  bool plannedLeaveReminder,  int plannedLeaveDaysBefore,  bool yearEndReminder)?  $default,) {final _that = this;
switch (_that) {
case _NotificationPreferences() when $default != null:
return $default(_that.holidayReminder,_that.holidayDaysBefore,_that.accrualReminder,_that.plannedLeaveReminder,_that.plannedLeaveDaysBefore,_that.yearEndReminder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationPreferences implements NotificationPreferences {
  const _NotificationPreferences({this.holidayReminder = false, this.holidayDaysBefore = 7, this.accrualReminder = false, this.plannedLeaveReminder = false, this.plannedLeaveDaysBefore = 1, this.yearEndReminder = false});
  factory _NotificationPreferences.fromJson(Map<String, dynamic> json) => _$NotificationPreferencesFromJson(json);

@override@JsonKey() final  bool holidayReminder;
@override@JsonKey() final  int holidayDaysBefore;
@override@JsonKey() final  bool accrualReminder;
@override@JsonKey() final  bool plannedLeaveReminder;
@override@JsonKey() final  int plannedLeaveDaysBefore;
@override@JsonKey() final  bool yearEndReminder;

/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationPreferencesCopyWith<_NotificationPreferences> get copyWith => __$NotificationPreferencesCopyWithImpl<_NotificationPreferences>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationPreferencesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationPreferences&&(identical(other.holidayReminder, holidayReminder) || other.holidayReminder == holidayReminder)&&(identical(other.holidayDaysBefore, holidayDaysBefore) || other.holidayDaysBefore == holidayDaysBefore)&&(identical(other.accrualReminder, accrualReminder) || other.accrualReminder == accrualReminder)&&(identical(other.plannedLeaveReminder, plannedLeaveReminder) || other.plannedLeaveReminder == plannedLeaveReminder)&&(identical(other.plannedLeaveDaysBefore, plannedLeaveDaysBefore) || other.plannedLeaveDaysBefore == plannedLeaveDaysBefore)&&(identical(other.yearEndReminder, yearEndReminder) || other.yearEndReminder == yearEndReminder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,holidayReminder,holidayDaysBefore,accrualReminder,plannedLeaveReminder,plannedLeaveDaysBefore,yearEndReminder);
}

@override
String toString() {
    return 'NotificationPreferences(holidayReminder: $holidayReminder, holidayDaysBefore: $holidayDaysBefore, accrualReminder: $accrualReminder, plannedLeaveReminder: $plannedLeaveReminder, plannedLeaveDaysBefore: $plannedLeaveDaysBefore, yearEndReminder: $yearEndReminder)';
}


}

/// @nodoc
abstract mixin class _$NotificationPreferencesCopyWith<$Res> implements $NotificationPreferencesCopyWith<$Res> {
  factory _$NotificationPreferencesCopyWith(_NotificationPreferences value, $Res Function(_NotificationPreferences) _then) = __$NotificationPreferencesCopyWithImpl;
@override @useResult
$Res call({
 bool holidayReminder, int holidayDaysBefore, bool accrualReminder, bool plannedLeaveReminder, int plannedLeaveDaysBefore, bool yearEndReminder
});




}
/// @nodoc
class __$NotificationPreferencesCopyWithImpl<$Res>
    implements _$NotificationPreferencesCopyWith<$Res> {
  __$NotificationPreferencesCopyWithImpl(this._self, this._then);

  final _NotificationPreferences _self;
  final $Res Function(_NotificationPreferences) _then;

/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? holidayReminder = null,Object? holidayDaysBefore = null,Object? accrualReminder = null,Object? plannedLeaveReminder = null,Object? plannedLeaveDaysBefore = null,Object? yearEndReminder = null,}) {
  return _then(_NotificationPreferences(
holidayReminder: null == holidayReminder ? _self.holidayReminder : holidayReminder // ignore: cast_nullable_to_non_nullable
as bool,holidayDaysBefore: null == holidayDaysBefore ? _self.holidayDaysBefore : holidayDaysBefore // ignore: cast_nullable_to_non_nullable
as int,accrualReminder: null == accrualReminder ? _self.accrualReminder : accrualReminder // ignore: cast_nullable_to_non_nullable
as bool,plannedLeaveReminder: null == plannedLeaveReminder ? _self.plannedLeaveReminder : plannedLeaveReminder // ignore: cast_nullable_to_non_nullable
as bool,plannedLeaveDaysBefore: null == plannedLeaveDaysBefore ? _self.plannedLeaveDaysBefore : plannedLeaveDaysBefore // ignore: cast_nullable_to_non_nullable
as int,yearEndReminder: null == yearEndReminder ? _self.yearEndReminder : yearEndReminder // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
