# TheClosedTest daily swap helpers for MuMu. Builds on tools/mumu.sh.
# Usage (Git Bash, repo root): source tools/tct.sh
# Details and pitfalls: tools/README.md
source "$(dirname "${BASH_SOURCE[0]}")/mumu.sh"

TCT_PKG=com.theneerajsec.theclosedtest
TCT_PROOF_DIR=/sdcard/DCIM/TCT   # /sdcard/Pictures is a MuMu shared folder and rejects writes

# Prints the local time. Plain `date` is used because Git Bash has no tz
# database and `TZ=Europe/Istanbul date` silently prints UTC.
tct_time() { date '+%H:%M'; echo "The swap day closes at 21:30 Turkey time."; }

# Prints the "x,y" of the first ui() line that contains $2. $1 is ui() output.
coord() { echo "$1" | grep -F -- "$2" | head -1 | cut -d' ' -f1 | tr -d '*'; }

# Saves the current screen as a proof image the photo picker can see.
proof() {
  adbs shell "mkdir -p $TCT_PROOF_DIR; screencap -p $TCT_PROOF_DIR/$1.png; am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE -d file://$TCT_PROOF_DIR/$1.png >/dev/null"
}

# Restarts TheClosedTest on the Tests tab and prints the day summary.
tct_tests() {
  adbs shell am force-stop "$TCT_PKG"; launch "$TCT_PKG"; sleep 4; tap 535 1508 2
  ui 2>/dev/null | grep -E 'Pending Today|Completed Today|^[0-9]+,424 [0-9]+$|\*  \|.*Day [0-9]+ of 14'
}

# Opens a swap by its full app name as shown on the Tests tab, e.g.
# "Fae &amp; Flame: Romantasy Color" (ui() keeps HTML entities).
open_tct_task() {
  adbs shell am force-stop "$TCT_PKG"; launch "$TCT_PKG"; sleep 4; tap 535 1508 2
  local i out c y
  for i in 1 2 3 4; do
    out=$(ui 2>/dev/null)
    c=$(echo "$out" | grep -F "*  | $1," | head -1 | cut -d' ' -f1 | tr -d '*')
    y=${c#*,}
    # Cards below y=1420 sit under the floating tab bar.
    if [ -n "$c" ] && [ "$y" -lt 1420 ]; then tap "${c%,*}" "$y" 3; return 0; fi
    swipe_up
  done
  echo "task not found: $1"; return 1
}

# Scrolls to the partner's pending proof and saves it to $1 for review.
# A swap with old unreviewed proofs opens on the oldest pending day.
show_partner_proof() {
  swipe_up
  ui 2>/dev/null | grep -E "Proof$|Pending your review"
  shot "$1"
}

# Accepts the partner proof on screen. Look at show_partner_proof first.
accept_proof() {
  swipe_up
  local c; c=$(coord "$(ui 2>/dev/null)" "*  | Accept")
  [ -z "$c" ] && { echo "no accept button"; return 1; }
  tap "${c%,*}" "${c#*,}" 4
  ui 2>/dev/null | grep -E "approved|Pending your review|Upload Screenshots"
}

# Uploads the newest picture as today's proof with note $1 (spaces as %s).
# Run on an open swap after proof().
upload_here() {
  local out c y
  out=$(ui 2>/dev/null); c=$(coord "$out" "Upload Screenshots")
  [ -z "$c" ] && { echo "no upload button"; return 1; }
  tap "${c%,*}" "${c#*,}" 4
  tap 110 548 2    # newest picture in the photo picker
  tap 739 1512 4   # "Add (1)"
  out=$(ui 2>/dev/null); c=$(coord "$out" "Add a note")
  tap "${c%,*}" "${c#*,}" 2; txt "$1"; sleep 1; back
  out=$(ui 2>/dev/null); c=$(coord "$out" "Submit Day"); y=${c#*,}
  if [ "$y" -gt 1420 ]; then swipe_up; out=$(ui 2>/dev/null); c=$(coord "$out" "Submit Day"); fi
  tap "${c%,*}" "${c#*,}" 5
  ui 2>/dev/null | grep -o -E "Proof submitted successfully|Day [0-9]+ Uploaded" | head -2
}

# Joins a partner's closed test in Chrome. Without this Google does not count
# us as their tester.
join_test() {
  adbs shell am start -a android.intent.action.VIEW -d "https://play.google.com/apps/testing/$1" com.android.chrome >/dev/null
  local i out c
  for i in 1 2 3 4 5 6; do
    sleep 4; out=$(ui 2>/dev/null)
    echo "$out" | grep -q -E "Become a tester|You are a tester" && break
  done
  c=$(coord "$out" "Become a tester")
  if [ -n "$c" ]; then
    tap "${c%,*}" "${c#*,}" 1
    for i in 1 2 3 4 5; do sleep 3; out=$(ui 2>/dev/null); echo "$out" | grep -q "You are a tester" && break; done
  fi
  echo "$1 -> $(echo "$out" | grep -o -m1 -E "You are a tester|Become a tester")"
}

# Starts a Play install. Play is restarted first because right after joining
# a test its Install button can silently do nothing.
install_app() {
  adbs shell am force-stop com.android.vending
  open_play "$1"
  local i out c
  for i in 1 2 3 4 5; do
    sleep 3; out=$(ui 2>/dev/null)
    echo "$out" | grep -q -E "\| (Install|Open|Uninstall|Cancel)$" && break
  done
  c=$(echo "$out" | grep -E "^[0-9]+,[0-9]+\*?  \| Install$" | head -1 | cut -d' ' -f1 | tr -d '*')
  [ -n "$c" ] && tap "${c%,*}" "${c#*,}" 4
  echo "$1 -> $(ui 2>/dev/null | grep -o -m1 -E "Pending|Downloading|Installing|\| (Install|Open|Cancel)$")"
}
