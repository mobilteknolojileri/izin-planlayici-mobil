import 'package:izin_planla/domain/models/models.dart';
import 'package:izin_planla/ui/guide/view_models/guide_source.dart';
import 'package:izin_planla/ui/guide/view_models/guide_topic.dart';
import 'package:material_ui/material_ui.dart';

/// What the guide shows.
@immutable
class GuideState {
  /// Creates the state.
  const new({required this.law, this.loading = false});

  /// The law the guide explains, the active person's by default.
  final EmploymentType law;

  /// Whether the active person is still loading.
  final bool loading;

  /// Sections in reading order.
  List<GuideTopic> get topics => GuideTopic.values;

  /// Sources listed at the end, for [law].
  List<GuideSource> get sources => law == EmploymentType.laborLaw
      ? const [
          GuideSource.labor,
          GuideSource.regulation,
          GuideSource.holidays,
          GuideSource.paternity,
          GuideSource.diyanet,
        ]
      : const [
          GuideSource.civil,
          GuideSource.personnel,
          GuideSource.holidays,
          GuideSource.diyanet,
        ];
}
