// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'applied_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppliedRule {

/// Stable identifier defined by the calculator. The UI maps it to a
/// localized sentence.
 String get code;/// Legal citation, e.g. `4857 md. 53`.
 String get legalReference;/// Values used in the sentence, e.g. `{'years': '5'}`.
 Map<String, String> get params;
/// Create a copy of AppliedRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppliedRuleCopyWith<AppliedRule> get copyWith => _$AppliedRuleCopyWithImpl<AppliedRule>(this as AppliedRule, _$identity);

  /// Serializes this AppliedRule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AppliedRule;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppliedRule&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.legalReference, _this.legalReference) || other.legalReference == _this.legalReference)&&const DeepCollectionEquality().equals(other.params, _this.params));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AppliedRule;
  return Object.hash(runtimeType,_this.code,_this.legalReference,const DeepCollectionEquality().hash(_this.params));
}

@override
String toString() {
  final _this = this as AppliedRule;
  return 'AppliedRule(code: ${_this.code}, legalReference: ${_this.legalReference}, params: ${_this.params})';
}


}

/// @nodoc
abstract mixin class $AppliedRuleCopyWith<$Res>  {
  factory $AppliedRuleCopyWith(AppliedRule value, $Res Function(AppliedRule) _then) = _$AppliedRuleCopyWithImpl;
@useResult
$Res call({
 String code, String legalReference, Map<String, String> params
});




}
/// @nodoc
class _$AppliedRuleCopyWithImpl<$Res>
    implements $AppliedRuleCopyWith<$Res> {
  _$AppliedRuleCopyWithImpl(this._self, this._then);

  final AppliedRule _self;
  final $Res Function(AppliedRule) _then;

/// Create a copy of AppliedRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? legalReference = null,Object? params = null,}) {
  return _then(AppliedRule(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,legalReference: null == legalReference ? _self.legalReference : legalReference // ignore: cast_nullable_to_non_nullable
as String,params: null == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AppliedRule].
extension AppliedRulePatterns on AppliedRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppliedRule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppliedRule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppliedRule value)  $default,){
final _that = this;
switch (_that) {
case _AppliedRule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppliedRule value)?  $default,){
final _that = this;
switch (_that) {
case _AppliedRule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String legalReference,  Map<String, String> params)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppliedRule() when $default != null:
return $default(_that.code,_that.legalReference,_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String legalReference,  Map<String, String> params)  $default,) {final _that = this;
switch (_that) {
case _AppliedRule():
return $default(_that.code,_that.legalReference,_that.params);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String legalReference,  Map<String, String> params)?  $default,) {final _that = this;
switch (_that) {
case _AppliedRule() when $default != null:
return $default(_that.code,_that.legalReference,_that.params);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppliedRule implements AppliedRule {
  const _AppliedRule({required this.code, required this.legalReference,  Map<String, String> params = const <String, String>{}}): _params = params;
  factory _AppliedRule.fromJson(Map<String, dynamic> json) => _$AppliedRuleFromJson(json);

/// Stable identifier defined by the calculator. The UI maps it to a
/// localized sentence.
@override final  String code;
/// Legal citation, e.g. `4857 md. 53`.
@override final  String legalReference;
/// Values used in the sentence, e.g. `{'years': '5'}`.
 final  Map<String, String> _params;
/// Values used in the sentence, e.g. `{'years': '5'}`.
@override@JsonKey() Map<String, String> get params {
  if (_params is EqualUnmodifiableMapView) return _params;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_params);
}


/// Create a copy of AppliedRule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppliedRuleCopyWith<_AppliedRule> get copyWith => __$AppliedRuleCopyWithImpl<_AppliedRule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppliedRuleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppliedRule&&(identical(other.code, code) || other.code == code)&&(identical(other.legalReference, legalReference) || other.legalReference == legalReference)&&const DeepCollectionEquality().equals(other.params, _params));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,code,legalReference,const DeepCollectionEquality().hash(_params));
}

@override
String toString() {
    return 'AppliedRule(code: $code, legalReference: $legalReference, params: $params)';
}


}

/// @nodoc
abstract mixin class _$AppliedRuleCopyWith<$Res> implements $AppliedRuleCopyWith<$Res> {
  factory _$AppliedRuleCopyWith(_AppliedRule value, $Res Function(_AppliedRule) _then) = __$AppliedRuleCopyWithImpl;
@override @useResult
$Res call({
 String code, String legalReference, Map<String, String> params
});




}
/// @nodoc
class __$AppliedRuleCopyWithImpl<$Res>
    implements _$AppliedRuleCopyWith<$Res> {
  __$AppliedRuleCopyWithImpl(this._self, this._then);

  final _AppliedRule _self;
  final $Res Function(_AppliedRule) _then;

/// Create a copy of AppliedRule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? legalReference = null,Object? params = null,}) {
  return _then(_AppliedRule(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,legalReference: null == legalReference ? _self.legalReference : legalReference // ignore: cast_nullable_to_non_nullable
as String,params: null == params ? _self._params : params // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
