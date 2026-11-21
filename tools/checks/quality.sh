#!/usr/bin/env bash
# Format, static analysis and tests. Used by the pre-commit hook and CI.
set -euo pipefail

# Generated files are formatted by their generators and skipped here.
mapfile -t dart_files < <(
  git ls-files --cached --others --exclude-standard '*.dart' |
    grep -vE '\.(g|freezed)\.dart$|^lib/l10n/gen/'
)

# In batches: on Windows `dart` is a batch file and cmd.exe rejects command
# lines over 8191 characters. xargs fails when any batch fails.
printf '%s\0' "${dart_files[@]}" |
  xargs -0 -n 50 dart format --output=none --summary=none --set-exit-if-changed
flutter analyze --fatal-infos
flutter test
