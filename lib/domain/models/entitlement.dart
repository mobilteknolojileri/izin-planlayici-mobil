import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:izin_planla/domain/models/entitlement_period.dart';
import 'package:izin_planla/domain/models/next_accrual.dart';

part 'entitlement.freezed.dart';
part 'entitlement.g.dart';

/// All entitlement periods of a profile up to a date, and the next one.
@freezed
abstract class Entitlement with _$Entitlement {
  /// Creates an entitlement summary.
  const factory({
    required String profileId,
    @Default(<EntitlementPeriod>[]) List<EntitlementPeriod> periods,
    NextAccrual? next,
  }) = _Entitlement;

  /// Creates an entitlement summary from JSON.
  factory fromJson(Map<String, dynamic> json) => _$EntitlementFromJson(json);
}
