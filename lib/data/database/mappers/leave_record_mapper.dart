import 'package:izin_planla/data/database/app_database.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Converts between [LeaveRecord] and its [LeaveRecordRow], so drift rows
/// never leave the data layer.
abstract final class LeaveRecordMapper {
  /// The domain model stored in [row].
  static LeaveRecord toModel(LeaveRecordRow row) => LeaveRecord(
    id: row.id,
    profileId: row.profileId,
    type: row.type,
    range: DateRange(start: row.startDate, end: row.endDate),
    unit: row.unit,
    hours: row.hours,
    customTypeName: row.customTypeName,
    eventDate: row.eventDate,
    deductsFromAnnual: row.deductsFromAnnual,
    note: row.note,
  );

  /// The row that stores [record].
  static LeaveRecordRow toRow(LeaveRecord record) => LeaveRecordRow(
    id: record.id,
    profileId: record.profileId,
    type: record.type,
    startDate: record.range.start,
    endDate: record.range.end,
    unit: record.unit,
    hours: record.hours,
    customTypeName: record.customTypeName,
    eventDate: record.eventDate,
    deductsFromAnnual: record.deductsFromAnnual,
    note: record.note,
  );
}
