# facere installer

One-command installer for [facere](https://github.com/ZhaoYiping789/facere-distro) — AI-native hardware design CLI.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/ZhaoYiping789/facere-installer/main/bootstrap.sh | sh
```

Then in **iTerm2** (not the default Terminal):

```sh
facere
```

## What it does

1. Downloads the latest `facere-distro.tar.gz` from GitHub Releases (~300 MB compressed)
2. Extracts to `~/.facere/distro/`
3. Runs the embedded `install.sh` which:
   - Installs `uv` if missing (Python toolchain manager)
   - Sets up a Python venv with `hardware-agent` + `facere-simulation`
   - Builds the Node CLI bundle if missing
   - Symlinks `facere` to `~/.local/bin/`
   - Configures the MCP server in `~/.claude.json`

Total install time: ~5–10 min on a fast connection (most of it `uv sync` pulling Python deps).

## Prerequisites

| Required | Install |
|---|---|
| macOS (Apple Silicon or Intel) | — |
| KiCad 9 | https://www.kicad.org/download/macos/ + add `/Applications/KiCad/KiCad.app/Contents/MacOS` to PATH |
| Node 20+ | `brew install node` |
| iTerm2 | `brew install --cask iterm2` (the default Terminal.app freezes on input — TUI compatibility issue) |

## Uninstall

```sh
rm -rf ~/.facere ~/.local/bin/facere
# remove the `facere` entry under mcpServers in ~/.claude.json
```
