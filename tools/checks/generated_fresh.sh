#!/usr/bin/env bash
# Regenerates code and localizations and fails if anything changed, so the
# committed generated files always match their sources. Used by the
# pre-commit hook and CI.
set -euo pipefail

dart run build_runner build
dart run tools/merge_arb.dart

# Only unstaged and untracked files count: in the pre-commit hook the staged
# changes are the commit itself. In CI nothing is staged, so this covers all.
changed="$(
  git diff --name-only -- lib
  git ls-files --others --exclude-standard -- lib
)"
if [[ -n "$changed" ]]; then
  echo "Files under lib differ after regenerating. Generated files are out" >&2
  echo "of date or not staged. Stage and commit these files:" >&2
  echo "$changed" >&2
  exit 1
fi
