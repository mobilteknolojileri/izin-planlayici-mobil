import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/guide/view_models/guide_source.dart';

/// Name of [source] as the user reads it.
String guideSourceName(AppLocalizations l10n, GuideSource source) =>
    switch (source) {
      GuideSource.labor => l10n.guideSourceLabor,
      GuideSource.regulation => l10n.guideSourceRegulation,
      GuideSource.civil => l10n.guideSourceCivil,
      GuideSource.holidays => l10n.guideSourceHolidays,
      GuideSource.paternity => l10n.guideSourcePaternity,
      GuideSource.diyanet => l10n.guideSourceDiyanet,
      GuideSource.personnel => l10n.guideCountCivilSource,
    };
