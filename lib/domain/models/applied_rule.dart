import 'package:freezed_annotation/freezed_annotation.dart';

part 'applied_rule.freezed.dart';
part 'applied_rule.g.dart';

/// A legal rule applied in a calculation, shown on the "how was it
/// calculated" screen.
@freezed
abstract class AppliedRule with _$AppliedRule {
  /// Creates an applied rule.
  const factory({
    /// Stable identifier defined by the calculator. The UI maps it to a
    /// localized sentence.
    required String code,

    /// Legal citation, e.g. `4857 md. 53`.
    required String legalReference,

    /// Values used in the sentence, e.g. `{'years': '5'}`.
    @Default(<String, String>{}) Map<String, String> params,
  }) = _AppliedRule;

  /// Creates an applied rule from JSON.
  factory fromJson(Map<String, dynamic> json) => _$AppliedRuleFromJson(json);
}
