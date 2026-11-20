import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:izin_planla/domain/models/applied_rule.dart';
import 'package:izin_planla/domain/models/date_only_converter.dart';

part 'entitlement_period.freezed.dart';
part 'entitlement_period.g.dart';

/// Annual leave earned on one accrual date.
@freezed
abstract class EntitlementPeriod with _$EntitlementPeriod {
  /// Creates an entitlement period.
  const factory({
    /// Day the right is earned.
    @DateOnlyConverter() required DateTime accrualDate,

    /// Days earned on [accrualDate].
    required int days,

    /// Calendar year the right belongs to (657), or null for 4857.
    int? calendarYear,

    /// Day the unused part is dropped (657 art. 103), or null if never.
    @DateOnlyConverter() DateTime? expiresOn,
    @Default(<AppliedRule>[]) List<AppliedRule> rules,
  }) = _EntitlementPeriod;

  /// Creates an entitlement period from JSON.
  factory fromJson(Map<String, dynamic> json) =>
      _$EntitlementPeriodFromJson(json);
}
