import 'package:drift/drift.dart';
import 'package:izin_planla/data/database/converters/day_converter.dart';
import 'package:izin_planla/data/database/tables/profiles.dart';

/// One row per `OvertimeRecord`. Rows are deleted with their profile.
@DataClassName('OvertimeRecordRow')
@TableIndex(name: 'overtime_records_profile_date', columns: {#profileId, #date})
class OvertimeRecords extends Table {
  /// Stable id chosen by the app.
  TextColumn get id => text()();

  /// Owner profile.
  TextColumn get profileId =>
      text().references(Profiles, #id, onDelete: KeyAction.cascade)();

  /// Day the overtime was worked.
  TextColumn get date => text().map(const DayConverter())();

  /// Hours worked, always positive.
  RealColumn get hours => real()();

  /// Free text note.
  TextColumn get note => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  bool get isStrict => true;

  @override
  List<String> get customConstraints => [
    'CHECK (length(id) > 0)',
    'CHECK (date("date") IS "date")',
    'CHECK (hours > 0)',
  ];
}
