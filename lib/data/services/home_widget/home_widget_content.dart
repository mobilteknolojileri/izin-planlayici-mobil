import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:izin_planla/data/services/home_widget/home_widget_entry.dart';
import 'package:izin_planla/domain/models/models.dart';

/// Everything the Android widget needs until the app runs again.
///
/// The widget cannot run Dart, so the texts of the coming days are worked
/// out in advance. The Kotlin provider picks the entry of the device's
/// current date, which keeps the holiday countdown right after midnight
/// without opening the app.
@immutable
class HomeWidgetContent {
  /// Creates the content.
  const new({
    required this.themeMode,
    required this.days,
    required this.fallback,
  });

  /// Storage key the Kotlin provider reads. Keep in sync with
  /// `LeaveWidgetProvider.kt`.
  static const storageKey = 'leave_widget_data';

  /// Version of the JSON layout, raised when the Kotlin side must change.
  static const formatVersion = 1;

  /// Theme the user picked in the app. `system` follows the launcher.
  final AppThemeMode themeMode;

  /// Entries keyed by local date as `yyyy-MM-dd`, one per coming day.
  final Map<String, HomeWidgetEntry> days;

  /// Shown when the device date has no entry, for example after the app was
  /// not opened for longer than the saved days cover.
  final HomeWidgetEntry fallback;

  /// The JSON object stored under [storageKey].
  Map<String, Object> toJson() => {
    'version': formatVersion,
    'theme': themeMode.name,
    'days': {
      for (final MapEntry(:key, :value) in days.entries) key: value.toJson(),
    },
    'fallback': fallback.toJson(),
  };

  /// [toJson] as a string, the only value type the widget storage needs.
  String encode() => jsonEncode(toJson());

  /// The `yyyy-MM-dd` key of [day], matching the Kotlin side.
  static String dateKey(DateTime day) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${day.year.toString().padLeft(4, '0')}-'
        '${two(day.month)}-${two(day.day)}';
  }
}
