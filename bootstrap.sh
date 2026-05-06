#!/usr/bin/env sh
# facere bootstrap — fetched via:
#   curl -fsSL https://raw.githubusercontent.com/ZhaoYiping789/facere-installer/main/bootstrap.sh | sh
#
# Downloads the latest facere distro tarball from GitHub Releases,
# extracts it, and runs the embedded install.sh. Idempotent — re-running
# overwrites the install dir and re-runs setup.

set -e

REPO="ZhaoYiping789/facere-installer"
INSTALL_DIR="${FACERE_HOME:-$HOME/.facere}"
DISTRO_DIR="$INSTALL_DIR/distro"
TARBALL_URL="https://github.com/$REPO/releases/latest/download/facere-distro.tar.gz"

bold()  { printf "\033[1m%s\033[0m\n" "$*"; }
ok()    { printf "  \033[32m✓\033[0m %s\n" "$*"; }
die()   { printf "  \033[31m✗\033[0m %s\n" "$*" >&2; exit 1; }

bold "facere installer"

# ── Platform check (early, friendly) ──────────────────────────────────
[ "$(uname)" = "Darwin" ] || die "macOS required (got $(uname)). Linux/Windows support is on the roadmap."
ok "macOS $(sw_vers -productVersion)"

# ── Fetch + extract tarball ───────────────────────────────────────────
mkdir -p "$INSTALL_DIR"
rm -rf "$DISTRO_DIR"
mkdir -p "$DISTRO_DIR"
cd "$INSTALL_DIR"

bold "Downloading facere distro"
echo "  from: $TARBALL_URL"
echo "  to:   $DISTRO_DIR"
curl -fL --progress-bar "$TARBALL_URL" | tar -xz -C "$INSTALL_DIR"
[ -f "$DISTRO_DIR/install.sh" ] || die "tarball did not contain install.sh — try rerunning, or check $TARBALL_URL"
ok "extracted"

# ── Hand off to install.sh ────────────────────────────────────────────
exec "$DISTRO_DIR/install.sh"
