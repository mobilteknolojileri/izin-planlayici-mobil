import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/ui/core/gallery/gallery_samples.dart';
import 'package:izin_planla/ui/core/theme/color_groups.dart';
import 'package:izin_planla/ui/core/widgets/inset_card.dart';
import 'package:izin_planla/ui/core/widgets/week_strip.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '../golden_harness.dart';

void main() {
  Widget card({VoidCallback? onTap}) => InsetCard(
    header: const CardHeader(
      tint: AppTint.blue,
      icon: LucideIcons.bridge,
      title: 'Köprü önerisi',
      chevron: true,
    ),
    summary: const Text('1 gün izinle 4 gün tatil, 23-26 Nisan'),
    onTap: onTap ?? () {},
    child: WeekStrip(days: GallerySamples.bridgeDays),
  );

  coreGoldenTest('InsetCard', fileName: 'inset_card', builder: (_) => card());

  testWidgets('header and summary are one button, the days stay apart', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var taps = 0;
    await tester.pumpWidget(testApp(card(onTap: () => taps++)));
    expect(
      tester.getSemantics(find.text('Köprü önerisi')),
      isSemantics(
        label: 'Köprü önerisi\n1 gün izinle 4 gün tatil, 23-26 Nisan',
        isButton: true,
      ),
    );
    expect(
      find.bySemanticsLabel('24 Nisan 2026, Cuma, Önerilen izin'),
      findsOneWidget,
    );
    await tester.tap(find.text('Köprü önerisi'));
    expect(taps, 1);
    semantics.dispose();
  });
}
