import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/database/mappers/leave_record_mapper.dart';

import '../../repositories/fixtures.dart';

void main() {
  test('maps every leave field to the row and back', () {
    final record = fullLeave('l1');

    expect(LeaveRecordMapper.toModel(LeaveRecordMapper.toRow(record)), record);
  });

  test('keeps the model defaults', () {
    final record = leave('l1', start: DateTime.utc(2026, 7, 6));

    expect(LeaveRecordMapper.toModel(LeaveRecordMapper.toRow(record)), record);
  });
}
