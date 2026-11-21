import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/ui/core/theme/app_colors.dart';
import 'package:izin_planla/ui/core/theme/app_theme.dart';
import 'package:izin_planla/ui/core/theme/app_typography.dart';
import 'package:izin_planla/ui/core/theme/color_groups.dart';
import 'package:izin_planla/ui/core/theme/meaning.dart';
import 'package:material_ui/material_ui.dart';

/// WCAG 2.x contrast ratio of two opaque colours.
double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final (hi, lo) = la > lb ? (la, lb) : (lb, la);
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  for (final (name, theme) in [
    ('light', AppTheme.light),
    ('dark', AppTheme.dark),
  ]) {
    group('$name theme', () {
      final s = theme.colorScheme;
      final colors = theme.extension<AppColors>()!;

      test('uses Inter and carries AppColors', () {
        expect(
          theme.textTheme.bodyMedium?.fontFamily,
          AppTypography.fontFamily,
        );
        expect(theme.extension<AppColors>(), isNotNull);
      });

      // Text pairs need 4.5:1 (WCAG 1.4.3).
      final textPairs = {
        'onSurface on surface': (s.onSurface, s.surface),
        'onSurfaceVariant on surface': (s.onSurfaceVariant, s.surface),
        'onSurfaceVariant on surfaceContainerHighest': (
          s.onSurfaceVariant,
          s.surfaceContainerHighest,
        ),
        'onSurface on surfaceContainerLow': (
          s.onSurface,
          s.surfaceContainerLow,
        ),
        'primary on surface': (s.primary, s.surface),
        'primary on surfaceContainerLow': (s.primary, s.surfaceContainerLow),
        'onPrimary on primary': (s.onPrimary, s.primary),
        'onPrimaryContainer on primaryContainer': (
          s.onPrimaryContainer,
          s.primaryContainer,
        ),
        'onSecondary on secondary': (s.onSecondary, s.secondary),
        'onSecondaryContainer on secondaryContainer': (
          s.onSecondaryContainer,
          s.secondaryContainer,
        ),
        'onTertiary on tertiary': (s.onTertiary, s.tertiary),
        'onTertiaryContainer on tertiaryContainer': (
          s.onTertiaryContainer,
          s.tertiaryContainer,
        ),
        'onError on error': (s.onError, s.error),
        'onErrorContainer on errorContainer': (
          s.onErrorContainer,
          s.errorContainer,
        ),
        'onInverseSurface on inverseSurface': (
          s.onInverseSurface,
          s.inverseSurface,
        ),
        'inversePrimary on inverseSurface': (
          s.inversePrimary,
          s.inverseSurface,
        ),
        'onSurface on card': (s.onSurface, theme.cardColor),
        'onSurfaceVariant on card': (s.onSurfaceVariant, theme.cardColor),
        'primary on card': (s.primary, theme.cardColor),
        'onSurface on surfaceContainerHigh': (
          s.onSurface,
          s.surfaceContainerHigh,
        ),
      };
      for (final MapEntry(key: pair, value: (fg, bg)) in textPairs.entries) {
        test('$pair is at least 4.5:1', () {
          expect(contrast(fg, bg), greaterThanOrEqualTo(4.5));
        });
      }

      // Cards are white in the light theme and raised grey in the dark one.
      final card = theme.cardColor;

      for (final meaning in Meaning.values) {
        final c = colors.forMeaning(meaning);
        // Day numbers and icons sit on the fill, so they need the text
        // ratio (WCAG 1.4.3).
        test('${meaning.name} accent on fill is at least 4.5:1', () {
          expect(contrast(c.accent, c.fill), greaterThanOrEqualTo(4.5));
        });
        // The mark stays visible on a card through its fill or its accent
        // (WCAG 1.4.11).
        test('${meaning.name} mark is at least 3:1 on the card', () {
          final best = [
            contrast(c.fill, card),
            contrast(c.accent, card),
          ].reduce((a, b) => a > b ? a : b);
          expect(best, greaterThanOrEqualTo(3));
        });
      }

      final hero = colors.hero;
      final chip = Color.alphaBlend(
        hero.onHero.withValues(alpha: 0.12),
        hero.top,
      );
      for (final (name, end) in [('top', hero.top), ('bottom', hero.bottom)]) {
        test('hero text and muted text are at least 4.5:1 on $name', () {
          expect(contrast(hero.onHero, end), greaterThanOrEqualTo(4.5));
          expect(contrast(hero.muted, end), greaterThanOrEqualTo(4.5));
        });
        test('ring segments are at least 3:1 on hero $name', () {
          for (final segment in [
            hero.ringRemaining,
            hero.ringUsed,
            hero.ringPlanned,
          ]) {
            expect(contrast(segment, end), greaterThanOrEqualTo(3));
          }
        });
      }
      test('hero text keeps 4.5:1 over the light wave', () {
        for (final end in [hero.top, hero.bottom]) {
          final lit = Color.alphaBlend(hero.wave, end);
          expect(contrast(hero.onHero, lit), greaterThanOrEqualTo(4.5));
          expect(contrast(hero.muted, lit), greaterThanOrEqualTo(4.5));
        }
      });

      test('main button label is at least 4.5:1 on its gradient', () {
        for (final stop in [colors.action.top, colors.action.bottom]) {
          expect(contrast(s.onPrimary, stop), greaterThanOrEqualTo(4.5));
        }
      });

      test('legend chip text is at least 4.5:1', () {
        expect(contrast(hero.onHero, chip), greaterThanOrEqualTo(4.5));
      });
      test('ring segments are at least 3:1 on the ring track', () {
        for (final end in [hero.top, hero.bottom]) {
          final track = Color.alphaBlend(hero.ringTrack, end);
          for (final segment in [
            hero.ringRemaining,
            hero.ringUsed,
            hero.ringPlanned,
          ]) {
            expect(contrast(segment, track), greaterThanOrEqualTo(3));
          }
        }
      });

      for (final tint in AppTint.values) {
        final t = colors.forTint(tint);
        // The pale square is decorative, the glyph must stand out on the
        // square and on the card.
        test('${tint.name} tint: title 4.5:1, glyph 4.5:1 and 3:1', () {
          expect(contrast(t.title, card), greaterThanOrEqualTo(4.5));
          expect(contrast(t.onIcon, t.icon), greaterThanOrEqualTo(4.5));
          expect(contrast(t.onIcon, card), greaterThanOrEqualTo(3));
        });
      }

      // The tab bar is translucent. Its tint must keep the labels at 4.5:1
      // whatever scrolls behind it.
      final bar = colors.tabBar;
      final backdrops = <Color>[
        const Color(0xFF000000),
        const Color(0xFFFFFFFF),
        s.surface,
        card,
        s.primary,
        hero.top,
        hero.bottom,
        hero.ringRemaining,
        hero.ringPlanned,
        for (final tint in AppTint.values) colors.forTint(tint).icon,
        for (final meaning in Meaning.values) colors.forMeaning(meaning).fill,
      ];
      test('tab labels are at least 4.5:1 over any backdrop', () {
        for (final backdrop in backdrops) {
          final glass = Color.alphaBlend(bar.glass, backdrop);
          expect(
            contrast(bar.selected, glass),
            greaterThanOrEqualTo(4.5),
            reason: 'selected over $backdrop',
          );
          expect(
            contrast(bar.unselected, glass),
            greaterThanOrEqualTo(4.5),
            reason: 'unselected over $backdrop',
          );
        }
      });

      test('buttons stand out from the background by 3:1', () {
        expect(contrast(s.primary, s.surface), greaterThanOrEqualTo(3));
        expect(contrast(s.primary, card), greaterThanOrEqualTo(3));
        expect(contrast(s.outline, s.surface), greaterThanOrEqualTo(3));
        expect(contrast(s.outline, card), greaterThanOrEqualTo(3));
      });
    });
  }

  test('meaning icons and patterns are all different', () {
    const meanings = Meaning.values;
    expect(meanings.map((m) => m.icon).toSet(), hasLength(meanings.length));
    expect(meanings.map((m) => m.pattern).toSet(), hasLength(meanings.length));
  });

  test('AppColors lerp ends at both themes', () {
    for (final meaning in Meaning.values) {
      expect(
        AppColors.light.lerp(AppColors.dark, 0).forMeaning(meaning),
        AppColors.light.forMeaning(meaning),
      );
      expect(
        AppColors.light.lerp(AppColors.dark, 1).forMeaning(meaning),
        AppColors.dark.forMeaning(meaning),
      );
    }
  });
}
