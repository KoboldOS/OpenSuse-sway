#!/usr/bin/env bash
# install-dm.sh — install greetd + gtkgreet with the openSUSE theme and make it
# the system display manager.
#
# Usage: ./install-dm.sh [-y]
#   -y   don't ask for confirmation (zypper or switching display manager)
set -euo pipefail

ASSUME_YES=0
case "${1:-}" in
  -y|--yes) ASSUME_YES=1 ;;
  -h|--help) sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
  "") ;;
  *) echo "Unknown option: $1" >&2; exit 1 ;;
esac

green=$'\e[38;2;115;186;37m'; cyan=$'\e[38;2;53;185;171m'
yellow=$'\e[33m'; red=$'\e[31m'; reset=$'\e[0m'
info() { printf '%s==>%s %s\n' "$green" "$reset" "$*"; }
note() { printf '%s  ->%s %s\n' "$cyan" "$reset" "$*"; }
warn() { printf '%s  !!%s %s\n' "$yellow" "$reset" "$*"; }
die()  { printf '%sERROR:%s %s\n' "$red" "$reset" "$*" >&2; exit 1; }
confirm() {
  [ "$ASSUME_YES" -eq 1 ] && return 0
  read -r -p "$1 [y/N] " ans; [[ "$ans" =~ ^[Yy]$ ]]
}

[ "$(id -u)" -eq 0 ] && die "Run this as your normal user; it uses sudo where needed."
command -v zypper >/dev/null || die "zypper not found — this script is for openSUSE."
SRC="$(cd "$(dirname "$0")" && pwd)/greetd"
[ -d "$SRC" ] || die "greetd/ directory not found next to this script."

# ── Packages ───────────────────────────────────────────────────
info "Installing greetd and gtkgreet"
zyp=(sudo zypper install --no-recommends)
[ "$ASSUME_YES" -eq 1 ] && zyp=(sudo zypper --non-interactive install --no-recommends)
"${zyp[@]}" greetd gtkgreet sway

# ── Greeter user ───────────────────────────────────────────────
if ! id greeter >/dev/null 2>&1; then
  info "Creating 'greeter' system user"
  sudo useradd --system --no-create-home --shell /usr/sbin/nologin \
       --groups video greeter
else
  note "User 'greeter' already exists"
  id -nG greeter | grep -qw video || sudo usermod -aG video greeter
fi

# ── Config files ───────────────────────────────────────────────
STAMP="$(date +%Y%m%d-%H%M%S)"
info "Installing configs to /etc/greetd"
sudo mkdir -p /etc/greetd
for f in config.toml sway-config environments gtkgreet.css; do
  if [ -e "/etc/greetd/$f" ]; then
    sudo cp -a "/etc/greetd/$f" "/etc/greetd/$f.bak-$STAMP"
    note "backed up /etc/greetd/$f"
  fi
  sudo install -m 0644 "$SRC/$f" "/etc/greetd/$f"
done
sudo install -m 0755 "$SRC/sway-session" /usr/local/bin/sway-session
note "Session wrapper: /usr/local/bin/sway-session"

# ── Switch display manager ─────────────────────────────────────
current="$(systemctl show -p Id --value display-manager.service 2>/dev/null || true)"
note "Current display manager: ${current:-none}"

if confirm "Make greetd the display manager (takes effect after reboot)?"; then
  # openSUSE selects its DM via update-alternatives when available
  if update-alternatives --list default-displaymanager 2>/dev/null | grep -q greetd; then
    sudo update-alternatives --set default-displaymanager \
      "$(update-alternatives --list default-displaymanager | grep greetd | head -n1)"
    note "Set default-displaymanager alternative to greetd"
  fi
  if [ -n "$current" ] && [ "$current" != "greetd.service" ] && [ "$current" != "display-manager.service" ]; then
    sudo systemctl disable "$current" || warn "Couldn't disable $current"
  fi
  sudo systemctl enable --force greetd.service
  sudo systemctl set-default graphical.target
  info "greetd enabled. Reboot to see the new login screen."
else
  warn "Display manager left unchanged. Enable later with:"
  note "sudo systemctl enable --force greetd.service"
fi

cat <<MSG

${green}If the login screen ever fails to appear:${reset}
  1. Press Ctrl+Alt+F2 and log in on the text console
  2. Check logs:  journalctl -b -u greetd
  3. Roll back:   sudo systemctl disable greetd && sudo systemctl enable ${current:-<your-old-dm>}
MSG
