// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Profile {

 String get id; String get name; EmploymentType get employmentType;/// Hire date (4857) or start of duty (657).
@DateOnlyConverter() DateTime get employmentStartDate;/// Needed for the age rules of 4857 art. 53.
@DateOnlyConverter() DateTime get birthDate; WorkSchedule get workSchedule;/// Prior service with the same employer (4857) or counted public
/// service (657).
 ServiceDuration get priorService;/// Underground work adds days (4857 art. 53/4).
 bool get isUnderground;/// Extra days granted above the law by contract or union agreement.
 int get contractExtraDays;/// Annual leave days used before the app started tracking.
 double get leaveUsedBeforeTracking;/// Teachers get no annual leave (657 art. 103/2).
 bool get isTeacher;/// Administrative leave days marked by a civil servant (657).
@DateOnlyConverter() List<DateTime> get administrativeLeaveDays;/// Absences that shift accrual dates (4857 art. 54/2).
 List<DateRange> get absencePeriods;
/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileCopyWith<Profile> get copyWith => _$ProfileCopyWithImpl<Profile>(this as Profile, _$identity);

  /// Serializes this Profile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Profile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Profile&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.employmentType, _this.employmentType) || other.employmentType == _this.employmentType)&&(identical(other.employmentStartDate, _this.employmentStartDate) || other.employmentStartDate == _this.employmentStartDate)&&(identical(other.birthDate, _this.birthDate) || other.birthDate == _this.birthDate)&&(identical(other.workSchedule, _this.workSchedule) || other.workSchedule == _this.workSchedule)&&(identical(other.priorService, _this.priorService) || other.priorService == _this.priorService)&&(identical(other.isUnderground, _this.isUnderground) || other.isUnderground == _this.isUnderground)&&(identical(other.contractExtraDays, _this.contractExtraDays) || other.contractExtraDays == _this.contractExtraDays)&&(identical(other.leaveUsedBeforeTracking, _this.leaveUsedBeforeTracking) || other.leaveUsedBeforeTracking == _this.leaveUsedBeforeTracking)&&(identical(other.isTeacher, _this.isTeacher) || other.isTeacher == _this.isTeacher)&&const DeepCollectionEquality().equals(other.administrativeLeaveDays, _this.administrativeLeaveDays)&&const DeepCollectionEquality().equals(other.absencePeriods, _this.absencePeriods));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Profile;
  return Object.hash(runtimeType,_this.id,_this.name,_this.employmentType,_this.employmentStartDate,_this.birthDate,_this.workSchedule,_this.priorService,_this.isUnderground,_this.contractExtraDays,_this.leaveUsedBeforeTracking,_this.isTeacher,const DeepCollectionEquality().hash(_this.administrativeLeaveDays),const DeepCollectionEquality().hash(_this.absencePeriods));
}

@override
String toString() {
  final _this = this as Profile;
  return 'Profile(id: ${_this.id}, name: ${_this.name}, employmentType: ${_this.employmentType}, employmentStartDate: ${_this.employmentStartDate}, birthDate: ${_this.birthDate}, workSchedule: ${_this.workSchedule}, priorService: ${_this.priorService}, isUnderground: ${_this.isUnderground}, contractExtraDays: ${_this.contractExtraDays}, leaveUsedBeforeTracking: ${_this.leaveUsedBeforeTracking}, isTeacher: ${_this.isTeacher}, administrativeLeaveDays: ${_this.administrativeLeaveDays}, absencePeriods: ${_this.absencePeriods})';
}


}

/// @nodoc
abstract mixin class $ProfileCopyWith<$Res>  {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) _then) = _$ProfileCopyWithImpl;
@useResult
$Res call({
 String id, String name, EmploymentType employmentType,@DateOnlyConverter() DateTime employmentStartDate,@DateOnlyConverter() DateTime birthDate, WorkSchedule workSchedule, ServiceDuration priorService, bool isUnderground, int contractExtraDays, double leaveUsedBeforeTracking, bool isTeacher,@DateOnlyConverter() List<DateTime> administrativeLeaveDays, List<DateRange> absencePeriods
});


$WorkScheduleCopyWith<$Res> get workSchedule;$ServiceDurationCopyWith<$Res> get priorService;

}
/// @nodoc
class _$ProfileCopyWithImpl<$Res>
    implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._self, this._then);

  final Profile _self;
  final $Res Function(Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? employmentType = null,Object? employmentStartDate = null,Object? birthDate = null,Object? workSchedule = null,Object? priorService = null,Object? isUnderground = null,Object? contractExtraDays = null,Object? leaveUsedBeforeTracking = null,Object? isTeacher = null,Object? administrativeLeaveDays = null,Object? absencePeriods = null,}) {
  return _then(Profile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,employmentType: null == employmentType ? _self.employmentType : employmentType // ignore: cast_nullable_to_non_nullable
as EmploymentType,employmentStartDate: null == employmentStartDate ? _self.employmentStartDate : employmentStartDate // ignore: cast_nullable_to_non_nullable
as DateTime,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime,workSchedule: null == workSchedule ? _self.workSchedule : workSchedule // ignore: cast_nullable_to_non_nullable
as WorkSchedule,priorService: null == priorService ? _self.priorService : priorService // ignore: cast_nullable_to_non_nullable
as ServiceDuration,isUnderground: null == isUnderground ? _self.isUnderground : isUnderground // ignore: cast_nullable_to_non_nullable
as bool,contractExtraDays: null == contractExtraDays ? _self.contractExtraDays : contractExtraDays // ignore: cast_nullable_to_non_nullable
as int,leaveUsedBeforeTracking: null == leaveUsedBeforeTracking ? _self.leaveUsedBeforeTracking : leaveUsedBeforeTracking // ignore: cast_nullable_to_non_nullable
as double,isTeacher: null == isTeacher ? _self.isTeacher : isTeacher // ignore: cast_nullable_to_non_nullable
as bool,administrativeLeaveDays: null == administrativeLeaveDays ? _self.administrativeLeaveDays : administrativeLeaveDays // ignore: cast_nullable_to_non_nullable
as List<DateTime>,absencePeriods: null == absencePeriods ? _self.absencePeriods : absencePeriods // ignore: cast_nullable_to_non_nullable
as List<DateRange>,
  ));
}
/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkScheduleCopyWith<$Res> get workSchedule {
  
  return $WorkScheduleCopyWith<$Res>(_self.workSchedule, (value) {
    return _then(_self.copyWith(workSchedule: value));
  });
}/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServiceDurationCopyWith<$Res> get priorService {
  
  return $ServiceDurationCopyWith<$Res>(_self.priorService, (value) {
    return _then(_self.copyWith(priorService: value));
  });
}
}


/// Adds pattern-matching-related methods to [Profile].
extension ProfilePatterns on Profile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Profile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Profile value)  $default,){
final _that = this;
switch (_that) {
case _Profile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Profile value)?  $default,){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  EmploymentType employmentType, @DateOnlyConverter()  DateTime employmentStartDate, @DateOnlyConverter()  DateTime birthDate,  WorkSchedule workSchedule,  ServiceDuration priorService,  bool isUnderground,  int contractExtraDays,  double leaveUsedBeforeTracking,  bool isTeacher, @DateOnlyConverter()  List<DateTime> administrativeLeaveDays,  List<DateRange> absencePeriods)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.id,_that.name,_that.employmentType,_that.employmentStartDate,_that.birthDate,_that.workSchedule,_that.priorService,_that.isUnderground,_that.contractExtraDays,_that.leaveUsedBeforeTracking,_that.isTeacher,_that.administrativeLeaveDays,_that.absencePeriods);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  EmploymentType employmentType, @DateOnlyConverter()  DateTime employmentStartDate, @DateOnlyConverter()  DateTime birthDate,  WorkSchedule workSchedule,  ServiceDuration priorService,  bool isUnderground,  int contractExtraDays,  double leaveUsedBeforeTracking,  bool isTeacher, @DateOnlyConverter()  List<DateTime> administrativeLeaveDays,  List<DateRange> absencePeriods)  $default,) {final _that = this;
switch (_that) {
case _Profile():
return $default(_that.id,_that.name,_that.employmentType,_that.employmentStartDate,_that.birthDate,_that.workSchedule,_that.priorService,_that.isUnderground,_that.contractExtraDays,_that.leaveUsedBeforeTracking,_that.isTeacher,_that.administrativeLeaveDays,_that.absencePeriods);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  EmploymentType employmentType, @DateOnlyConverter()  DateTime employmentStartDate, @DateOnlyConverter()  DateTime birthDate,  WorkSchedule workSchedule,  ServiceDuration priorService,  bool isUnderground,  int contractExtraDays,  double leaveUsedBeforeTracking,  bool isTeacher, @DateOnlyConverter()  List<DateTime> administrativeLeaveDays,  List<DateRange> absencePeriods)?  $default,) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.id,_that.name,_that.employmentType,_that.employmentStartDate,_that.birthDate,_that.workSchedule,_that.priorService,_that.isUnderground,_that.contractExtraDays,_that.leaveUsedBeforeTracking,_that.isTeacher,_that.administrativeLeaveDays,_that.absencePeriods);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Profile implements Profile {
  const _Profile({required this.id, required this.name, required this.employmentType, @DateOnlyConverter() required this.employmentStartDate, @DateOnlyConverter() required this.birthDate, this.workSchedule = const WorkSchedule(), this.priorService = const ServiceDuration(), this.isUnderground = false, this.contractExtraDays = 0, this.leaveUsedBeforeTracking = 0, this.isTeacher = false, @DateOnlyConverter()  List<DateTime> administrativeLeaveDays = const <DateTime>[],  List<DateRange> absencePeriods = const <DateRange>[]}): _administrativeLeaveDays = administrativeLeaveDays,_absencePeriods = absencePeriods;
  factory _Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

@override final  String id;
@override final  String name;
@override final  EmploymentType employmentType;
/// Hire date (4857) or start of duty (657).
@override@DateOnlyConverter() final  DateTime employmentStartDate;
/// Needed for the age rules of 4857 art. 53.
@override@DateOnlyConverter() final  DateTime birthDate;
@override@JsonKey() final  WorkSchedule workSchedule;
/// Prior service with the same employer (4857) or counted public
/// service (657).
@override@JsonKey() final  ServiceDuration priorService;
/// Underground work adds days (4857 art. 53/4).
@override@JsonKey() final  bool isUnderground;
/// Extra days granted above the law by contract or union agreement.
@override@JsonKey() final  int contractExtraDays;
/// Annual leave days used before the app started tracking.
@override@JsonKey() final  double leaveUsedBeforeTracking;
/// Teachers get no annual leave (657 art. 103/2).
@override@JsonKey() final  bool isTeacher;
/// Administrative leave days marked by a civil servant (657).
 final  List<DateTime> _administrativeLeaveDays;
/// Administrative leave days marked by a civil servant (657).
@override@JsonKey()@DateOnlyConverter() List<DateTime> get administrativeLeaveDays {
  if (_administrativeLeaveDays is EqualUnmodifiableListView) return _administrativeLeaveDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_administrativeLeaveDays);
}

/// Absences that shift accrual dates (4857 art. 54/2).
 final  List<DateRange> _absencePeriods;
/// Absences that shift accrual dates (4857 art. 54/2).
@override@JsonKey() List<DateRange> get absencePeriods {
  if (_absencePeriods is EqualUnmodifiableListView) return _absencePeriods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_absencePeriods);
}


/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileCopyWith<_Profile> get copyWith => __$ProfileCopyWithImpl<_Profile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Profile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.employmentType, employmentType) || other.employmentType == employmentType)&&(identical(other.employmentStartDate, employmentStartDate) || other.employmentStartDate == employmentStartDate)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.workSchedule, workSchedule) || other.workSchedule == workSchedule)&&(identical(other.priorService, priorService) || other.priorService == priorService)&&(identical(other.isUnderground, isUnderground) || other.isUnderground == isUnderground)&&(identical(other.contractExtraDays, contractExtraDays) || other.contractExtraDays == contractExtraDays)&&(identical(other.leaveUsedBeforeTracking, leaveUsedBeforeTracking) || other.leaveUsedBeforeTracking == leaveUsedBeforeTracking)&&(identical(other.isTeacher, isTeacher) || other.isTeacher == isTeacher)&&const DeepCollectionEquality().equals(other.administrativeLeaveDays, _administrativeLeaveDays)&&const DeepCollectionEquality().equals(other.absencePeriods, _absencePeriods));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,employmentType,employmentStartDate,birthDate,workSchedule,priorService,isUnderground,contractExtraDays,leaveUsedBeforeTracking,isTeacher,const DeepCollectionEquality().hash(_administrativeLeaveDays),const DeepCollectionEquality().hash(_absencePeriods));
}

@override
String toString() {
    return 'Profile(id: $id, name: $name, employmentType: $employmentType, employmentStartDate: $employmentStartDate, birthDate: $birthDate, workSchedule: $workSchedule, priorService: $priorService, isUnderground: $isUnderground, contractExtraDays: $contractExtraDays, leaveUsedBeforeTracking: $leaveUsedBeforeTracking, isTeacher: $isTeacher, administrativeLeaveDays: $administrativeLeaveDays, absencePeriods: $absencePeriods)';
}


}

/// @nodoc
abstract mixin class _$ProfileCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$ProfileCopyWith(_Profile value, $Res Function(_Profile) _then) = __$ProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, EmploymentType employmentType,@DateOnlyConverter() DateTime employmentStartDate,@DateOnlyConverter() DateTime birthDate, WorkSchedule workSchedule, ServiceDuration priorService, bool isUnderground, int contractExtraDays, double leaveUsedBeforeTracking, bool isTeacher,@DateOnlyConverter() List<DateTime> administrativeLeaveDays, List<DateRange> absencePeriods
});


@override $WorkScheduleCopyWith<$Res> get workSchedule;@override $ServiceDurationCopyWith<$Res> get priorService;

}
/// @nodoc
class __$ProfileCopyWithImpl<$Res>
    implements _$ProfileCopyWith<$Res> {
  __$ProfileCopyWithImpl(this._self, this._then);

  final _Profile _self;
  final $Res Function(_Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? employmentType = null,Object? employmentStartDate = null,Object? birthDate = null,Object? workSchedule = null,Object? priorService = null,Object? isUnderground = null,Object? contractExtraDays = null,Object? leaveUsedBeforeTracking = null,Object? isTeacher = null,Object? administrativeLeaveDays = null,Object? absencePeriods = null,}) {
  return _then(_Profile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,employmentType: null == employmentType ? _self.employmentType : employmentType // ignore: cast_nullable_to_non_nullable
as EmploymentType,employmentStartDate: null == employmentStartDate ? _self.employmentStartDate : employmentStartDate // ignore: cast_nullable_to_non_nullable
as DateTime,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime,workSchedule: null == workSchedule ? _self.workSchedule : workSchedule // ignore: cast_nullable_to_non_nullable
as WorkSchedule,priorService: null == priorService ? _self.priorService : priorService // ignore: cast_nullable_to_non_nullable
as ServiceDuration,isUnderground: null == isUnderground ? _self.isUnderground : isUnderground // ignore: cast_nullable_to_non_nullable
as bool,contractExtraDays: null == contractExtraDays ? _self.contractExtraDays : contractExtraDays // ignore: cast_nullable_to_non_nullable
as int,leaveUsedBeforeTracking: null == leaveUsedBeforeTracking ? _self.leaveUsedBeforeTracking : leaveUsedBeforeTracking // ignore: cast_nullable_to_non_nullable
as double,isTeacher: null == isTeacher ? _self.isTeacher : isTeacher // ignore: cast_nullable_to_non_nullable
as bool,administrativeLeaveDays: null == administrativeLeaveDays ? _self._administrativeLeaveDays : administrativeLeaveDays // ignore: cast_nullable_to_non_nullable
as List<DateTime>,absencePeriods: null == absencePeriods ? _self._absencePeriods : absencePeriods // ignore: cast_nullable_to_non_nullable
as List<DateRange>,
  ));
}

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkScheduleCopyWith<$Res> get workSchedule {
  
  return $WorkScheduleCopyWith<$Res>(_self.workSchedule, (value) {
    return _then(_self.copyWith(workSchedule: value));
  });
}/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServiceDurationCopyWith<$Res> get priorService {
  
  return $ServiceDurationCopyWith<$Res>(_self.priorService, (value) {
    return _then(_self.copyWith(priorService: value));
  });
}
}

// dart format on
