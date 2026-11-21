import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:izin_planla/domain/models/date_only_converter.dart';

/// Stores a list of calendar days as a JSON array of `yyyy-MM-dd` strings,
/// keeping the order.
class DayListConverter extends TypeConverter<List<DateTime>, String> {
  /// Creates the converter.
  const new();

  static const _json = DateOnlyConverter();

  @override
  List<DateTime> fromSql(String fromDb) => [
    for (final item in jsonDecode(fromDb) as List<dynamic>)
      _json.fromJson(item as String),
  ];

  @override
  String toSql(List<DateTime> value) =>
      jsonEncode([for (final day in value) _json.toJson(day)]);
}
