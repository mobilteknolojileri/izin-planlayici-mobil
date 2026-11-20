import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:izin_planla/domain/models/app_theme_mode.dart';
import 'package:izin_planla/domain/models/notification_preferences.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

/// App-wide settings.
@freezed
abstract class AppSettings with _$AppSettings {
  /// Creates settings with defaults for a fresh install.
  const factory({
    @Default(AppThemeMode.system) AppThemeMode themeMode,

    /// Profile shown on the home screen, null before onboarding.
    String? activeProfileId,
    @Default(NotificationPreferences()) NotificationPreferences notifications,
  }) = _AppSettings;

  /// Creates settings from JSON.
  factory fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);
}
