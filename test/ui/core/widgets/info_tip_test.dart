import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/ui/core/widgets/info_tip.dart';
import 'package:material_ui/material_ui.dart';

import '../golden_harness.dart';

void main() {
  const tip = InfoTip(
    term: 'Arife',
    message: 'Bayramdan önceki gün, öğleden sonrası resmî tatildir.',
  );

  coreGoldenTest(
    'InfoTip',
    fileName: 'info_tip',
    builder: (_) => const Row(children: [Text('Arife'), tip]),
  );

  testWidgets('opens and closes the explanation', (tester) async {
    await tester.pumpWidget(testApp(const Center(child: tip)));
    expect(
      tester.getSize(find.byType(IconButton)).height,
      greaterThanOrEqualTo(48),
    );

    await tester.tap(find.byTooltip('Arife nedir?'));
    await tester.pumpAndSettle();
    expect(find.text(tip.message), findsOneWidget);

    await tester.tap(find.text('Tamam'));
    await tester.pumpAndSettle();
    expect(find.text(tip.message), findsNothing);
  });
}
