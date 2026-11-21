import 'package:intl/intl.dart';
import 'package:izin_planla/data/services/home_widget/home_widget_content.dart';
import 'package:izin_planla/data/services/home_widget/home_widget_entry.dart';
import 'package:izin_planla/domain/day_count/balance_calculator.dart';
import 'package:izin_planla/domain/entitlement/entitlement_calculator.dart';
import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';

/// Turns the user's data into the finished widget texts of the coming days.
///
/// Pure: the same input always gives the same [HomeWidgetContent], so the
/// texts are tested in Dart and the Kotlin provider stays a dumb renderer.
class HomeWidgetContentBuilder {
  /// Creates a builder that covers [horizonDays] days from today.
  const new({
    required this._entitlementCalculator,
    required this._balanceCalculator,
    required this._l10n,
    this.horizonDays = defaultHorizonDays,
  });

  /// About two months. Long enough for people who rarely open the app,
  /// short enough to keep the stored JSON small (about 15 KB).
  static const defaultHorizonDays = 60;

  /// Number of days, starting today, that get their own entry.
  final int horizonDays;

  final EntitlementCalculator _entitlementCalculator;
  final BalanceCalculator _balanceCalculator;
  final AppLocalizations _l10n;

  /// Builds the content for [today] and the following days.
  ///
  /// [profile] is the active profile, or null before setup. [holidays] may
  /// be in any order. Only the date part of [today] is used.
  HomeWidgetContent build({
    required Profile? profile,
    required List<LeaveRecord> leaves,
    required List<Holiday> holidays,
    required AppThemeMode themeMode,
    required DateTime today,
  }) {
    final start = _dateOnly(today);
    // Eves are only half days off, so the countdown targets the first full
    // holiday day, as people count down to the holiday itself.
    final fullDays =
        holidays.where((holiday) => holiday.type != HolidayType.eve).toList()
          ..sort((a, b) => a.date.compareTo(b.date));
    final days = <String, HomeWidgetEntry>{
      for (var offset = 0; offset < horizonDays; offset++)
        HomeWidgetContent.dateKey(_addDays(start, offset)): _entry(
          day: _addDays(start, offset),
          profile: profile,
          leaves: leaves,
          holidays: holidays,
          fullDays: fullDays,
        ),
    };
    return HomeWidgetContent(
      themeMode: themeMode,
      days: days,
      fallback: HomeWidgetEntry(
        value: '',
        caption: _l10n.homeWidgetStale,
        holiday: '',
        description: _l10n.homeWidgetStale,
      ),
    );
  }

  /// A day count in the app's number format, like `AppFormat.days`:
  /// `18`, `4,5`, `1.234`.
  String formatDays(num value) =>
      NumberFormat.decimalPattern(_l10n.localeName).format(value);

  HomeWidgetEntry _entry({
    required DateTime day,
    required Profile? profile,
    required List<LeaveRecord> leaves,
    required List<Holiday> holidays,
    required List<Holiday> fullDays,
  }) {
    final holiday = _holidayLine(day, fullDays);
    if (profile == null) return _message(_l10n.homeWidgetSetup, holiday);
    // 657 art. 103/2: teachers get no annual leave, so a number would
    // mislead.
    if (profile.isTeacher) return _message(_l10n.homeWidgetTeacher, holiday);

    final balance = _balanceCalculator.balance(
      profile: profile,
      periods: _entitlementCalculator.periods(profile, until: day),
      leaves: leaves,
      holidays: holidays,
      today: day,
    );
    // Sums of half days can leave float noise such as -1e-12, which must
    // not turn a zero balance into an overdrawn one.
    final remaining = (balance.remaining * 1000).round() / 1000;
    final overdrawn = remaining < 0;
    final value = formatDays(remaining.abs());
    final sentence = overdrawn
        ? _l10n.homeWidgetOverdrawnSentence(value)
        : _l10n.homeWidgetRemainingSentence(value);
    return HomeWidgetEntry(
      value: value,
      caption: overdrawn
          ? _l10n.homeWidgetOverdrawnCaption
          : _l10n.homeWidgetRemainingCaption,
      holiday: holiday,
      description: _l10n.homeWidgetDescription(sentence, holiday),
    );
  }

  HomeWidgetEntry _message(String message, String holiday) => HomeWidgetEntry(
    value: '',
    caption: message,
    holiday: holiday,
    description: _l10n.homeWidgetDescription(message, holiday),
  );

  String _holidayLine(DateTime day, List<Holiday> fullDays) {
    for (final holiday in fullDays) {
      final date = _dateOnly(holiday.date);
      if (date.isBefore(day)) continue;
      final daysLeft = date.difference(day).inDays;
      return switch (daysLeft) {
        0 => _l10n.homeWidgetHolidayToday(holiday.name),
        1 => _l10n.homeWidgetHolidayTomorrow(holiday.name),
        _ => _l10n.homeWidgetHolidayInDays(formatDays(daysLeft), holiday.name),
      };
    }
    return _l10n.homeWidgetNoHoliday;
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day);

  static DateTime _addDays(DateTime day, int days) =>
      DateTime.utc(day.year, day.month, day.day + days);
}
