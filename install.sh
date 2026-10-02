#!/usr/bin/env bash
# Copies the configs into ~/.config, backing up anything already there.
set -euo pipefail
SRC="$(cd "$(dirname "$0")" && pwd)"
CFG="${XDG_CONFIG_HOME:-$HOME/.config}"
STAMP="$(date +%Y%m%d-%H%M%S)"

backup() { [ -e "$1" ] && mv "$1" "$1.bak-$STAMP" && echo "backed up $1"; return 0; }

# sway / waybar / wofi / foot
for app in sway waybar wofi foot; do
  backup "$CFG/$app"
  cp -r "$SRC/$app" "$CFG/$app"
  echo "installed $app"
done

# starship
backup "$CFG/starship.toml"
cp "$SRC/starship/starship.toml" "$CFG/starship.toml"
echo "installed starship.toml"
for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
  shell="$(basename "$rc" | sed 's/^\.//; s/rc$//')"
  if [ -f "$rc" ] && ! grep -q 'starship init' "$rc"; then
    printf '\n# starship prompt\neval "$(starship init %s)"\n' "$shell" >> "$rc"
    echo "enabled starship in $rc"
  fi
done

# emacs: theme always; init.el only if you don't already have one
EMACS_DIR="$CFG/emacs"
if [ -e "$HOME/.emacs" ] || [ -e "$HOME/.emacs.d/init.el" ]; then
  EMACS_DIR="$HOME/.emacs.d"
fi
mkdir -p "$EMACS_DIR"
cp "$SRC/emacs/opensuse-theme.el" "$EMACS_DIR/"
echo "installed opensuse-theme.el to $EMACS_DIR"
if [ -e "$EMACS_DIR/init.el" ] || [ -e "$HOME/.emacs" ]; then
  echo "kept your existing Emacs init. To use the theme, add:"
  echo "  (add-to-list 'custom-theme-load-path \"$EMACS_DIR\")"
  echo "  (load-theme 'opensuse t)"
else
  cp "$SRC/emacs/init.el" "$EMACS_DIR/init.el"
  echo "installed emacs init.el"
fi

echo "Done. Reload sway with \$mod+Shift+c and open a new terminal for starship."
