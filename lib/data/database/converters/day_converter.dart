import 'package:drift/drift.dart';
import 'package:izin_planla/domain/models/date_only_converter.dart';

/// Stores a calendar day as `yyyy-MM-dd` text.
///
/// Text keeps the day free of time zones and sorts in date order. Reading
/// returns UTC midnight, the date convention of the domain models.
class DayConverter extends TypeConverter<DateTime, String> {
  /// Creates the converter.
  const new();

  static const _json = DateOnlyConverter();

  @override
  DateTime fromSql(String fromDb) => _json.fromJson(fromDb);

  @override
  String toSql(DateTime value) => _json.toJson(value);
}
