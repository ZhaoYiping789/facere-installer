# facere

AI-native hardware design CLI for schematic and PCB workflows. Drives
KiCad through MCP tools — corpus-aware placement, vision-driven layout
iteration, automated routing.

## Install — non-technical users (one click)

Download the `facere-install.command` file from the email the
maintainer sent you (it has your access token baked in). Then:

1. Double-click `facere-install.command`
2. macOS may warn "unidentified developer" → **right-click** the file
   → **Open** → confirm
3. A Terminal window opens, the installer runs (5–15 min)
4. You'll be asked for your Mac password once (so Homebrew can install)
5. When it says **All done**, open **iTerm2** and run `facere`

The installer handles everything: Homebrew, iTerm2, KiCad 9, Node, the
facere CLI itself.

## Install — technical users (one command)

If you'd rather skip the wrapper and run a curl one-liner, you'll need:
1. A GitHub PAT with read access to `ZhaoYiping789/facere-distro`
2. KiCad 9 + Node 20+ pre-installed (Linux/WSL: the script auto-installs via apt; macOS: you install via brew or installer first)

Same one-liner works on **macOS, Linux, and WSL** — bootstrap detects platform:

```sh
curl -fsSL \
  https://raw.githubusercontent.com/ZhaoYiping789/facere-installer/main/bootstrap.sh \
  | FACERE_GH_TOKEN=ghp_xxx sh
```

Replace `ghp_xxx` with your PAT. ~5–10 min.

Then:

```sh
facere
```

## Prerequisites

Install these manually first:

| Tool | Install |
|---|---|
| **iTerm2** | `brew install --cask iterm2` |
| **KiCad 9** | https://www.kicad.org/download/macos/ — then add `kicad-cli` to PATH (see below) |
| **Node 20+** | `brew install node` |

The installer automatically:
- adds KiCad's `kicad-cli` to your PATH (writes to `~/.zshrc`)
- installs `uv` (Python toolchain) if missing
- installs / upgrades Node via Homebrew if it's not already 20+

So in practice, the only manual step is **installing the KiCad app** (the
1 GB download from the link above). Everything else gets handled by the
curl one-liner.

## What the bootstrap does

1. Verifies your PAT and macOS
2. Hits the GitHub API to resolve the latest release of `ZhaoYiping789/facere-distro`
3. Downloads the release tarball (`facere-distro.tar.gz`, ~300 MB) authenticated with your PAT
4. Extracts to `~/.facere/distro/`
5. Runs the embedded `install.sh`:
   - Verifies `kicad-cli`, Node 20+
   - Installs `uv` if missing
   - `uv sync` → fetches Python 3.11 + installs hardware-agent + facere-simulation
   - Builds the Node CLI bundle if not pre-built
   - Symlinks `facere` to `~/.local/bin/`
   - Writes `~/.claude.json` (MCP server) and `~/.claude/settings.json` (tool allow list)

## Updating

Re-run the same one-liner. Bootstrap always pulls the latest release, and
`install.sh` is idempotent — it skips steps that already ran.

```sh
curl -fsSL \
  https://raw.githubusercontent.com/ZhaoYiping789/facere-installer/main/bootstrap.sh \
  | FACERE_GH_TOKEN=ghp_xxx sh
```

## Uninstall

```sh
rm -rf ~/.facere ~/.local/bin/facere
# Manually remove the `facere` entry from ~/.claude.json mcpServers
# and the facere/kicad-tools entries from ~/.claude/settings.json permissions.allow
```

## Troubleshooting

| Symptom | Likely cause |
|---|---|
| `FACERE_GH_TOKEN env var not set` | Token missing — paste with `FACERE_GH_TOKEN=ghp_xxx ` prefix |
| `GitHub API request failed` | PAT lacks `repo` scope, or you don't have access to `facere-distro` repo |
| `No release asset found` | Maintainer hasn't uploaded the tarball yet — contact sender |
| `macOS Terminal.app is not supported` on launch | Use iTerm2 |
| `kicad-cli not found` | KiCad not installed or not on PATH (see Prerequisites) |
| REPL appears frozen on input | You're in Terminal.app — switch to iTerm2 |

## Status

Private distribution to early users. macOS only. Windows / Linux support
pending the core flow stabilising.
