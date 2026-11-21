import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/ui/core/theme/color_groups.dart';
import 'package:izin_planla/ui/core/widgets/stat_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '../golden_harness.dart';

void main() {
  Widget card() => const StatCard(
    tint: AppTint.orange,
    icon: LucideIcons.flag,
    title: 'Sıradaki tatil',
    value: '42',
    unit: 'gün kaldı',
    detail: 'Yılbaşı, 1 Ocak',
  );

  coreGoldenTest('StatCard', fileName: 'stat_card', builder: (_) => card());

  testWidgets('reads the whole card as one sentence', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(testApp(card()));
    expect(
      find.bySemanticsLabel('Sıradaki tatil\n42\ngün kaldı\nYılbaşı, 1 Ocak'),
      findsOneWidget,
    );
    semantics.dispose();
  });
}
