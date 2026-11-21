import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/ui/core/gallery/gallery_samples.dart';
import 'package:izin_planla/ui/core/widgets/week_strip.dart';

import '../golden_harness.dart';

void main() {
  coreGoldenTest(
    'WeekStrip',
    fileName: 'week_strip',
    builder: (_) => WeekStrip(days: GallerySamples.bridgeDays),
  );

  testWidgets('reads date and meaning of each day', (tester) async {
    await tester.pumpWidget(
      testApp(WeekStrip(days: GallerySamples.bridgeDays)),
    );
    expect(
      find.bySemanticsLabel('23 Nisan 2026, Perşembe, Resmî tatil'),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel('24 Nisan 2026, Cuma, Önerilen izin'),
      findsOneWidget,
    );
  });
}
