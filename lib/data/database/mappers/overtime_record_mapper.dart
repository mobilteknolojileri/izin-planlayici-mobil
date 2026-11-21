import 'package:izin_planla/data/database/app_database.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Converts between [OvertimeRecord] and its [OvertimeRecordRow], so drift
/// rows never leave the data layer.
abstract final class OvertimeRecordMapper {
  /// The domain model stored in [row].
  static OvertimeRecord toModel(OvertimeRecordRow row) => OvertimeRecord(
    id: row.id,
    profileId: row.profileId,
    date: row.date,
    hours: row.hours,
    note: row.note,
  );

  /// The row that stores [record].
  static OvertimeRecordRow toRow(OvertimeRecord record) => OvertimeRecordRow(
    id: record.id,
    profileId: record.profileId,
    date: record.date,
    hours: record.hours,
    note: record.note,
  );
}
