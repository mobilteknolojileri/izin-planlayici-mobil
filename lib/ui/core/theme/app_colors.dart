import 'package:izin_planla/ui/core/theme/app_palette.dart';
import 'package:izin_planla/ui/core/theme/color_groups.dart';
import 'package:izin_planla/ui/core/theme/meaning.dart';
import 'package:izin_planla/ui/core/theme/meaning_colors.dart';
import 'package:material_ui/material_ui.dart';

/// Colours the Material `ColorScheme` has no role for: one pair per
/// [Meaning], the hero card, the card header tints, the glass tab bar and
/// the main button.
///
/// Read with [AppColors.of]. Both themes in `AppTheme` carry an instance.
/// `test/ui/core/theme/app_theme_test.dart` holds every pair to WCAG AA.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  /// Creates the extension. Use [light] or [dark].
  const new({
    required this.remaining,
    required this.used,
    required this.planned,
    required this.holiday,
    required this.eve,
    required this.weekend,
    required this.bridge,
    required this.workday,
    required this.hero,
    required this.blue,
    required this.green,
    required this.orange,
    required this.purple,
    required this.tabBar,
    required this.action,
  });

  /// Colours of the light theme.
  static const light = AppColors(
    remaining: MeaningColors(
      fill: AppPalette.blue91,
      accent: AppPalette.blue20,
    ),
    used: MeaningColors(fill: AppPalette.green94, accent: AppPalette.green39),
    planned: MeaningColors(
      fill: AppPalette.amber96,
      accent: AppPalette.amber37,
    ),
    holiday: MeaningColors(fill: AppPalette.red93, accent: AppPalette.red39),
    eve: MeaningColors(fill: AppPalette.orange94, accent: AppPalette.orange38),
    weekend: MeaningColors(fill: AppPalette.grey92, accent: AppPalette.grey31),
    bridge: MeaningColors(fill: AppPalette.blue37, accent: AppPalette.grey100),
    workday: MeaningColors(fill: AppPalette.grey96, accent: AppPalette.grey26),
    hero: HeroColors(
      top: AppPalette.blue40,
      bottom: AppPalette.blue20,
      onHero: AppPalette.grey100,
      muted: AppPalette.blue91,
      ringRemaining: AppPalette.blue79,
      ringUsed: AppPalette.grey100,
      ringPlanned: AppPalette.amber86,
      ringTrack: AppPalette.grey100a08,
      wave: AppPalette.grey100a04,
    ),
    blue: TintColors(
      icon: AppPalette.blue91,
      onIcon: AppPalette.blue37,
      title: AppPalette.blue37,
    ),
    green: TintColors(
      icon: AppPalette.green94,
      onIcon: AppPalette.green39,
      title: AppPalette.green45,
    ),
    orange: TintColors(
      icon: AppPalette.orange94,
      onIcon: AppPalette.orange38,
      title: AppPalette.orange45,
    ),
    purple: TintColors(
      icon: AppPalette.purple93,
      onIcon: AppPalette.purple42,
      title: AppPalette.purple42,
    ),
    tabBar: TabBarColors(
      glass: AppPalette.grey100a85,
      selected: AppPalette.blue37,
      unselected: AppPalette.grey10,
    ),
    action: ActionColors(top: AppPalette.blue47, bottom: AppPalette.blue34),
  );

  /// Colours of the dark theme.
  static const dark = AppColors(
    remaining: MeaningColors(
      fill: AppPalette.blue21,
      accent: AppPalette.blue91,
    ),
    used: MeaningColors(fill: AppPalette.green17, accent: AppPalette.green74),
    planned: MeaningColors(
      fill: AppPalette.amber17,
      accent: AppPalette.amber87,
    ),
    holiday: MeaningColors(fill: AppPalette.red15, accent: AppPalette.red70),
    eve: MeaningColors(fill: AppPalette.orange18, accent: AppPalette.orange78),
    weekend: MeaningColors(fill: AppPalette.grey14, accent: AppPalette.grey80),
    bridge: MeaningColors(fill: AppPalette.blue64, accent: AppPalette.grey00),
    workday: MeaningColors(fill: AppPalette.grey18, accent: AppPalette.grey93),
    hero: HeroColors(
      top: AppPalette.blue37,
      bottom: AppPalette.blue13,
      onHero: AppPalette.grey100,
      muted: AppPalette.blue91,
      ringRemaining: AppPalette.blue79,
      ringUsed: AppPalette.grey100,
      ringPlanned: AppPalette.amber86,
      ringTrack: AppPalette.grey100a08,
      wave: AppPalette.grey100a04,
    ),
    blue: TintColors(
      icon: AppPalette.blue21,
      onIcon: AppPalette.blue73,
      title: AppPalette.blue73,
    ),
    green: TintColors(
      icon: AppPalette.green17,
      onIcon: AppPalette.green74,
      title: AppPalette.green74,
    ),
    orange: TintColors(
      icon: AppPalette.orange18,
      onIcon: AppPalette.orange74,
      title: AppPalette.orange74,
    ),
    purple: TintColors(
      icon: AppPalette.purple18,
      onIcon: AppPalette.purple93,
      title: AppPalette.purple57,
    ),
    tabBar: TabBarColors(
      glass: AppPalette.grey10a85,
      selected: AppPalette.blue73,
      unselected: AppPalette.grey96,
    ),
    action: ActionColors(top: AppPalette.blue71, bottom: AppPalette.blue59),
  );

  /// Colours of [Meaning.remaining].
  final MeaningColors remaining;

  /// Colours of [Meaning.used].
  final MeaningColors used;

  /// Colours of [Meaning.planned].
  final MeaningColors planned;

  /// Colours of [Meaning.holiday].
  final MeaningColors holiday;

  /// Colours of [Meaning.eve].
  final MeaningColors eve;

  /// Colours of [Meaning.weekend].
  final MeaningColors weekend;

  /// Colours of [Meaning.bridge].
  final MeaningColors bridge;

  /// Colours of [Meaning.workday].
  final MeaningColors workday;

  /// Colours of the hero card.
  final HeroColors hero;

  /// Colours of [AppTint.blue].
  final TintColors blue;

  /// Colours of [AppTint.green].
  final TintColors green;

  /// Colours of [AppTint.orange].
  final TintColors orange;

  /// Colours of [AppTint.purple].
  final TintColors purple;

  /// Colours of the glass tab bar.
  final TabBarColors tabBar;

  /// Colours of the main button.
  final ActionColors action;

  /// The extension of the current theme.
  ///
  /// Asserts instead of falling back, because a fallback would ship colours
  /// that no contrast test has checked.
  static AppColors of(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();
    assert(colors != null, 'AppColors missing, use AppTheme.light or dark.');
    return colors!;
  }

  /// Colours of [meaning].
  MeaningColors forMeaning(Meaning meaning) => switch (meaning) {
    Meaning.remaining => remaining,
    Meaning.used => used,
    Meaning.planned => planned,
    Meaning.holiday => holiday,
    Meaning.eve => eve,
    Meaning.weekend => weekend,
    Meaning.bridge => bridge,
    Meaning.workday => workday,
  };

  /// Colours of [tint].
  TintColors forTint(AppTint tint) => switch (tint) {
    AppTint.blue => blue,
    AppTint.green => green,
    AppTint.orange => orange,
    AppTint.purple => purple,
  };

  @override
  AppColors copyWith({
    MeaningColors? remaining,
    MeaningColors? used,
    MeaningColors? planned,
    MeaningColors? holiday,
    MeaningColors? eve,
    MeaningColors? weekend,
    MeaningColors? bridge,
    MeaningColors? workday,
    HeroColors? hero,
    TintColors? blue,
    TintColors? green,
    TintColors? orange,
    TintColors? purple,
    TabBarColors? tabBar,
    ActionColors? action,
  }) => AppColors(
    remaining: remaining ?? this.remaining,
    used: used ?? this.used,
    planned: planned ?? this.planned,
    holiday: holiday ?? this.holiday,
    eve: eve ?? this.eve,
    weekend: weekend ?? this.weekend,
    bridge: bridge ?? this.bridge,
    workday: workday ?? this.workday,
    hero: hero ?? this.hero,
    blue: blue ?? this.blue,
    green: green ?? this.green,
    orange: orange ?? this.orange,
    purple: purple ?? this.purple,
    tabBar: tabBar ?? this.tabBar,
    action: action ?? this.action,
  );

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      remaining: MeaningColors.lerp(remaining, other.remaining, t),
      used: MeaningColors.lerp(used, other.used, t),
      planned: MeaningColors.lerp(planned, other.planned, t),
      holiday: MeaningColors.lerp(holiday, other.holiday, t),
      eve: MeaningColors.lerp(eve, other.eve, t),
      weekend: MeaningColors.lerp(weekend, other.weekend, t),
      bridge: MeaningColors.lerp(bridge, other.bridge, t),
      workday: MeaningColors.lerp(workday, other.workday, t),
      hero: HeroColors.lerp(hero, other.hero, t),
      blue: TintColors.lerp(blue, other.blue, t),
      green: TintColors.lerp(green, other.green, t),
      orange: TintColors.lerp(orange, other.orange, t),
      purple: TintColors.lerp(purple, other.purple, t),
      tabBar: TabBarColors.lerp(tabBar, other.tabBar, t),
      action: ActionColors.lerp(action, other.action, t),
    );
  }
}
