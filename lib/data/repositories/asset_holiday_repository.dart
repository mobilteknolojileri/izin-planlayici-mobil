import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:izin_planla/data/repositories/holiday_repository.dart';
import 'package:izin_planla/domain/models/models.dart';

/// [HolidayRepository] reading the bundled holiday file once and keeping it
/// in memory.
///
/// The file is part of the app, so a missing or malformed file is a
/// programming error and throws.
final class AssetHolidayRepository implements HolidayRepository {
  /// Creates a repository reading [assetPath] from [bundle], which defaults
  /// to the app's [rootBundle].
  new({AssetBundle? bundle, this.assetPath = defaultAssetPath})
    : _bundle = bundle ?? rootBundle;

  /// The holiday file shipped with the app.
  static const defaultAssetPath = 'assets/holidays/tr_2026_2028.json';

  /// Asset key of the holiday file.
  final String assetPath;

  final AssetBundle _bundle;
  late final Future<List<Holiday>> _holidays = _load();

  @override
  Future<List<Holiday>> all() => _holidays;

  @override
  Future<List<Holiday>> inRange(DateRange range) async => [
    for (final holiday in await _holidays)
      if (range.contains(holiday.date)) holiday,
  ];

  Future<List<Holiday>> _load() async {
    final source = await _bundle.loadString(assetPath);
    final document = jsonDecode(source) as Map<String, dynamic>;
    final entries = document['holidays'] as List<dynamic>;
    final holidays = [
      for (final entry in entries)
        Holiday.fromJson(entry as Map<String, dynamic>),
    ]..sort((a, b) => a.date.compareTo(b.date));
    return List.unmodifiable(holidays);
  }
}
