#!/usr/bin/env bash
# Copies the configs into ~/.config, backing up anything already there.
set -euo pipefail
SRC="$(cd "$(dirname "$0")" && pwd)"
CFG="${XDG_CONFIG_HOME:-$HOME/.config}"
STAMP="$(date +%Y%m%d-%H%M%S)"
for app in sway waybar wofi foot; do
  if [ -e "$CFG/$app" ]; then
    mv "$CFG/$app" "$CFG/$app.bak-$STAMP"
    echo "backed up $CFG/$app -> $app.bak-$STAMP"
  fi
  cp -r "$SRC/$app" "$CFG/$app"
  echo "installed $app"
done
echo "Done. Reload sway with \$mod+Shift+c."
