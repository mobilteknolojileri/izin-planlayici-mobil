import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/database/mappers/overtime_record_mapper.dart';

import '../../repositories/fixtures.dart';

void main() {
  test('maps every overtime field to the row and back', () {
    final record = overtime(
      'o1',
      date: DateTime.utc(2026, 2, 3),
      hours: 1.5,
      note: 'Sayım',
    );

    expect(
      OvertimeRecordMapper.toModel(OvertimeRecordMapper.toRow(record)),
      record,
    );
  });
}
