import 'package:flutter/gestures.dart' show kLongPressTimeout;
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/ui/core/widgets/app_tab_bar.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '../golden_harness.dart';

void main() {
  const destinations = [
    AppTabDestination(icon: LucideIcons.house, label: 'Ana sayfa'),
    AppTabDestination(icon: LucideIcons.listChecks, label: 'İzinlerim'),
    AppTabDestination(icon: LucideIcons.calendarDays, label: 'Takvim'),
    AppTabDestination(icon: LucideIcons.treePalm, label: 'Köprü'),
    AppTabDestination(icon: LucideIcons.settings, label: 'Ayarlar'),
  ];

  Widget bar({ValueChanged<int>? onSelected, TextScaler? textScaler}) {
    final child = Align(
      alignment: Alignment.bottomCenter,
      child: AppTabBar(
        destinations: destinations,
        selectedIndex: 0,
        onSelected: onSelected ?? (_) {},
      ),
    );
    if (textScaler == null) return child;
    return Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: textScaler),
        child: child,
      ),
    );
  }

  testWidgets('a tap selects the tab', (tester) async {
    int? selected;
    await tester.pumpWidget(testApp(bar(onSelected: (i) => selected = i)));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Takvim').first);
    await tester.pumpAndSettle();
    expect(selected, 2);
  });

  testWidgets('every tab is a labelled button with a large target', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(testApp(bar()));
    await tester.pumpAndSettle();
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    semantics.dispose();
  });

  testWidgets('labels stop growing at 1.3 times, a long press shows the '
      'full size label', (tester) async {
    await tester.pumpWidget(
      testApp(bar(textScaler: const AndroidNonlinear200())),
    );
    await tester.pumpAndSettle();
    // The glass draws each label more than once (plain and inside the
    // lens), so counts are compared, not fixed.
    final labels = find.text('İzinlerim');
    for (final element in labels.evaluate()) {
      final paragraph = element.renderObject! as RenderParagraph;
      expect(
        paragraph.textScaler.scale(12),
        lessThanOrEqualTo(12 * AppTabBar.maxLabelScale + 0.01),
      );
    }
    final before = labels.evaluate().length;

    final press = await tester.startGesture(tester.getCenter(labels.first));
    await tester.pump(kLongPressTimeout + const Duration(milliseconds: 100));
    expect(labels.evaluate().length, before + 1);
    final viewer = tester.renderObject<RenderParagraph>(labels.last);
    expect(viewer.textScaler.scale(12), greaterThan(12 * 1.3));
    await press.up();
    await tester.pump();
    expect(labels.evaluate().length, before);
  });
}
