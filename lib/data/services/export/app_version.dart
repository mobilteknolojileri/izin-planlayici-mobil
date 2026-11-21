import 'package:flutter/foundation.dart' show immutable;

/// A pubspec style app version, `major.minor.patch+build`.
///
/// Checks the `appVersion` field of a backup, which is kept for support and
/// never decides compatibility. The build number is optional and counts as 0
/// when missing.
@immutable
final class AppVersion implements Comparable<AppVersion> {
  /// Creates a version from its parts.
  const new(this.major, this.minor, this.patch, [this.build = 0]);

  /// Parses `1.2.3` or `1.2.3+4`, or returns null when [text] has another
  /// shape.
  static AppVersion? tryParse(String text) {
    final match = _pattern.firstMatch(text);
    if (match == null) return null;
    final parts = [for (var i = 1; i <= 4; i++) int.tryParse(match[i] ?? '0')];
    if (parts.contains(null)) return null;
    return AppVersion(parts[0]!, parts[1]!, parts[2]!, parts[3]!);
  }

  static final _pattern = RegExp(
    r'^(\d{1,9})\.(\d{1,9})\.(\d{1,9})(?:\+(\d{1,9}))?$',
  );

  /// Major version.
  final int major;

  /// Minor version.
  final int minor;

  /// Patch version.
  final int patch;

  /// Build number, the Android version code.
  final int build;

  @override
  int compareTo(AppVersion other) {
    for (final (a, b) in [
      (major, other.major),
      (minor, other.minor),
      (patch, other.patch),
      (build, other.build),
    ]) {
      if (a != b) return a.compareTo(b);
    }
    return 0;
  }

  /// Whether this version is newer than [other].
  bool isNewerThan(AppVersion other) => compareTo(other) > 0;

  @override
  bool operator ==(Object other) =>
      other is AppVersion && compareTo(other) == 0;

  @override
  int get hashCode => Object.hash(major, minor, patch, build);

  @override
  String toString() => '$major.$minor.$patch+$build';
}
