import 'package:izin_planla/data/repositories/leave_repository.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/utils/result.dart';

/// [LeaveRepository] over a fixed list of records.
class StubLeaveRepository implements LeaveRepository {
  /// Creates a repository holding [records].
  new(List<LeaveRecord> records) : _records = [...records];

  final List<LeaveRecord> _records;

  @override
  Stream<List<LeaveRecord>> watchForProfile(String profileId) => Stream.value([
    ..._records.where((record) => record.profileId == profileId),
  ]);

  @override
  Future<Result<void>> save(LeaveRecord record) async {
    _records
      ..removeWhere((r) => r.id == record.id)
      ..add(record);
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> delete(String id) async {
    _records.removeWhere((r) => r.id == id);
    return const Result.ok(null);
  }
}
