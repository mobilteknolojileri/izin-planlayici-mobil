import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/ui/core/theme/app_colors.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/widgets/balance_ring.dart';
import 'package:material_ui/material_ui.dart';

import '../golden_harness.dart';

/// The ring and legend on the hero colour they are drawn for.
Widget _onHero(double remaining, double used, double planned) => Builder(
  builder: (context) => ColoredBox(
    color: AppColors.of(context).hero.top,
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BalanceRing(remaining: remaining, used: used, planned: planned),
          const SizedBox(height: AppSpacing.md),
          BalanceLegend(remaining: remaining, used: used, planned: planned),
        ],
      ),
    ),
  ),
);

void main() {
  coreGoldenTest(
    'BalanceRing',
    fileName: 'balance_ring',
    builder: (_) => _onHero(18, 14, 4.5),
  );

  coreGoldenTest(
    'BalanceRing overdrawn',
    fileName: 'balance_ring_negative',
    builder: (_) => _onHero(-2, 16, 0),
  );

  testWidgets('reads all three values in one sentence', (tester) async {
    await tester.pumpWidget(testApp(_onHero(18, 14, 4.5)));
    await tester.pumpAndSettle();
    expect(
      find.bySemanticsLabel(
        'Kalan 18 gün, kullanılan 14 gün, planlanan 4,5 gün',
      ),
      findsOneWidget,
    );
  });

  testWidgets('legend names every part with its days', (tester) async {
    await tester.pumpWidget(testApp(_onHero(18, 14, 4.5)));
    await tester.pumpAndSettle();
    for (final label in [
      'Kalan 18 gün',
      'Kullanılan 14 gün',
      'Planlanan 4,5 gün',
    ]) {
      expect(find.text(label), findsOneWidget);
    }
  });
}
