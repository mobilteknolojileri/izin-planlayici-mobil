import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/ui/core/gallery/gallery_samples.dart';
import 'package:izin_planla/ui/core/theme/meaning.dart';
import 'package:izin_planla/ui/core/widgets/day_breakdown_list.dart';

import '../golden_harness.dart';

void main() {
  coreGoldenTest(
    'DayBreakdownList',
    fileName: 'day_breakdown_list',
    builder: (_) => DayBreakdownList(days: GallerySamples.breakdown),
  );

  testWidgets('reads date, reason and deduction of each day', (tester) async {
    await tester.pumpWidget(
      testApp(DayBreakdownList(days: GallerySamples.breakdown)),
    );
    expect(
      find.bySemanticsLabel(
        '28 Ekim 2026, Çarşamba, '
        'Cumhuriyet Bayramı Arifesi, öğleden sonra tatil: Yarım gün',
      ),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel(
        '29 Ekim 2026, Perşembe, Resmî tatil: Cumhuriyet Bayramı: Sayılmaz',
      ),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel('27 Ekim 2026, Salı, Çalışma günü: 1 gün'),
      findsOneWidget,
    );
  });

  test('every reason has a mark', () {
    for (final reason in DayReason.values) {
      final day = DayBreakdown(
        date: DateTime.utc(2026),
        value: 0,
        reason: reason,
      );
      expect(Meaning.values, contains(DayBreakdownList.meaningOf(day)));
    }
  });
}
