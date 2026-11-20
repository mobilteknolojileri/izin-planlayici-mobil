#!/usr/bin/env bash
# Format, static analysis and tests. Used by the pre-commit hook and CI.
set -euo pipefail

# Generated files are formatted by their generators and skipped here.
mapfile -t dart_files < <(
  git ls-files --cached --others --exclude-standard '*.dart' |
    grep -vE '\.(g|freezed)\.dart$|^lib/l10n/gen/'
)

dart format --output=none --set-exit-if-changed "${dart_files[@]}"
flutter analyze --fatal-infos
flutter test
