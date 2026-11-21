import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/config/dependencies.dart';
import 'package:izin_planla/data/fakes/fake_leave_repository.dart';
import 'package:izin_planla/data/fakes/fake_overtime_repository.dart';
import 'package:izin_planla/data/fakes/fake_profile_repository.dart';
import 'package:izin_planla/data/fakes/fake_settings_repository.dart';
import 'package:izin_planla/data/fakes/sample_data.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/theme/app_theme.dart';
import 'package:izin_planla/ui/core/widgets/empty_state.dart';
import 'package:izin_planla/ui/leaves/view_models/leaves_view_model.dart';
import 'package:izin_planla/ui/leaves/widgets/leaves_screen.dart';
import 'package:izin_planla/ui/leaves/widgets/overtime_sheet.dart';
import 'package:material_ui/material_ui.dart';

import '../../../config/fake_dependencies.dart';
import '../../core/golden_harness.dart' show AndroidNonlinear200;

DateTime _now() => DateTime(2026, 11, 20, 9);

void main() {
  late FakeLeaveRepository leaves;
  late FakeOvertimeRepository overtime;

  setUp(() async {
    leaves = FakeLeaveRepository();
    overtime = FakeOvertimeRepository();
    // One hourly leave and one overtime record in 2026.
    await leaves.save(
      LeaveRecord(
        id: 'hourly',
        profileId: SampleData.profileId,
        type: LeaveType.annual,
        range: DateRange(
          start: DateTime.utc(2026, 9, 4),
          end: DateTime.utc(2026, 9, 4),
        ),
        unit: LeaveUnit.hours,
        hours: 3,
      ),
    );
    await leaves.save(
      LeaveRecord(
        id: 'sick',
        profileId: SampleData.profileId,
        type: LeaveType.sick,
        range: DateRange(
          start: DateTime.utc(2026, 2, 2),
          end: DateTime.utc(2026, 2, 4),
        ),
      ),
    );
    await overtime.save(
      OvertimeRecord(
        id: 'overtime',
        profileId: SampleData.profileId,
        date: DateTime.utc(2026, 10, 12),
        hours: 2.5,
        note: 'Sayım',
      ),
    );
  });

  Future<void> pump(
    WidgetTester tester, {
    List<Override> overrides = const [],
    TextScaler textScaler = TextScaler.noScaling,
    double width = 360,
    bool dark = false,
  }) async {
    tester.view
      ..physicalSize = Size(width, 6000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: withFakeDependencies([
          leavesViewModelProvider.overrideWith(
            () => LeavesViewModel(clock: _now),
          ),
          leaveRepositoryProvider.overrideWithValue(leaves),
          overtimeRepositoryProvider.overrideWithValue(overtime),
          ...overrides,
        ]),
        child: MaterialApp(
          theme: dark ? AppTheme.dark : AppTheme.light,
          locale: const Locale('tr'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: textScaler),
            child: child!,
          ),
          home: const LeavesScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> removeAll() async {
    for (final id in ['sample-leave-1', 'sample-leave-2', 'hourly', 'sick']) {
      await leaves.delete(id);
    }
  }

  Future<void> openHours(WidgetTester tester) async {
    await tester.tap(find.text('Saat ve mesai'));
    await tester.pumpAndSettle();
  }

  testWidgets('lists planned and used leave apart', (tester) async {
    await pump(tester);
    expect(find.text('İzinlerim'), findsOneWidget);
    expect(find.text('Yıl: 2026'), findsOneWidget);
    expect(find.text('Tür: Tümü'), findsOneWidget);
    expect(find.text('İzin ekle'), findsOneWidget);
    expect(find.text('Planlanan'), findsOneWidget);
    expect(find.text('Kullanılan'), findsOneWidget);
    // The fake counter counts Monday to Friday.
    expect(find.text('28-31 Aralık 2026'), findsOneWidget);
    expect(find.text('4 gün'), findsOneWidget);
    expect(find.text('6-10 Temmuz 2026'), findsOneWidget);
    expect(find.text('5 gün'), findsOneWidget);
    // Sick leave does not reduce the balance, so calendar days are shown.
    expect(find.text('Hastalık ve rapor'), findsOneWidget);
    expect(find.text('3 takvim günü'), findsOneWidget);
    // Hourly leave lives in the hours part.
    expect(find.text('3 saat'), findsNothing);
  });

  testWidgets('the type filter hides other types', (tester) async {
    await pump(tester);
    await tester.tap(find.text('Tür: Tümü'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hastalık ve rapor').last);
    await tester.pumpAndSettle();
    expect(find.text('Tür: Hastalık ve rapor'), findsOneWidget);
    expect(find.text('3 takvim günü'), findsOneWidget);
    expect(find.text('6-10 Temmuz 2026'), findsNothing);
  });

  testWidgets('the year filter shows that year only', (tester) async {
    await leaves.save(
      LeaveRecord(
        id: 'old',
        profileId: SampleData.profileId,
        type: LeaveType.annual,
        range: DateRange(
          start: DateTime.utc(2025, 8, 4),
          end: DateTime.utc(2025, 8, 8),
        ),
      ),
    );
    await pump(tester);
    expect(find.text('4-8 Ağustos 2025'), findsNothing);
    await tester.tap(find.text('Yıl: 2026'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2025'));
    await tester.pumpAndSettle();
    expect(find.text('Yıl: 2025'), findsOneWidget);
    expect(find.text('4-8 Ağustos 2025'), findsOneWidget);
    expect(find.text('Planlanan'), findsNothing);
  });

  testWidgets('shows the empty state without any leave', (tester) async {
    await removeAll();
    await pump(tester);
    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.text('Henüz izin eklemedin.'), findsOneWidget);
  });

  testWidgets('says how to start when there is no profile', (tester) async {
    final profiles = FakeProfileRepository();
    await profiles.delete(SampleData.profileId);
    final settings = FakeSettingsRepository();
    await settings.save(const AppSettings());
    await pump(
      tester,
      overrides: [
        profileRepositoryProvider.overrideWithValue(profiles),
        settingsRepositoryProvider.overrideWithValue(settings),
      ],
    );
    expect(
      find.text('İzinlerini görmek için önce kurulumu tamamla.'),
      findsOneWidget,
    );
  });

  testWidgets('the hours part totals overtime and hourly leave', (
    tester,
  ) async {
    await pump(tester);
    await openHours(tester);
    expect(find.text('Fazla mesai ekle'), findsOneWidget);
    expect(find.text('Fazla mesai kayıtları'), findsOneWidget);
    expect(find.text('2,5'), findsOneWidget);
    expect(find.text('2,5 saat'), findsOneWidget);
    expect(find.text('Sayım'), findsOneWidget);
    expect(find.text('Saatlik izinler'), findsOneWidget);
    expect(find.text('3 saat'), findsOneWidget);
  });

  testWidgets('the overtime sheet checks the hours before saving', (
    tester,
  ) async {
    await pump(tester);
    await openHours(tester);
    await tester.tap(find.text('Fazla mesai ekle'));
    await tester.pumpAndSettle();
    expect(find.byType(OvertimeSheet), findsOneWidget);
    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();
    expect(find.text('Saati yaz, örneğin 2 veya 1,5.'), findsOneWidget);
    await tester.enterText(
      find
          .descendant(
            of: find.byType(OvertimeSheet),
            matching: find.byType(TextFormField),
          )
          .first,
      '4',
    );
    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();
    expect(find.byType(OvertimeSheet), findsNothing);
    expect(find.text('4 saat'), findsOneWidget);
    expect(find.text('6,5'), findsOneWidget);
  });

  testWidgets('an overtime delete can be undone', (tester) async {
    await pump(tester);
    await openHours(tester);
    await tester.tap(find.text('2,5 saat'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sil'));
    await tester.pumpAndSettle();
    expect(find.text('Fazla mesai kaydı silindi.'), findsOneWidget);
    expect(find.text('2,5 saat'), findsNothing);
    await tester.tap(find.text('Geri al'));
    await tester.pumpAndSettle();
    expect(find.text('2,5 saat'), findsOneWidget);
  });

  final scalers = <String, TextScaler>{
    'x2 linear': const TextScaler.linear(2),
    'x2 android': const AndroidNonlinear200(),
  };
  for (final MapEntry(key: size, value: scaler) in scalers.entries) {
    for (final width in [320.0, 360.0]) {
      testWidgets('text $size, ${width.toInt()} wide: nothing overflows', (
        tester,
      ) async {
        await pump(tester, textScaler: scaler, width: width);
        expect(tester.takeException(), isNull);
        expect(find.text('Kullanılan'), findsOneWidget);
        await openHours(tester);
        expect(tester.takeException(), isNull);
        expect(find.text('Saatlik izinler'), findsOneWidget);
        await tester.tap(find.text('Fazla mesai ekle'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('empty, text $size, ${width.toInt()} wide: nothing '
          'overflows', (tester) async {
        await removeAll();
        await pump(tester, textScaler: scaler, width: width);
        expect(tester.takeException(), isNull);
      });
    }
  }

  for (final dark in [false, true]) {
    testWidgets('${dark ? 'dark' : 'light'}: both parts meet accessibility '
        'guidelines', (tester) async {
      final semantics = tester.ensureSemantics();
      await pump(tester, dark: dark);
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await openHours(tester);
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      semantics.dispose();
    });
  }

  testWidgets('empty state meets accessibility guidelines', (tester) async {
    final semantics = tester.ensureSemantics();
    await removeAll();
    await pump(tester);
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    semantics.dispose();
  });

  testWidgets('screen reader hears a leave row as one button', (tester) async {
    final semantics = tester.ensureSemantics();
    await pump(tester);
    expect(
      tester.getSemantics(find.text('6-10 Temmuz 2026')),
      isSemantics(
        label: 'Yıllık izin\n6-10 Temmuz 2026\n5 gün',
        isButton: true,
      ),
    );
    expect(
      tester.getSemantics(find.text('Saat ve mesai')),
      isSemantics(isSelected: false, isButton: true),
    );
    semantics.dispose();
  });
}
