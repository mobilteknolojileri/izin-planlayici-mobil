import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/ui/core/theme/meaning.dart';
import 'package:izin_planla/ui/core/widgets/legend_row.dart';

import '../golden_harness.dart';

void main() {
  coreGoldenTest(
    'LegendRow',
    fileName: 'legend_row',
    builder: (_) => const LegendRow(meanings: Meaning.values),
  );

  testWidgets('shows a label for every meaning', (tester) async {
    await tester.pumpWidget(testApp(const LegendRow(meanings: Meaning.values)));
    for (final label in [
      'Kalan',
      'Kullanılan',
      'Planlanan',
      'Resmî tatil',
      'Arife (yarım gün)',
      'Hafta sonu',
      'Önerilen izin',
      'Çalışma günü',
    ]) {
      expect(find.text(label), findsOneWidget);
    }
  });
}
