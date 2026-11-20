#!/usr/bin/env bash
# Regenerates code and localizations and fails if anything changed, so the
# committed generated files always match their sources. Used by CI.
set -euo pipefail

dart run build_runner build
dart run tools/merge_arb.dart

if [[ -n "$(git status --porcelain -- lib)" ]]; then
  echo "Generated files are out of date. Run build_runner and" >&2
  echo "tools/merge_arb.dart, then commit the result:" >&2
  git status --porcelain -- lib >&2
  exit 1
fi
