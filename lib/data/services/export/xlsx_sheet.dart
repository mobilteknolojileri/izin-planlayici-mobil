import 'package:izin_planla/data/services/export/xlsx_cell.dart';

/// One worksheet of a workbook written by `XlsxWriter`.
class XlsxSheet {
  /// Creates a sheet named [name] with [rows].
  ///
  /// [columnWidths] are in Excel character units, one per column from the
  /// left. When [freezeFirstRow] is true the header row stays visible while
  /// scrolling.
  const new({
    required this.name,
    required this.rows,
    this.columnWidths = const [],
    this.freezeFirstRow = false,
  });

  /// Tab name. Excel limits it to 31 characters without `[]:*?/\`, the
  /// writer cleans it.
  final String name;

  /// Cells row by row, from the top left.
  final List<List<XlsxCell>> rows;

  /// Width of each column in character units.
  final List<double> columnWidths;

  /// Whether the first row is frozen.
  final bool freezeFirstRow;
}
