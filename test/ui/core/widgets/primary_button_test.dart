import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/ui/core/widgets/primary_button.dart';
import 'package:material_ui/material_ui.dart';

import '../golden_harness.dart';

void main() {
  coreGoldenTest(
    'PrimaryButton',
    fileName: 'primary_button',
    builder: (_) => Column(
      children: [
        PrimaryButton(label: 'İzin ekle', icon: Icons.add, onPressed: () {}),
        const SizedBox(height: 8),
        const PrimaryButton(label: 'Devam', onPressed: null),
      ],
    ),
  );

  testWidgets('is at least 48 dp high and calls back', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      testApp(PrimaryButton(label: 'Devam', onPressed: () => taps++)),
    );
    expect(
      tester.getSize(find.byType(FilledButton)).height,
      greaterThanOrEqualTo(48),
    );
    await tester.tap(find.text('Devam'));
    expect(taps, 1);
  });
}
