# facere

AI-native hardware design CLI for schematic and PCB workflows. Drives
KiCad through MCP tools — corpus-aware placement, vision-driven layout
iteration, automated routing.

## Install

facere is currently a **private distribution**. You need:
1. **Read access to `ZhaoYiping789/facere-distro`** — granted by the maintainer
2. **A GitHub Personal Access Token (PAT)** with `repo` scope — generate at https://github.com/settings/tokens/new

Then in **iTerm2** (the default macOS Terminal.app freezes on input — TUI compatibility issue):

```sh
FACERE_GH_TOKEN=ghp_xxx curl -fsSL \
  https://raw.githubusercontent.com/ZhaoYiping789/facere-installer/main/bootstrap.sh \
  | sh
```

Replace `ghp_xxx` with your PAT. Total install time ~5–10 min.

Then run:

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

After installing KiCad, add this line to `~/.zshrc`:

```sh
export PATH="/Applications/KiCad/KiCad.app/Contents/MacOS:$PATH"
```

Then `exec zsh` to reload.

`uv` (Python toolchain manager) is auto-installed by bootstrap if missing.
You don't need a system Python — `uv` manages its own 3.11+ interpreter.

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
FACERE_GH_TOKEN=ghp_xxx curl -fsSL \
  https://raw.githubusercontent.com/ZhaoYiping789/facere-installer/main/bootstrap.sh \
  | sh
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
