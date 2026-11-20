#!/usr/bin/env bash
# Rejects files that must never enter the public repository: signing keys,
# local settings, build outputs, competitor material, files over 5 MB and
# personal Windows user paths.
#
# Usage:
#   forbidden_files.sh         # pre-commit hook, checks staged files
#   forbidden_files.sh --all   # CI, checks every tracked file
set -euo pipefail

readonly MAX_BYTES=$((5 * 1024 * 1024))
readonly NAME_RE='(^|/)(key\.properties|local\.properties|\.env(\..*)?)$|\.(jks|keystore|apk|aab)$|(^|/)(rakipler|\.tooling)/'
# A Windows profile path with a real user name, e.g. C:\Users\name.
readonly USER_PATH_RE='[A-Za-z]:[\\/]+Users[\\/]+[A-Za-z0-9._-]+|/c/Users/[A-Za-z0-9._-]+'

if [[ "${1:-}" == "--all" ]]; then
  mapfile -t files < <(git ls-files)
  size_of() { wc -c < "$1"; }
  content_of() { cat "$1"; }
else
  mapfile -t files < <(git diff --cached --name-only --diff-filter=ACMR)
  size_of() { git cat-file -s ":$1"; }
  content_of() { git show ":$1"; }
fi

status=0
for file in "${files[@]}"; do
  [[ -z "$file" ]] && continue
  if [[ "$file" =~ $NAME_RE ]]; then
    echo "forbidden file: $file" >&2
    status=1
    continue
  fi
  if (( $(size_of "$file") > MAX_BYTES )); then
    echo "file over 5 MB: $file" >&2
    status=1
    continue
  fi
  # This script contains the pattern itself.
  [[ "$file" == "tools/checks/forbidden_files.sh" ]] && continue
  if content_of "$file" | grep -qaE "$USER_PATH_RE"; then
    echo "personal user path in: $file (use %USERPROFILE% or ~)" >&2
    status=1
  fi
done
exit "$status"
