#!/usr/bin/env bash
# Rejects commit messages that break the rules in docs/mimari.md:
# one English Conventional Commits line, at most 72 characters, no body,
# no Co-authored-by trailer and no AI signature.
#
# Usage:
#   commit_message.sh <message-file>     # commit-msg hook
#   commit_message.sh --range <git-range> # CI, checks every non-merge commit
set -euo pipefail

readonly TYPES='feat|fix|docs|test|refactor|perf|build|ci|chore|revert'
readonly HEADER_RE="^(${TYPES})(\([a-z0-9_-]+\))?!?: [^ ].*$"
readonly SIGNATURE_RE='co-authored-by:|generated (with|by)|noreply@anthropic\.com|claude code|🤖'

# Prints a reason and returns 1 when the message is not allowed.
check_message() {
  local label="$1" message="$2"
  # Drop git's comment lines and trailing blank lines.
  message="$(printf '%s\n' "$message" | grep -v '^#' | sed -e ':a' -e '/^\n*$/{$d;N;ba' -e '}')"

  local header lines
  header="$(printf '%s\n' "$message" | head -n 1)"
  lines="$(printf '%s\n' "$message" | grep -c . || true)"

  if [[ "$header" =~ ^Merge\  ]]; then
    return 0
  fi
  if printf '%s\n' "$message" | grep -qiE "$SIGNATURE_RE"; then
    echo "$label: Co-authored-by and AI signatures are not allowed." >&2
    return 1
  fi
  if (( lines != 1 )); then
    echo "$label: the message must be a single line (no body or footer)." >&2
    return 1
  fi
  if (( ${#header} > 72 )); then
    echo "$label: the header is ${#header} characters, the limit is 72." >&2
    return 1
  fi
  if ! [[ "$header" =~ $HEADER_RE ]]; then
    echo "$label: \"$header\" is not 'type(scope): description'." >&2
    echo "  Allowed types: ${TYPES//|/, }" >&2
    return 1
  fi
}

if [[ "${1:-}" == "--range" ]]; then
  range="${2:?missing git range}"
  # A new branch push has an all-zero "before" commit. Check its history.
  if [[ "$range" =~ ^0+\.\. ]]; then
    range="${range##*..}"
  fi
  status=0
  while read -r sha; do
    check_message "commit ${sha:0:8}" "$(git log -1 --format=%B "$sha")" || status=1
  done < <(git rev-list --no-merges "$range")
  exit "$status"
fi

check_message "commit message" "$(cat "${1:?missing message file}")"
