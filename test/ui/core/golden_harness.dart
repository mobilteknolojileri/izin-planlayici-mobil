import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/theme/app_theme.dart';
import 'package:material_ui/material_ui.dart';

/// Phone width used by the component goldens.
const goldenPhoneWidth = 360.0;

/// Horizontal padding alchemist adds around each scenario.
final double _scenarioPadding = GoldenTestTheme.standard().padding.horizontal;

/// Golden test of one component in the light and dark theme, each at normal
/// text size, at 200% linear and at Android's 200% nonlinear text size.
/// Writes `<fileName>_light.png` and `<fileName>_dark.png`. An overflow in
/// any scenario fails the test.
void coreGoldenTest(
  String description, {
  required String fileName,
  required WidgetBuilder builder,
  double width = goldenPhoneWidth,
  double? height,
  Interaction? whilePerforming,
}) {
  for (final (variant, theme) in [
    ('light', AppTheme.light),
    ('dark', AppTheme.dark),
  ]) {
    AlchemistConfig.runWithConfig(
      config: AlchemistConfig.current().merge(AlchemistConfig(theme: theme)),
      run: () {
        final constraints = height == null
            ? BoxConstraints.tightFor(width: width)
            : BoxConstraints.tightFor(width: width, height: height);
        unawaited(
          goldenTest(
            '$description, $variant',
            fileName: '${fileName}_$variant',
            pumpWidget: _pumpLocalized,
            whilePerforming: whilePerforming,
            builder: () => GoldenTestGroup(
              columns: 3,
              // Fixed widths: the default intrinsic sizing does not work with
              // components that use LayoutBuilder.
              columnWidthBuilder: (_) =>
                  FixedColumnWidth(width + _scenarioPadding),
              children: [
                GoldenTestScenario(
                  name: 'text x1',
                  constraints: constraints,
                  child: _Surface(builder: builder),
                ),
                GoldenTestScenario.withTextScaleFactor(
                  name: 'text x2',
                  textScaler: const TextScaler.linear(2),
                  constraints: constraints,
                  child: _Surface(builder: builder),
                ),
                GoldenTestScenario.withTextScaleFactor(
                  name: 'text x2 android',
                  textScaler: const AndroidNonlinear200(),
                  constraints: constraints,
                  child: _Surface(builder: builder),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<void> _pumpLocalized(WidgetTester tester, Widget widget) =>
    tester.pumpWidget(
      Localizations(
        locale: const Locale('tr'),
        delegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        child: widget,
      ),
    );

/// The theme surface behind a component, as on a real screen.
class _Surface extends StatelessWidget {
  const new({required this.builder});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surface,
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Builder(builder: builder),
    ),
  );
}

/// Wraps [child] in a themed, Turkish app for behaviour tests.
Widget testApp(Widget child, {ThemeData? theme}) => MaterialApp(
  theme: theme ?? AppTheme.light,
  locale: const Locale('tr'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: const [
    AppLocalizations.delegate,
    ...GlobalMaterialLocalizations.delegates,
  ],
  home: Scaffold(body: child),
);

/// Android 14 nonlinear font scaling at the 200% setting: small text
/// doubles, large text grows less. Linear scaling alone missed overflows
/// that this scaling causes on devices. Values from AOSP
/// `FontScaleConverterFactory`.
class AndroidNonlinear200 extends TextScaler {
  /// Creates the scaler.
  const new();

  static const List<double> _fromSp = [0, 8, 10, 12, 14, 18, 20, 24, 30, 100];
  static const List<double> _toDp = [0, 16, 20, 24, 26, 30, 34, 36, 38, 100];

  @override
  double scale(double fontSize) {
    if (fontSize >= _fromSp.last) return fontSize;
    var i = 1;
    while (_fromSp[i] < fontSize) {
      i++;
    }
    final t = (fontSize - _fromSp[i - 1]) / (_fromSp[i] - _fromSp[i - 1]);
    return _toDp[i - 1] + t * (_toDp[i] - _toDp[i - 1]);
  }

  @override
  double get textScaleFactor => 2;

  @override
  bool operator ==(Object other) => other is AndroidNonlinear200;

  @override
  int get hashCode => (AndroidNonlinear200).hashCode;
}
