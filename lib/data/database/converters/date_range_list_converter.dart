import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:izin_planla/domain/models/date_range.dart';

/// Stores a list of [DateRange] values as a JSON array of
/// `{"start": "yyyy-MM-dd", "end": "yyyy-MM-dd"}` objects, keeping the order.
class DateRangeListConverter extends TypeConverter<List<DateRange>, String> {
  /// Creates the converter.
  const new();

  @override
  List<DateRange> fromSql(String fromDb) => [
    for (final item in jsonDecode(fromDb) as List<dynamic>)
      DateRange.fromJson(item as Map<String, dynamic>),
  ];

  @override
  String toSql(List<DateRange> value) =>
      jsonEncode([for (final range in value) range.toJson()]);
}
