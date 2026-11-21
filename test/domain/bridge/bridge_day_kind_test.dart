import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/domain/bridge/bridge_day_kind.dart';

void main() {
  test('only free days need no leave', () {
    expect(BridgeDayKind.free.needsLeave, isFalse);
    expect(BridgeDayKind.workday.needsLeave, isTrue);
    expect(BridgeDayKind.eve.needsLeave, isTrue);
  });
}
