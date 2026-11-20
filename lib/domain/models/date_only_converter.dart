import 'package:json_annotation/json_annotation.dart';

/// Converts a calendar date to and from `yyyy-MM-dd`.
///
/// All dates in the domain are date-only values stored as UTC midnight, so
/// time zones and daylight saving never shift a leave day.
class DateOnlyConverter implements JsonConverter<DateTime, String> {
  /// Creates the converter.
  const new();

  @override
  DateTime fromJson(String json) {
    final parsed = DateTime.parse(json);
    return DateTime.utc(parsed.year, parsed.month, parsed.day);
  }

  @override
  String toJson(DateTime object) {
    final y = object.year.toString().padLeft(4, '0');
    final m = object.month.toString().padLeft(2, '0');
    final d = object.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
