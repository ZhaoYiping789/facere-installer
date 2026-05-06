#!/usr/bin/env sh
# facere bootstrap — fetched via:
#
#   FACERE_GH_TOKEN=ghp_xxx curl -fsSL \
#     https://raw.githubusercontent.com/ZhaoYiping789/facere-installer/main/bootstrap.sh \
#     | sh
#
# Downloads the latest facere distro tarball from the private
# `facere-distro` GitHub repo's Releases, extracts it, and runs the
# embedded install.sh.
#
# Requires FACERE_GH_TOKEN env var with `repo` scope (PAT).

set -e

# Source repo containing the private Release assets. Investors must have
# read access to this repo (you invite them on GitHub).
SOURCE_REPO="ZhaoYiping789/facere-distro"
INSTALL_DIR="${FACERE_HOME:-$HOME/.facere}"
DISTRO_DIR="$INSTALL_DIR/distro"

bold()  { printf "\033[1m%s\033[0m\n" "$*"; }
ok()    { printf "  \033[32m✓\033[0m %s\n" "$*"; }
die()   { printf "  \033[31m✗\033[0m %s\n" "$*" >&2; exit 1; }

bold "facere installer"

# ── Auth check ────────────────────────────────────────────────────────
if [ -z "${FACERE_GH_TOKEN:-}" ]; then
  die "FACERE_GH_TOKEN env var not set.

  facere is a private distribution. You should have received a GitHub
  Personal Access Token (PAT) along with this install command.

  Re-run with your token, e.g.:

    FACERE_GH_TOKEN=ghp_xxx curl -fsSL \\
      https://raw.githubusercontent.com/ZhaoYiping789/facere-installer/main/bootstrap.sh \\
      | sh

  If you don't have a token, contact the sender."
fi
ok "PAT supplied"

# ── Platform check ────────────────────────────────────────────────────
[ "$(uname)" = "Darwin" ] || die "macOS required (got $(uname)). Linux/Windows support is on the roadmap."
ok "macOS $(sw_vers -productVersion)"

# ── Resolve latest release asset URL via GitHub API ───────────────────
bold "Resolving latest release"
RELEASE_JSON=$(curl -fsSL \
  -H "Authorization: token $FACERE_GH_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/repos/$SOURCE_REPO/releases/latest" 2>&1) || \
  die "GitHub API request failed. Check your PAT has 'repo' scope and you have access to $SOURCE_REPO."

# Pull the asset's API URL (not browser_download_url — that requires a
# different auth path for private repos).
ASSET_API_URL=$(printf '%s' "$RELEASE_JSON" \
  | grep -E '"url":\s*"[^"]+/assets/[0-9]+"' \
  | head -1 \
  | sed 's/.*"\(https[^"]*\)".*/\1/')

[ -n "$ASSET_API_URL" ] || die "No release asset found. Did you upload facere-distro.tar.gz to the latest release of $SOURCE_REPO?"
ok "found release asset"

# ── Fetch + extract tarball ───────────────────────────────────────────
mkdir -p "$INSTALL_DIR"
rm -rf "$DISTRO_DIR"
cd "$INSTALL_DIR"

bold "Downloading facere distro"
echo "  to: $DISTRO_DIR"
curl -fL --progress-bar \
  -H "Authorization: token $FACERE_GH_TOKEN" \
  -H "Accept: application/octet-stream" \
  "$ASSET_API_URL" \
  | tar -xz -C "$INSTALL_DIR"

[ -f "$DISTRO_DIR/install.sh" ] || die "Tarball did not contain install.sh — try rerunning, or check the release on GitHub."
ok "extracted"

# ── Hand off to install.sh ────────────────────────────────────────────
exec "$DISTRO_DIR/install.sh"
