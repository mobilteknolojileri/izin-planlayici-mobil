// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leave_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeaveRecord {

 String get id; String get profileId; LeaveType get type; DateRange get range; LeaveUnit get unit;/// Hours, only when [unit] is [LeaveUnit.hours].
 double? get hours;/// Name shown for [LeaveType.other].
 String? get customTypeName;/// Event date, e.g. the child's birth date for paternity leave.
@DateOnlyConverter() DateTime? get eventDate;/// Whether this record reduces the annual balance although [type] is not
/// annual. Used for the second excuse block of 657 art. 104/C.
 bool get deductsFromAnnual; String? get note;
/// Create a copy of LeaveRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveRecordCopyWith<LeaveRecord> get copyWith => _$LeaveRecordCopyWithImpl<LeaveRecord>(this as LeaveRecord, _$identity);

  /// Serializes this LeaveRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LeaveRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.profileId, _this.profileId) || other.profileId == _this.profileId)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.range, _this.range) || other.range == _this.range)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.hours, _this.hours) || other.hours == _this.hours)&&(identical(other.customTypeName, _this.customTypeName) || other.customTypeName == _this.customTypeName)&&(identical(other.eventDate, _this.eventDate) || other.eventDate == _this.eventDate)&&(identical(other.deductsFromAnnual, _this.deductsFromAnnual) || other.deductsFromAnnual == _this.deductsFromAnnual)&&(identical(other.note, _this.note) || other.note == _this.note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LeaveRecord;
  return Object.hash(runtimeType,_this.id,_this.profileId,_this.type,_this.range,_this.unit,_this.hours,_this.customTypeName,_this.eventDate,_this.deductsFromAnnual,_this.note);
}

@override
String toString() {
  final _this = this as LeaveRecord;
  return 'LeaveRecord(id: ${_this.id}, profileId: ${_this.profileId}, type: ${_this.type}, range: ${_this.range}, unit: ${_this.unit}, hours: ${_this.hours}, customTypeName: ${_this.customTypeName}, eventDate: ${_this.eventDate}, deductsFromAnnual: ${_this.deductsFromAnnual}, note: ${_this.note})';
}


}

/// @nodoc
abstract mixin class $LeaveRecordCopyWith<$Res>  {
  factory $LeaveRecordCopyWith(LeaveRecord value, $Res Function(LeaveRecord) _then) = _$LeaveRecordCopyWithImpl;
@useResult
$Res call({
 String id, String profileId, LeaveType type, DateRange range, LeaveUnit unit, double? hours, String? customTypeName,@DateOnlyConverter() DateTime? eventDate, bool deductsFromAnnual, String? note
});


$DateRangeCopyWith<$Res> get range;

}
/// @nodoc
class _$LeaveRecordCopyWithImpl<$Res>
    implements $LeaveRecordCopyWith<$Res> {
  _$LeaveRecordCopyWithImpl(this._self, this._then);

  final LeaveRecord _self;
  final $Res Function(LeaveRecord) _then;

/// Create a copy of LeaveRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? profileId = null,Object? type = null,Object? range = null,Object? unit = null,Object? hours = freezed,Object? customTypeName = freezed,Object? eventDate = freezed,Object? deductsFromAnnual = null,Object? note = freezed,}) {
  return _then(LeaveRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LeaveType,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as DateRange,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as LeaveUnit,hours: freezed == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double?,customTypeName: freezed == customTypeName ? _self.customTypeName : customTypeName // ignore: cast_nullable_to_non_nullable
as String?,eventDate: freezed == eventDate ? _self.eventDate : eventDate // ignore: cast_nullable_to_non_nullable
as DateTime?,deductsFromAnnual: null == deductsFromAnnual ? _self.deductsFromAnnual : deductsFromAnnual // ignore: cast_nullable_to_non_nullable
as bool,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of LeaveRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DateRangeCopyWith<$Res> get range {
  
  return $DateRangeCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}
}


/// Adds pattern-matching-related methods to [LeaveRecord].
extension LeaveRecordPatterns on LeaveRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveRecord value)  $default,){
final _that = this;
switch (_that) {
case _LeaveRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveRecord value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String profileId,  LeaveType type,  DateRange range,  LeaveUnit unit,  double? hours,  String? customTypeName, @DateOnlyConverter()  DateTime? eventDate,  bool deductsFromAnnual,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveRecord() when $default != null:
return $default(_that.id,_that.profileId,_that.type,_that.range,_that.unit,_that.hours,_that.customTypeName,_that.eventDate,_that.deductsFromAnnual,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String profileId,  LeaveType type,  DateRange range,  LeaveUnit unit,  double? hours,  String? customTypeName, @DateOnlyConverter()  DateTime? eventDate,  bool deductsFromAnnual,  String? note)  $default,) {final _that = this;
switch (_that) {
case _LeaveRecord():
return $default(_that.id,_that.profileId,_that.type,_that.range,_that.unit,_that.hours,_that.customTypeName,_that.eventDate,_that.deductsFromAnnual,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String profileId,  LeaveType type,  DateRange range,  LeaveUnit unit,  double? hours,  String? customTypeName, @DateOnlyConverter()  DateTime? eventDate,  bool deductsFromAnnual,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _LeaveRecord() when $default != null:
return $default(_that.id,_that.profileId,_that.type,_that.range,_that.unit,_that.hours,_that.customTypeName,_that.eventDate,_that.deductsFromAnnual,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaveRecord implements LeaveRecord {
  const _LeaveRecord({required this.id, required this.profileId, required this.type, required this.range, this.unit = LeaveUnit.days, this.hours, this.customTypeName, @DateOnlyConverter() this.eventDate, this.deductsFromAnnual = false, this.note});
  factory _LeaveRecord.fromJson(Map<String, dynamic> json) => _$LeaveRecordFromJson(json);

@override final  String id;
@override final  String profileId;
@override final  LeaveType type;
@override final  DateRange range;
@override@JsonKey() final  LeaveUnit unit;
/// Hours, only when [unit] is [LeaveUnit.hours].
@override final  double? hours;
/// Name shown for [LeaveType.other].
@override final  String? customTypeName;
/// Event date, e.g. the child's birth date for paternity leave.
@override@DateOnlyConverter() final  DateTime? eventDate;
/// Whether this record reduces the annual balance although [type] is not
/// annual. Used for the second excuse block of 657 art. 104/C.
@override@JsonKey() final  bool deductsFromAnnual;
@override final  String? note;

/// Create a copy of LeaveRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveRecordCopyWith<_LeaveRecord> get copyWith => __$LeaveRecordCopyWithImpl<_LeaveRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.type, type) || other.type == type)&&(identical(other.range, range) || other.range == range)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.hours, hours) || other.hours == hours)&&(identical(other.customTypeName, customTypeName) || other.customTypeName == customTypeName)&&(identical(other.eventDate, eventDate) || other.eventDate == eventDate)&&(identical(other.deductsFromAnnual, deductsFromAnnual) || other.deductsFromAnnual == deductsFromAnnual)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,profileId,type,range,unit,hours,customTypeName,eventDate,deductsFromAnnual,note);
}

@override
String toString() {
    return 'LeaveRecord(id: $id, profileId: $profileId, type: $type, range: $range, unit: $unit, hours: $hours, customTypeName: $customTypeName, eventDate: $eventDate, deductsFromAnnual: $deductsFromAnnual, note: $note)';
}


}

/// @nodoc
abstract mixin class _$LeaveRecordCopyWith<$Res> implements $LeaveRecordCopyWith<$Res> {
  factory _$LeaveRecordCopyWith(_LeaveRecord value, $Res Function(_LeaveRecord) _then) = __$LeaveRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String profileId, LeaveType type, DateRange range, LeaveUnit unit, double? hours, String? customTypeName,@DateOnlyConverter() DateTime? eventDate, bool deductsFromAnnual, String? note
});


@override $DateRangeCopyWith<$Res> get range;

}
/// @nodoc
class __$LeaveRecordCopyWithImpl<$Res>
    implements _$LeaveRecordCopyWith<$Res> {
  __$LeaveRecordCopyWithImpl(this._self, this._then);

  final _LeaveRecord _self;
  final $Res Function(_LeaveRecord) _then;

/// Create a copy of LeaveRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? profileId = null,Object? type = null,Object? range = null,Object? unit = null,Object? hours = freezed,Object? customTypeName = freezed,Object? eventDate = freezed,Object? deductsFromAnnual = null,Object? note = freezed,}) {
  return _then(_LeaveRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LeaveType,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as DateRange,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as LeaveUnit,hours: freezed == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double?,customTypeName: freezed == customTypeName ? _self.customTypeName : customTypeName // ignore: cast_nullable_to_non_nullable
as String?,eventDate: freezed == eventDate ? _self.eventDate : eventDate // ignore: cast_nullable_to_non_nullable
as DateTime?,deductsFromAnnual: null == deductsFromAnnual ? _self.deductsFromAnnual : deductsFromAnnual // ignore: cast_nullable_to_non_nullable
as bool,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of LeaveRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DateRangeCopyWith<$Res> get range {
  
  return $DateRangeCopyWith<$Res>(_self.range, (value) {
    return _then(_self.copyWith(range: value));
  });
}
}

// dart format on
