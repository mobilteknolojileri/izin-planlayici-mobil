#!/usr/bin/env bash
# Rebuilds the branding images, the Android launcher icons and the splash
# screens from the SVG sources in assets/branding/src.
#
# Usage, from any folder:
#   bash assets/branding/tool/build_android.sh
set -euo pipefail

cd "$(dirname "$0")/../../.."

# 1. SVG to PNG: assets/branding/png (tool inputs) and store/images (Play).
flutter test assets/branding/tool/render_branding_test.dart

# 2. Launcher icons. flutter_launcher_icons always rewrites the android:icon
# line of AndroidManifest.xml, so it runs in a scratch copy and only the res
# files come back. A manifest diff means the manifest needs a manual change.
scratch="$(mktemp -d)"
trap 'rm -rf "$scratch"' EXIT
manifest=android/app/src/main/AndroidManifest.xml
mkdir -p "$scratch/android/app/src/main/res" "$scratch/assets/branding"
cp "$manifest" "$scratch/$manifest"
cp -r assets/branding/png assets/branding/launcher_icons.yaml \
  "$scratch/assets/branding/"
scratch_root="$(cygpath -m "$scratch" 2>/dev/null || echo "$scratch")"
dart run assets/branding/tool/launcher_icons.dart "$scratch_root"
if ! cmp -s "$manifest" "$scratch/$manifest"; then
  echo "flutter_launcher_icons wants this AndroidManifest.xml change:" >&2
  diff "$manifest" "$scratch/$manifest" >&2 || true
fi
cp -r "$scratch/android/app/src/main/res/." android/app/src/main/res/

# 3. Splash screens. flutter_native_splash writes res files only. It reads
# AndroidManifest.xml and writes it only for android_screen_orientation,
# which the config does not set.
dart run flutter_native_splash:create --path=assets/branding/native_splash.yaml
