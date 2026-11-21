import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/ui/core/widgets/balance_ring.dart';
import 'package:izin_planla/ui/core/widgets/big_number_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '../golden_harness.dart';

void main() {
  Widget card({VoidCallback? onAction}) => BigNumberCard(
    title: 'Kalan izin',
    icon: LucideIcons.treePalm,
    value: '18',
    unit: 'gün',
    caption: '2026 için 14 gün kullandın, 4 gün planladın.',
    trailing: const BalanceRing(remaining: 18, used: 14, planned: 4),
    footer: const BalanceLegend(remaining: 18, used: 14, planned: 4),
    actionLabel: 'Nasıl hesaplandı?',
    onAction: onAction ?? () {},
  );

  coreGoldenTest(
    'BigNumberCard',
    fileName: 'big_number_card',
    builder: (_) => card(),
  );

  testWidgets('reads title and number together', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(testApp(card()));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Kalan izin\n18 gün'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('the bottom row is a button', (tester) async {
    final semantics = tester.ensureSemantics();
    var taps = 0;
    await tester.pumpWidget(testApp(card(onAction: () => taps++)));
    await tester.pumpAndSettle();
    expect(
      tester.getSemantics(find.text('Nasıl hesaplandı?')),
      isSemantics(label: 'Nasıl hesaplandı?', isButton: true),
    );
    await tester.tap(find.text('Nasıl hesaplandı?'));
    expect(taps, 1);
    semantics.dispose();
  });

  testWidgets('moves the ring under the number with large text', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(
        Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const AndroidNonlinear200()),
            child: card(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final number = tester.getRect(find.text('18 gün', findRichText: true));
    final ring = tester.getRect(find.byType(BalanceRing));
    expect(ring.top, greaterThan(number.bottom));
  });
}
