#!/usr/bin/env bash
# install-deps.sh — install everything the openSUSE sway theme needs.
#
# Usage: ./install-deps.sh [-y] [--configs]
#   -y         don't ask zypper for confirmation
#   --configs  also run ./install.sh to copy the configs into ~/.config
set -euo pipefail

ASSUME_YES=0
RUN_CONFIGS=0
for arg in "$@"; do
  case "$arg" in
    -y|--yes)  ASSUME_YES=1 ;;
    --configs) RUN_CONFIGS=1 ;;
    -h|--help) sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done

green=$'\e[38;2;115;186;37m'; cyan=$'\e[38;2;53;185;171m'
yellow=$'\e[33m'; red=$'\e[31m'; reset=$'\e[0m'
info() { printf '%s==>%s %s\n' "$green" "$reset" "$*"; }
note() { printf '%s  ->%s %s\n' "$cyan" "$reset" "$*"; }
warn() { printf '%s  !!%s %s\n' "$yellow" "$reset" "$*"; }
die()  { printf '%sERROR:%s %s\n' "$red" "$reset" "$*" >&2; exit 1; }

# ── Sanity checks ──────────────────────────────────────────────
[ "$(id -u)" -eq 0 ] && die "Run this as your normal user; it uses sudo where needed."
command -v zypper >/dev/null || die "zypper not found — this script is for openSUSE."
command -v sudo   >/dev/null || die "sudo is required."

if [ -r /etc/os-release ]; then
  . /etc/os-release
  case "${ID:-}${ID_LIKE:-}" in
    *opensuse*|*suse*) info "Detected ${PRETTY_NAME:-openSUSE}" ;;
    *) warn "This doesn't look like openSUSE (${PRETTY_NAME:-unknown}); continuing anyway." ;;
  esac
fi

# ── Package lists ──────────────────────────────────────────────
CORE=(
  sway swayidle swaylock     # compositor, idle, lock
  waybar wofi foot           # bar, launcher, terminal
)
EXTRAS=(
  grim slurp wl-clipboard    # screenshots -> clipboard
  brightnessctl playerctl    # brightness + media keys
  wireplumber                # provides wpctl for volume keys
  pavucontrol                # waybar volume click
  NetworkManager-tui         # waybar network click (nmtui)
  xdg-desktop-portal-wlr     # screen sharing / portals
)
FONTS=(
  adobe-sourcesanspro-fonts  # UI font
  adobe-sourcecodepro-fonts  # terminal font
  symbols-only-nerd-fonts    # waybar icons (falls back to GitHub download)
)

# ── Find which packages exist in the enabled repos ─────────────
info "Refreshing repositories"
sudo zypper --quiet refresh

available=() missing=()
for pkg in "${CORE[@]}" "${EXTRAS[@]}" "${FONTS[@]}"; do
  if zypper --quiet --non-interactive info "$pkg" 2>/dev/null | grep -q "^Name *: *$pkg$"; then
    available+=("$pkg")
  else
    missing+=("$pkg")
  fi
done

for pkg in "${CORE[@]}"; do
  if printf '%s\n' "${missing[@]}" | grep -qx "$pkg"; then
    die "Required package '$pkg' isn't in your repos. On Leap you may need the backports/Wayland repo."
  fi
done

# ── Install ────────────────────────────────────────────────────
info "Installing ${#available[@]} packages"
printf '     %s\n' "${available[@]}"
zyp=(sudo zypper install --no-recommends)
[ "$ASSUME_YES" -eq 1 ] && zyp=(sudo zypper --non-interactive install --no-recommends)
"${zyp[@]}" "${available[@]}"

for pkg in "${missing[@]}"; do
  [ "$pkg" = symbols-only-nerd-fonts ] && continue
  warn "Skipped '$pkg' (not found in your repos)"
done

# ── Nerd Font fallback ─────────────────────────────────────────
if ! fc-list 2>/dev/null | grep -qi "Symbols Nerd Font"; then
  info "Symbols Nerd Font not found — downloading from GitHub"
  command -v curl  >/dev/null || "${zyp[@]}" curl
  command -v unzip >/dev/null || "${zyp[@]}" unzip
  fontdir="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/NerdFontsSymbolsOnly"
  tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
  url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip"
  if curl -fsSL "$url" -o "$tmp/nf.zip"; then
    mkdir -p "$fontdir"
    unzip -oq "$tmp/nf.zip" -d "$fontdir"
    fc-cache -f "$fontdir" >/dev/null
    note "Installed to $fontdir"
  else
    warn "Download failed — waybar icons will show as boxes until a Nerd Font is installed."
  fi
else
  note "Symbols Nerd Font already installed"
fi

# ── Optional: copy configs ─────────────────────────────────────
if [ "$RUN_CONFIGS" -eq 1 ]; then
  here="$(cd "$(dirname "$0")" && pwd)"
  [ -x "$here/install.sh" ] || die "install.sh not found next to this script."
  info "Installing configs"
  "$here/install.sh"
fi

info "All done."
note "Start sway from a TTY with:  sway"
[ "$RUN_CONFIGS" -eq 1 ] || note "Copy the configs with:      ./install.sh"
