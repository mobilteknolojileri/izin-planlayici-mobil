import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/utils/result.dart';

/// Stores leave records. Implemented with drift by task 10.
abstract interface class LeaveRepository {
  /// Emits the leave records of [profileId] now and after every change.
  Stream<List<LeaveRecord>> watchForProfile(String profileId);

  /// Adds or replaces [record].
  Future<Result<void>> save(LeaveRecord record);

  /// Deletes the record with [id].
  Future<Result<void>> delete(String id);
}
