import 'package:drift/drift.dart';
import 'package:izin_planla/data/database/converters/day_converter.dart';
import 'package:izin_planla/data/database/tables/profiles.dart';
import 'package:izin_planla/domain/models/models.dart';

/// One row per `LeaveRecord`. Rows are deleted with their profile.
@DataClassName('LeaveRecordRow')
@TableIndex(
  name: 'leave_records_profile_start',
  columns: {#profileId, #startDate},
)
class LeaveRecords extends Table {
  /// Stable id chosen by the app.
  TextColumn get id => text()();

  /// Owner profile.
  TextColumn get profileId =>
      text().references(Profiles, #id, onDelete: KeyAction.cascade)();

  /// Leave category, stored by enum name.
  TextColumn get type => textEnum<LeaveType>()();

  /// First day of the range.
  TextColumn get startDate => text().map(const DayConverter())();

  /// Last day of the range, inclusive.
  TextColumn get endDate => text().map(const DayConverter())();

  /// How the record is measured, stored by enum name.
  TextColumn get unit => textEnum<LeaveUnit>()();

  /// Hours for hourly leave.
  RealColumn get hours => real().nullable()();

  /// Name shown for `LeaveType.other`.
  TextColumn get customTypeName => text().nullable()();

  /// Event date, e.g. a child's birth date for paternity leave.
  TextColumn get eventDate => text().map(const DayConverter()).nullable()();

  /// `LeaveRecord.deductsFromAnnual`.
  BoolColumn get deductsFromAnnual => boolean()();

  /// Free text note.
  TextColumn get note => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  bool get isStrict => true;

  @override
  List<String> get customConstraints => [
    'CHECK (length(id) > 0)',
    '''
CHECK (type IN ('annual', 'sick', 'unpaid', 'maternity', 'paternity',
  'marriage', 'bereavement', 'adoption', 'disabledChildCare', 'union',
  'excuse', 'travel', 'other'))''',
    'CHECK (date(start_date) IS start_date)',
    'CHECK (date(end_date) IS end_date)',
    'CHECK (end_date >= start_date)',
    "CHECK (unit IN ('days', 'halfDay', 'hours'))",
    'CHECK (hours IS NULL OR hours > 0)',
    'CHECK (event_date IS NULL OR date(event_date) IS event_date)',
  ];
}
