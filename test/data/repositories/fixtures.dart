import 'dart:async';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:izin_planla/data/database/app_database.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Opens an empty in-memory database for one test.
AppDatabase openTestDatabase() {
  // Every test opens its own database on purpose.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase(NativeDatabase.memory());
}

/// A profile with the defaults of the model and the given [id].
Profile simpleProfile(String id) => Profile(
  id: id,
  name: 'Person $id',
  employmentType: EmploymentType.laborLaw,
  employmentStartDate: DateTime.utc(2019, 3, 15),
  birthDate: DateTime.utc(1990, 6),
);

/// A profile where every field differs from the model default, so a mapping
/// mistake in any column shows up.
Profile fullProfile([String id = 'full']) => Profile(
  id: id,
  name: 'Ayşe Çağlar',
  employmentType: EmploymentType.civilServant,
  employmentStartDate: DateTime.utc(2010, 9),
  birthDate: DateTime.utc(1975, 2, 28),
  workSchedule: const WorkSchedule(
    workDays: [6, 1, 2, 3, 4],
    weeklyRestDay: DateTime.saturday,
    saturdayCountsAsLeave: false,
    halfDayDeduction: HalfDayDeduction.full,
    dailyWorkingHours: 7.5,
  ),
  priorService: const ServiceDuration(years: 3, months: 2, days: 10),
  isUnderground: true,
  contractExtraDays: 2,
  leaveUsedBeforeTracking: 4.5,
  isTeacher: true,
  administrativeLeaveDays: [DateTime.utc(2026, 1, 2), DateTime.utc(2025, 12)],
  absencePeriods: [
    DateRange(start: DateTime.utc(2024, 5), end: DateTime.utc(2024, 5, 20)),
    DateRange(start: DateTime.utc(2023, 1, 10), end: DateTime.utc(2023, 1, 10)),
  ],
);

/// An annual leave of [profileId] from [start] to [end], or one day.
LeaveRecord leave(
  String id, {
  required DateTime start,
  String profileId = 'p1',
  DateTime? end,
  LeaveType type = LeaveType.annual,
}) => LeaveRecord(
  id: id,
  profileId: profileId,
  type: type,
  range: DateRange(start: start, end: end ?? start),
);

/// A leave where every optional field is set.
LeaveRecord fullLeave(String id, {String profileId = 'p1'}) => LeaveRecord(
  id: id,
  profileId: profileId,
  type: LeaveType.other,
  range: DateRange(
    start: DateTime.utc(2026, 5, 4),
    end: DateTime.utc(2026, 5, 4),
  ),
  unit: LeaveUnit.hours,
  hours: 2.5,
  customTypeName: 'Kan bağışı',
  eventDate: DateTime.utc(2026, 5),
  deductsFromAnnual: true,
  note: 'Öğleden sonra',
);

/// An overtime record of [profileId] on [date].
OvertimeRecord overtime(
  String id, {
  required DateTime date,
  String profileId = 'p1',
  double hours = 2,
  String? note,
}) => OvertimeRecord(
  id: id,
  profileId: profileId,
  date: date,
  hours: hours,
  note: note,
);

/// Reads emissions of a stream one by one, so a test can await the state
/// after each write.
final class Emissions<T> {
  /// Starts listening to [stream].
  new(Stream<T> stream) : _iterator = StreamIterator(stream);

  final StreamIterator<T> _iterator;

  /// The next emitted value. Throws [StateError] when the stream ended.
  Future<T> next() async {
    if (!await _iterator.moveNext()) throw StateError('Stream ended.');
    return _iterator.current;
  }

  /// Stops listening.
  Future<void> cancel() => _iterator.cancel();
}
