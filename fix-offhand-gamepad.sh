#!/bin/sh
# Applies the Gamepad UI fix to your own installed copy of Offhand
# (https://github.com/N4UX-GIT/Offhand-DualMonitor/issues/84): skip
# PlayerMovementFrameFader while the Gamepad UI is on. Re-run after updating Offhand.
set -e
DIR="${1:-/Applications/World of Warcraft/_forever_/Interface/AddOns/Offhand}"
cd "$DIR/Core" 2>/dev/null || { echo "Offhand not found at: $DIR"; echo "Usage: $0 /path/to/AddOns/Offhand"; exit 1; }
FILES="CanvasPanelLifecycle.lua CanvasMapPresentation.lua"
if grep -q 'IsGamepadUIEnabled()) and PlayerMovementFrameFader' $FILES; then
    echo "Already applied."; exit 0
fi
n=$(cat $FILES | perl -ne '$c += () = /PlayerMovementFrameFader(?![.\w])/g; END { print $c + 0 }')
if [ "$n" != 6 ]; then
    echo "This Offhand version differs from the one the fix was written for ($n matches, expected 6). Nothing changed."
    exit 1
fi
for f in $FILES; do
    cp -n "$f" "$f.orig"
    perl -pi -e 's/PlayerMovementFrameFader(?![.\w])/(not (Offhand.isForever and Offhand:IsGamepadUIEnabled()) and PlayerMovementFrameFader)/g' "$f"
done
echo "Fixed. Originals saved as .orig next to each file. /reload in game."
