import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:izin_planla/domain/models/date_only_converter.dart';

part 'next_accrual.freezed.dart';
part 'next_accrual.g.dart';

/// The next day annual leave will be earned and how many days.
@freezed
abstract class NextAccrual with _$NextAccrual {
  /// Creates a next accrual.
  const factory({
    @DateOnlyConverter() required DateTime date,
    required int days,
  }) = _NextAccrual;

  /// Creates a next accrual from JSON.
  factory fromJson(Map<String, dynamic> json) => _$NextAccrualFromJson(json);
}
