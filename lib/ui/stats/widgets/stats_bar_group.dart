import 'package:material_ui/material_ui.dart';

/// One column of a `StatsBarChart`.
@immutable
class StatsBarGroup {
  /// Creates a column. A null [earned] draws only the used bar.
  const new({required this.label, required this.used, this.earned});

  /// Text under the column, such as `2026` or `Oca`.
  final String label;

  /// Days used.
  final double used;

  /// Days earned, or null.
  final double? earned;
}
