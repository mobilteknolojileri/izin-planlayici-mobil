# MuMu helpers for Git Bash. Usage: source tools/mumu.sh ; mumu_start ; ui ; tap x y ; shot file.png
# Details and pitfalls: tools/README.md
export MSYS_NO_PATHCONV=1
MUMU_DIR="/c/Program Files/Netease/MuMuPlayer/nx_main"
MUMU_INDEX="${MUMU_INDEX:-1}"
# Use the Android SDK adb; mixing it with MuMu's older adb restarts the adb server.
A="$LOCALAPPDATA/Android/Sdk/platform-tools/adb.exe"
[ -x "$A" ] || A="$MUMU_DIR/adb.exe"

mumu_port() { "$MUMU_DIR/MuMuManager.exe" info -v "$MUMU_INDEX" 2>/dev/null | grep -o '"adb_port": [0-9]*' | grep -o '[0-9]*$'; }

mumu_start() {
  "$MUMU_DIR/MuMuManager.exe" control -v "$MUMU_INDEX" launch >/dev/null
  for i in $(seq 1 40); do
    "$MUMU_DIR/MuMuManager.exe" info -v "$MUMU_INDEX" 2>/dev/null | grep -q '"is_android_started": true' && break
    sleep 5
  done
  S="-s 127.0.0.1:$(mumu_port)"
  "$A" connect "127.0.0.1:$(mumu_port)"
}

S="-s 127.0.0.1:$(mumu_port)"
adbs() { "$A" $S "$@"; }

# Prints visible texts as "x,y[*] text" (center point, * = clickable).
# The old dump is removed first so a failed dump prints nothing instead of a stale screen.
ui() { adbs shell 'rm -f /sdcard/ui.xml; uiautomator dump /sdcard/ui.xml >/dev/null 2>&1; cat /sdcard/ui.xml' | python -I -c "
import sys,re
x=sys.stdin.read()
# uiautomator quotes a value with single quotes when it contains a double quote.
def a(k):
    m=re.search(r' '+k+r'=([\"\x27])(.*?)\1',n)
    return m.group(2) if m else ''
for m in re.finditer(r'<node [^>]*>',x):
    n=m.group(0)
    t=a('text'); d=a('content-desc'); c=a('clickable')
    b=re.search(r'bounds=\"\[(\d+),(\d+)\]\[(\d+),(\d+)\]\"',n)
    if not (t or d): continue
    x1,y1,x2,y2=map(int,b.groups())
    s=(t or '')+(' | '+d if d and d!=t else '')
    print(f'{(x1+x2)//2},{(y1+y2)//2}{\"*\" if c==\"true\" else \"\"} {s[:120]}'.replace('&#10;',' / '))
"; }
shot() { adbs exec-out screencap -p > "$1"; }
tap() { adbs shell input tap "$1" "$2"; sleep "${3:-1.5}"; }
txt() { adbs shell input text "$1"; }          # spaces must be written as %s
back() { adbs shell input keyevent 4; sleep 1; }
swipe_up() { adbs shell input swipe 450 1300 450 500 400; sleep 1; }
open_play() { adbs shell am start -a android.intent.action.VIEW -d "market://details?id=$1" com.android.vending >/dev/null; }
launch() { adbs shell monkey -p "$1" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1; }
tr_locale() { adbs shell cmd locale set-app-locales "$1" --locales tr-TR; }
