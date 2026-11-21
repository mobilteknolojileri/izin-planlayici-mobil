import 'package:flutter/foundation.dart';

/// What the Android widget shows on one day, as finished texts.
///
/// The Kotlin provider only places these texts, so every word comes from
/// `lib/l10n/parts/home_widget.arb` and every number is already formatted.
@immutable
class HomeWidgetEntry {
  /// Creates an entry. [value] is empty when no number is shown.
  const new({
    required this.value,
    required this.caption,
    required this.holiday,
    required this.description,
  });

  /// The large number, for example `18` or `4,5`. Empty for messages such
  /// as the setup prompt.
  final String value;

  /// The line under [value], or the whole message when [value] is empty.
  final String caption;

  /// The next holiday line. Empty when the entry is only a message.
  final String holiday;

  /// What the screen reader says for the whole widget.
  final String description;

  /// The JSON object the Kotlin provider reads.
  Map<String, String> toJson() => {
    'value': value,
    'caption': caption,
    'holiday': holiday,
    'description': description,
  };

  @override
  bool operator ==(Object other) =>
      other is HomeWidgetEntry &&
      other.value == value &&
      other.caption == caption &&
      other.holiday == holiday &&
      other.description == description;

  @override
  int get hashCode => Object.hash(value, caption, holiday, description);

  @override
  String toString() =>
      'HomeWidgetEntry($value | $caption | $holiday | $description)';
}
