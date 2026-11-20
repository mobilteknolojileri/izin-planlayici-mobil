// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'overtime_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OvertimeRecord {

 String get id; String get profileId;@DateOnlyConverter() DateTime get date; double get hours; String? get note;
/// Create a copy of OvertimeRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OvertimeRecordCopyWith<OvertimeRecord> get copyWith => _$OvertimeRecordCopyWithImpl<OvertimeRecord>(this as OvertimeRecord, _$identity);

  /// Serializes this OvertimeRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OvertimeRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OvertimeRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.profileId, _this.profileId) || other.profileId == _this.profileId)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.hours, _this.hours) || other.hours == _this.hours)&&(identical(other.note, _this.note) || other.note == _this.note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OvertimeRecord;
  return Object.hash(runtimeType,_this.id,_this.profileId,_this.date,_this.hours,_this.note);
}

@override
String toString() {
  final _this = this as OvertimeRecord;
  return 'OvertimeRecord(id: ${_this.id}, profileId: ${_this.profileId}, date: ${_this.date}, hours: ${_this.hours}, note: ${_this.note})';
}


}

/// @nodoc
abstract mixin class $OvertimeRecordCopyWith<$Res>  {
  factory $OvertimeRecordCopyWith(OvertimeRecord value, $Res Function(OvertimeRecord) _then) = _$OvertimeRecordCopyWithImpl;
@useResult
$Res call({
 String id, String profileId,@DateOnlyConverter() DateTime date, double hours, String? note
});




}
/// @nodoc
class _$OvertimeRecordCopyWithImpl<$Res>
    implements $OvertimeRecordCopyWith<$Res> {
  _$OvertimeRecordCopyWithImpl(this._self, this._then);

  final OvertimeRecord _self;
  final $Res Function(OvertimeRecord) _then;

/// Create a copy of OvertimeRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? profileId = null,Object? date = null,Object? hours = null,Object? note = freezed,}) {
  return _then(OvertimeRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OvertimeRecord].
extension OvertimeRecordPatterns on OvertimeRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OvertimeRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OvertimeRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OvertimeRecord value)  $default,){
final _that = this;
switch (_that) {
case _OvertimeRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OvertimeRecord value)?  $default,){
final _that = this;
switch (_that) {
case _OvertimeRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String profileId, @DateOnlyConverter()  DateTime date,  double hours,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OvertimeRecord() when $default != null:
return $default(_that.id,_that.profileId,_that.date,_that.hours,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String profileId, @DateOnlyConverter()  DateTime date,  double hours,  String? note)  $default,) {final _that = this;
switch (_that) {
case _OvertimeRecord():
return $default(_that.id,_that.profileId,_that.date,_that.hours,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String profileId, @DateOnlyConverter()  DateTime date,  double hours,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _OvertimeRecord() when $default != null:
return $default(_that.id,_that.profileId,_that.date,_that.hours,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OvertimeRecord implements OvertimeRecord {
  const _OvertimeRecord({required this.id, required this.profileId, @DateOnlyConverter() required this.date, required this.hours, this.note});
  factory _OvertimeRecord.fromJson(Map<String, dynamic> json) => _$OvertimeRecordFromJson(json);

@override final  String id;
@override final  String profileId;
@override@DateOnlyConverter() final  DateTime date;
@override final  double hours;
@override final  String? note;

/// Create a copy of OvertimeRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OvertimeRecordCopyWith<_OvertimeRecord> get copyWith => __$OvertimeRecordCopyWithImpl<_OvertimeRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OvertimeRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OvertimeRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.date, date) || other.date == date)&&(identical(other.hours, hours) || other.hours == hours)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,profileId,date,hours,note);
}

@override
String toString() {
    return 'OvertimeRecord(id: $id, profileId: $profileId, date: $date, hours: $hours, note: $note)';
}


}

/// @nodoc
abstract mixin class _$OvertimeRecordCopyWith<$Res> implements $OvertimeRecordCopyWith<$Res> {
  factory _$OvertimeRecordCopyWith(_OvertimeRecord value, $Res Function(_OvertimeRecord) _then) = __$OvertimeRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String profileId,@DateOnlyConverter() DateTime date, double hours, String? note
});




}
/// @nodoc
class __$OvertimeRecordCopyWithImpl<$Res>
    implements _$OvertimeRecordCopyWith<$Res> {
  __$OvertimeRecordCopyWithImpl(this._self, this._then);

  final _OvertimeRecord _self;
  final $Res Function(_OvertimeRecord) _then;

/// Create a copy of OvertimeRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? profileId = null,Object? date = null,Object? hours = null,Object? note = freezed,}) {
  return _then(_OvertimeRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
