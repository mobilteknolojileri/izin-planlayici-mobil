import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/l10n/gen/app_localizations.dart';
import 'package:izin_planla/ui/core/theme/app_spacing.dart';
import 'package:izin_planla/ui/core/theme/color_groups.dart';
import 'package:izin_planla/ui/core/theme/meaning.dart';
import 'package:izin_planla/ui/core/widgets/inset_card.dart';
import 'package:izin_planla/ui/core/widgets/legend_row.dart';
import 'package:izin_planla/ui/core/widgets/meaning_tile.dart';
import 'package:izin_planla/ui/core/widgets/week_strip.dart';
import 'package:izin_planla/ui/core/widgets/week_strip_day.dart';
import 'package:izin_planla/ui/guide/view_models/guide_topic.dart';
import 'package:izin_planla/ui/guide/widgets/guide_source_name.dart';
import 'package:izin_planla/ui/guide/widgets/guide_source_row.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// One section of the guide: a question as the title, the rule in plain
/// words, a picture or a small table where it helps, and the source.
class GuideTopicCard extends StatelessWidget {
  /// Creates the section.
  const new({required this.topic, required this.law, super.key});

  /// Which section.
  final GuideTopic topic;

  /// The law the section explains.
  final EmploymentType law;

  /// The example week of the day count section: leave from 26 to 30
  /// October 2026, with the eve and the national holiday inside.
  static final exampleWeek = [
    WeekStripDay(date: DateTime.utc(2026, 10, 26), meaning: Meaning.used),
    WeekStripDay(date: DateTime.utc(2026, 10, 27), meaning: Meaning.used),
    WeekStripDay(date: DateTime.utc(2026, 10, 28), meaning: Meaning.eve),
    WeekStripDay(date: DateTime.utc(2026, 10, 29), meaning: Meaning.holiday),
    WeekStripDay(date: DateTime.utc(2026, 10, 30), meaning: Meaning.used),
    WeekStripDay(date: DateTime.utc(2026, 10, 31), meaning: Meaning.weekend),
    WeekStripDay(date: DateTime.utc(2026, 11), meaning: Meaning.weekend),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labor = law == EmploymentType.laborLaw;
    final source = topic.source(law);
    final (title, icon) = switch (topic) {
      GuideTopic.rightStart => (
        l10n.guideRightTitle,
        LucideIcons.calendarClock,
      ),
      GuideTopic.duration => (
        l10n.guideDurationTitle,
        LucideIcons.calendarDays,
      ),
      GuideTopic.dayCount => (l10n.guideCountTitle, LucideIcons.calendarCheck),
      GuideTopic.halfDay => (l10n.guideHalfDayTitle, LucideIcons.contrast),
      GuideTopic.split => (l10n.guideSplitTitle, LucideIcons.scissors),
      GuideTopic.unused => (l10n.guideUnusedTitle, LucideIcons.hourglass),
      GuideTopic.travel => (l10n.guideTravelTitle, LucideIcons.bus),
      GuideTopic.excuse => (l10n.guideExcuseTitle, LucideIcons.heartHandshake),
      GuideTopic.holidays => (l10n.guideHolidaysTitle, LucideIcons.flag),
    };
    final (body, sourceLine) = switch ((topic, labor)) {
      (GuideTopic.rightStart, true) => (
        [
          _Paragraph(l10n.guideRightLabor),
          _Paragraph(l10n.guideRightLaborMerge),
        ],
        l10n.guideRightLaborSource,
      ),
      (GuideTopic.rightStart, false) => (
        [
          _Paragraph(l10n.guideRightCivil),
          _Paragraph(l10n.guideRightCivilService),
        ],
        l10n.guideRightCivilSource,
      ),
      (GuideTopic.duration, true) => (
        [
          _Fact(l10n.guideDurationLaborShort, l10n.coreDays(14)),
          _Fact(l10n.guideDurationLaborMiddle, l10n.coreDays(20)),
          _Fact(l10n.guideDurationLaborLong, l10n.coreDays(26)),
          _Paragraph(l10n.guideDurationLaborAge),
          _Paragraph(l10n.guideDurationLaborUnderground),
          _Paragraph(l10n.guideDurationLaborContract),
        ],
        l10n.guideDurationLaborSource,
      ),
      (GuideTopic.duration, false) => (
        [
          _Fact(l10n.guideDurationCivilShort, l10n.coreDays(20)),
          _Fact(l10n.guideDurationCivilLong, l10n.coreDays(30)),
          _Paragraph(l10n.guideDurationCivilTeacher),
        ],
        l10n.guideDurationCivilSource,
      ),
      (GuideTopic.dayCount, true) => (
        [
          _Paragraph(l10n.guideCountLabor),
          _Paragraph(l10n.guideCountLaborSaturday),
          const _Example(),
        ],
        l10n.guideCountLaborSource,
      ),
      (GuideTopic.dayCount, false) => (
        [_Paragraph(l10n.guideCountCivil), const _Example()],
        l10n.guideCountCivilSource,
      ),
      (GuideTopic.halfDay, _) => (
        [_Paragraph(l10n.guideHalfDay)],
        l10n.guideHalfDaySource,
      ),
      (GuideTopic.split, true) => (
        [_Paragraph(l10n.guideSplitLabor)],
        l10n.guideSplitLaborSource,
      ),
      (GuideTopic.split, false) => (
        [_Paragraph(l10n.guideSplitCivil)],
        l10n.guideSplitCivilSource,
      ),
      (GuideTopic.unused, true) => (
        [_Paragraph(l10n.guideUnusedLabor)],
        l10n.guideUnusedLaborSource,
      ),
      (GuideTopic.unused, false) => (
        [_Paragraph(l10n.guideUnusedCivil)],
        l10n.guideUnusedCivilSource,
      ),
      (GuideTopic.travel, true) => (
        [_Paragraph(l10n.guideTravelLabor)],
        l10n.guideTravelLaborSource,
      ),
      (GuideTopic.travel, false) => (
        [_Paragraph(l10n.guideTravelCivil)],
        l10n.guideTravelCivilSource,
      ),
      (GuideTopic.excuse, true) => (
        [
          _Paragraph(l10n.guideExcuseLabor),
          _Fact(l10n.guideExcuseMarriage, l10n.coreDays(3)),
          _Fact(l10n.guideExcuseAdoption, l10n.coreDays(3)),
          _Fact(l10n.guideExcuseLaborBereavement, l10n.coreDays(3)),
          _Fact(l10n.guideExcusePaternity, l10n.coreDays(10)),
          _Fact(l10n.guideExcuseLaborChild, l10n.guideExcuseYearly),
          _Paragraph(l10n.guideExcuseLaborPaternityNote),
        ],
        l10n.guideExcuseLaborSource,
      ),
      (GuideTopic.excuse, false) => (
        [
          _Fact(l10n.guideExcusePaternity, l10n.coreDays(10)),
          _Fact(l10n.guideExcuseCivilMarriage, l10n.coreDays(7)),
          _Fact(l10n.guideExcuseCivilBereavement, l10n.coreDays(7)),
          _Fact(l10n.guideExcuseCivilOther, l10n.guideExcuseCivilOtherValue),
          _Fact(l10n.guideExcuseCivilChild, l10n.guideExcuseYearly),
          _Fact(
            l10n.guideExcuseCivilMaternity,
            l10n.guideExcuseCivilMaternityValue,
          ),
          _Paragraph(l10n.guideExcuseCivil),
        ],
        l10n.guideExcuseCivilSource,
      ),
      (GuideTopic.holidays, _) => (
        [
          for (final (meaning, name) in [
            (Meaning.holiday, l10n.guideHolidayNewYear),
            (Meaning.holiday, l10n.guideHolidayApril),
            (Meaning.holiday, l10n.guideHolidayLabour),
            (Meaning.holiday, l10n.guideHolidayYouth),
            (Meaning.holiday, l10n.guideHolidayDemocracy),
            (Meaning.holiday, l10n.guideHolidayVictory),
            (Meaning.eve, l10n.guideHolidayRepublicEve),
            (Meaning.holiday, l10n.guideHolidayRepublic),
            (Meaning.eve, l10n.guideHolidayRamadan),
            (Meaning.eve, l10n.guideHolidaySacrifice),
          ])
            _Holiday(meaning: meaning, name: name),
          _Paragraph(l10n.guideHolidaysNote),
        ],
        l10n.guideHolidaysSource,
      ),
    };
    return InsetCard(
      header: Semantics(
        header: true,
        child: CardHeader(tint: AppTint.purple, icon: icon, title: title),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final widget in body) ...[
            widget,
            const SizedBox(height: AppSpacing.smd),
          ],
          GuideSourceRow(
            text: l10n.guideSource(sourceLine),
            sourceName: guideSourceName(l10n, source),
            source: source,
          ),
        ],
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  const new(this.text);

  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: Theme.of(context).textTheme.bodyLarge);
}

/// A row of a small table, such as "1 yıldan 5 yıla kadar: 14 gün". The
/// value moves under the label when they do not fit side by side.
class _Fact extends StatelessWidget {
  const new(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MergeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: theme.colorScheme.primary, width: 3),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.smd),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: AppSpacing.sm,
            children: [
              Text(label, style: theme.textTheme.bodyLarge),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Holiday extends StatelessWidget {
  const new({required this.meaning, required this.name});

  final Meaning meaning;
  final String name;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      MeaningTile(meaning: meaning, width: 28, height: 28),
      const SizedBox(width: AppSpacing.smd),
      Expanded(child: Text(name, style: Theme.of(context).textTheme.bodyLarge)),
    ],
  );
}

/// The example week with its legend and the sentence that explains it.
class _Example extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WeekStrip(days: GuideTopicCard.exampleWeek),
        const SizedBox(height: AppSpacing.smd),
        const LegendRow(
          meanings: [
            Meaning.used,
            Meaning.eve,
            Meaning.holiday,
            Meaning.weekend,
          ],
        ),
        const SizedBox(height: AppSpacing.smd),
        Text(
          l10n.guideCountExample,
          style: Theme.of(context).textTheme.bodyLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
