import 'dart:convert';

import 'package:drift/drift.dart';

/// Stores a list of integers as a JSON array, keeping the order.
class IntListConverter extends TypeConverter<List<int>, String> {
  /// Creates the converter.
  const new();

  @override
  List<int> fromSql(String fromDb) => [
    for (final item in jsonDecode(fromDb) as List<dynamic>) item as int,
  ];

  @override
  String toSql(List<int> value) => jsonEncode(value);
}
