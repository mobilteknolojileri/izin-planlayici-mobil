import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/data/services/notifications/stable_notification_id.dart';

void main() {
  test('matches 32-bit FNV-1a without the sign bit', () {
    expect(stableNotificationId(''), 18652613);
    expect(stableNotificationId('a'), 1678518572);
    expect(stableNotificationId('holiday:2027-01-01'), 301752626);
  });

  test('is the same on every call and differs between keys', () {
    expect(
      stableNotificationId('leave-start:l1'),
      stableNotificationId('leave-start:l1'),
    );
    expect(
      stableNotificationId('leave-start:l1'),
      isNot(stableNotificationId('leave-start:l2')),
    );
  });

  test('stays between 1 and the largest Android id', () {
    for (var i = 0; i < 1000; i++) {
      final id = stableNotificationId('key:$i');
      expect(id, inInclusiveRange(1, maxNotificationId));
      expect(id, isNot(testNotificationId));
    }
  });
}
