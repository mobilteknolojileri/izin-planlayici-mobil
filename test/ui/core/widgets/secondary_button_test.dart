import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/ui/core/widgets/secondary_button.dart';
import 'package:material_ui/material_ui.dart';

import '../golden_harness.dart';

void main() {
  coreGoldenTest(
    'SecondaryButton',
    fileName: 'secondary_button',
    builder: (_) => SecondaryButton(label: 'Vazgeç', onPressed: () {}),
  );

  testWidgets('is at least 48 dp high and calls back', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      testApp(SecondaryButton(label: 'Vazgeç', onPressed: () => taps++)),
    );
    expect(
      tester.getSize(find.byType(FilledButton)).height,
      greaterThanOrEqualTo(48),
    );
    await tester.tap(find.text('Vazgeç'));
    expect(taps, 1);
  });
}
