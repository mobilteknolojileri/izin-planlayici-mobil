import 'dart:ui' show Locale;

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:izin_planla/data/services/home_widget/home_widget_content.dart';
import 'package:izin_planla/data/services/home_widget/home_widget_content_builder.dart';
import 'package:izin_planla/data/services/home_widget/home_widget_entry.dart';
import 'package:izin_planla/domain/day_count/balance_calculator.dart';
import 'package:izin_planla/domain/entitlement/entitlement_calculator.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';

final AppLocalizations _l10n = lookupAppLocalizations(const Locale('tr'));

final _profile = Profile(
  id: 'p1',
  name: 'Ayşe',
  employmentType: EmploymentType.laborLaw,
  employmentStartDate: DateTime.utc(2019, 3, 15),
  birthDate: DateTime.utc(1990, 6),
);

Holiday _holiday(
  int year,
  int month,
  int day,
  String name, {
  HolidayType type = HolidayType.national,
}) => Holiday(
  date: DateTime.utc(year, month, day),
  name: name,
  type: type,
  halfDay: type == HolidayType.eve,
);

final List<Holiday> _holidays = [
  _holiday(2026, 10, 29, 'Cumhuriyet Bayramı'),
  _holiday(2027, 1, 1, 'Yılbaşı'),
];

/// Returns `remainingFor(today)` and records every call.
class _StubBalanceCalculator implements BalanceCalculator {
  new(this.remainingFor);

  final double Function(DateTime today) remainingFor;
  final List<DateTime> days = [];
  final List<List<EntitlementPeriod>> periods = [];

  @override
  LeaveBalance balance({
    required Profile profile,
    required List<EntitlementPeriod> periods,
    required List<LeaveRecord> leaves,
    required List<Holiday> holidays,
    required DateTime today,
  }) {
    days.add(today);
    this.periods.add(periods);
    final remaining = remainingFor(today);
    return LeaveBalance(earned: 0, used: 0, planned: 0, remaining: remaining);
  }
}

/// One 14-day period per call, dated at `until`, and records the dates.
class _StubEntitlementCalculator implements EntitlementCalculator {
  final List<DateTime> untils = [];

  @override
  List<EntitlementPeriod> periods(Profile profile, {required DateTime until}) {
    untils.add(until);
    return [EntitlementPeriod(accrualDate: until, days: 14)];
  }

  @override
  NextAccrual? nextAccrual(Profile profile, DateTime today) => null;
}

HomeWidgetContentBuilder _builder(
  BalanceCalculator balance, {
  EntitlementCalculator? entitlement,
  int horizonDays = HomeWidgetContentBuilder.defaultHorizonDays,
}) => HomeWidgetContentBuilder(
  entitlementCalculator: entitlement ?? _StubEntitlementCalculator(),
  balanceCalculator: balance,
  l10n: _l10n,
  horizonDays: horizonDays,
);

HomeWidgetContent _build({
  double remaining = 18,
  Profile? profile,
  bool noProfile = false,
  List<Holiday>? holidays,
  AppThemeMode themeMode = AppThemeMode.system,
  DateTime? today,
}) => _builder(_StubBalanceCalculator((_) => remaining)).build(
  profile: noProfile ? null : profile ?? _profile,
  leaves: const [],
  holidays: holidays ?? _holidays,
  themeMode: themeMode,
  today: today ?? DateTime(2026, 11, 21, 15, 30),
);

void main() {
  group('balance', () {
    test('typical balance shows the number and the remaining caption', () {
      final entry = _build().days['2026-11-21'];

      expect(
        entry,
        const HomeWidgetEntry(
          value: '18',
          caption: 'gün izin hakkın kaldı',
          holiday: '41 gün sonra resmî tatil: Yılbaşı',
          description:
              '18 gün izin hakkın kaldı. '
              '41 gün sonra resmî tatil: Yılbaşı',
        ),
      );
    });

    test('half days use the Turkish decimal comma', () {
      final entry = _build(remaining: 4.5).days['2026-11-21']!;

      expect(entry.value, '4,5');
      expect(entry.description, startsWith('4,5 gün izin hakkın kaldı.'));
    });

    test('zero balance is not overdrawn', () {
      final entry = _build(remaining: 0).days['2026-11-21']!;

      expect(entry.value, '0');
      expect(entry.caption, _l10n.homeWidgetRemainingCaption);
    });

    test('float noise around zero is not overdrawn', () {
      final entry = _build(remaining: -1e-12).days['2026-11-21']!;

      expect(entry.value, '0');
      expect(entry.caption, _l10n.homeWidgetRemainingCaption);
    });

    test('negative balance shows the overdrawn days without a sign', () {
      final entry = _build(remaining: -2.5).days['2026-11-21']!;

      expect(entry.value, '2,5');
      expect(entry.caption, 'gün fazla izin aldın');
      expect(entry.description, startsWith('2,5 gün fazla izin aldın.'));
    });

    test('no active profile asks to open the app and keeps the holiday', () {
      final entry = _build(noProfile: true).days['2026-11-21']!;

      expect(entry.value, isEmpty);
      expect(entry.caption, 'İzin hakkını görmek için uygulamayı aç');
      expect(entry.holiday, '41 gün sonra resmî tatil: Yılbaşı');
      expect(
        entry.description,
        'İzin hakkını görmek için uygulamayı aç. '
        '41 gün sonra resmî tatil: Yılbaşı',
      );
    });

    test('a teacher sees the explanation instead of a number', () {
      final entry = _build(
        profile: _profile.copyWith(
          employmentType: EmploymentType.civilServant,
          isTeacher: true,
        ),
      ).days['2026-11-21']!;

      expect(entry.value, isEmpty);
      expect(entry.caption, 'Öğretmenlere yıllık izin verilmez');
    });

    test('each day is calculated for that day', () {
      final entitlement = _StubEntitlementCalculator();
      // An accrual on 1 December adds 14 days.
      final balance = _StubBalanceCalculator(
        (day) => day.isBefore(DateTime.utc(2026, 12)) ? 3 : 17,
      );

      final content = _builder(balance, entitlement: entitlement).build(
        profile: _profile,
        leaves: const [],
        holidays: _holidays,
        themeMode: AppThemeMode.system,
        today: DateTime(2026, 11, 21, 23, 59),
      );

      expect(content.days['2026-11-30']!.value, '3');
      expect(content.days['2026-12-01']!.value, '17');
      expect(balance.days.first, DateTime.utc(2026, 11, 21));
      expect(entitlement.untils.first, DateTime.utc(2026, 11, 21));
      expect(balance.days.every((day) => day.isUtc), isTrue);
      expect(balance.periods.first.single.accrualDate, balance.days.first);
    });
  });

  group('holiday line', () {
    test('counts down to the next full holiday day', () {
      final content = _build(today: DateTime(2026, 10, 20));

      expect(
        content.days['2026-10-20']!.holiday,
        '9 gün sonra resmî tatil: Cumhuriyet Bayramı',
      );
    });

    test('says tomorrow and today', () {
      final content = _build(today: DateTime(2026, 10, 28));

      expect(
        content.days['2026-10-28']!.holiday,
        'Yarın resmî tatil: Cumhuriyet Bayramı',
      );
      expect(
        content.days['2026-10-29']!.holiday,
        'Bugün resmî tatil: Cumhuriyet Bayramı',
      );
      expect(content.days['2026-10-30']!.holiday, startsWith('63 gün sonra'));
    });

    test('skips half-day eves', () {
      final content = _build(
        holidays: [
          _holiday(
            2027,
            3,
            8,
            'Ramazan Bayramı Arifesi',
            type: HolidayType.eve,
          ),
          _holiday(
            2027,
            3,
            9,
            'Ramazan Bayramı 1. Gün',
            type: HolidayType.religious,
          ),
        ],
        today: DateTime(2027, 3, 8),
      );

      expect(
        content.days['2027-03-08']!.holiday,
        'Yarın resmî tatil: Ramazan Bayramı 1. Gün',
      );
    });

    test('runs across the year end and ignores the input order', () {
      final content = _build(
        holidays: [
          _holiday(2027, 4, 23, 'Ulusal Egemenlik ve Çocuk Bayramı'),
          _holiday(2027, 1, 1, 'Yılbaşı'),
          _holiday(2026, 10, 29, 'Cumhuriyet Bayramı'),
        ],
        today: DateTime(2026, 12, 31),
      );

      expect(content.days['2026-12-31']!.holiday, 'Yarın resmî tatil: Yılbaşı');
      expect(
        content.days['2027-01-02']!.holiday,
        '111 gün sonra resmî tatil: Ulusal Egemenlik ve Çocuk Bayramı',
      );
    });

    test('says so when the bundled list has no later holiday', () {
      final content = _build(holidays: const []);

      expect(
        content.days['2026-11-21']!.holiday,
        'Sıradaki resmî tatil bilgisi yok',
      );
    });
  });

  group('content', () {
    test('covers the horizon day by day from the local date', () {
      final content = _build(today: DateTime(2026, 11, 21, 0, 1));

      expect(content.days, hasLength(60));
      expect(content.days.keys.first, '2026-11-21');
      expect(content.days.keys, contains('2026-12-01'));
      expect(content.days.keys.last, '2027-01-19');
    });

    test('keeps the theme the user picked', () {
      for (final mode in AppThemeMode.values) {
        expect(_build(themeMode: mode).themeMode, mode);
      }
    });

    test('falls back to a prompt when the saved days run out', () {
      expect(
        _build().fallback,
        const HomeWidgetEntry(
          value: '',
          caption: 'Güncel bilgi için uygulamayı aç',
          holiday: '',
          description: 'Güncel bilgi için uygulamayı aç',
        ),
      );
    });
  });

  group('formatDays', () {
    final builder = _builder(_StubBalanceCalculator((_) => 0));

    test('matches the app number format', () {
      for (final value in [0, 1, 4.5, 18, 0.25, 1234, 41]) {
        expect(
          builder.formatDays(value),
          NumberFormat.decimalPattern('tr').format(value),
        );
      }
      expect(builder.formatDays(4.5), '4,5');
      expect(builder.formatDays(1234), '1.234');
      expect(builder.formatDays(18), '18');
    });
  });
}
