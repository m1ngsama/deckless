# Deckless

[![ShellCheck](https://github.com/m1ngsama/deckless/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/m1ngsama/deckless/actions/workflows/shellcheck.yml)

Deckless is a Linux toolkit that keeps the official Steam package intact while fixing three pain points that desktop Linux users regularly hit outside SteamOS:

- split proxy policy for Steam web content vs. game traffic
- Big Picture GPU fallback and related audio/runtime quirks
- couch-mode handoff between Big Picture and launched games on i3

It started from a real Arch Linux desktop that needed direct game traffic, proxied Steam community/store access, and a better controller-first Big Picture workflow.

## Features

- Keeps `/usr/bin/steam` as the official upstream client.
- Proxies only `steamwebhelper` traffic, so store, community pages, avatars, and embedded web content can use a proxy while games and downloads stay direct.
- Restores the original `steamwebhelper_sniper_wrap.sh` when Steam exits.
- Removes Steam's `--disable-gpu` and `--disable-gpu-compositing` flags for Big Picture webhelper sessions.
- Exports sane `GBM`, `EGL`, and PulseAudio defaults to help Steam stay on hardware acceleration instead of dropping to software rendering.
- Launches Big Picture through `gamescope` and `gamemode` when they are available.
- Ships an optional i3 bridge that lets a newly launched game take fullscreen from Big Picture and hands fullscreen back when the game exits.
- Installs cleanly into XDG paths and can be rolled back with `./uninstall.sh`.

## Design goals

- Official Steam first, customization second.
- No permanent mutation of Steam runtime files at rest.
- Small, auditable shell scripts instead of a daemon-heavy stack.
- Easy to adopt on one machine and easy to explain to another Linux player.

## Quick start

1. Install the official Steam package for your distribution.
2. Install the runtime helpers you want:
   - required: `bash`, `jq`
   - optional: `gamescope`, `gamemode`
   - optional for i3 autostart: `dex` or another XDG autostart runner
3. Copy the proxy template and edit it for your local proxy:

```bash
mkdir -p ~/.config/deckless
cp config/proxy-env.example.sh ~/.config/deckless/proxy-env.sh
```

4. Review the optional runtime settings:

```bash
cp config/deckless.env.example ~/.config/deckless/deckless.env
```

5. Install Deckless:

```bash
./install.sh
```

6. Start Steam as usual:

```bash
steam
```

For a controller-first session, launch:

```bash
steam-bigpicture
```

## What gets installed

- `~/.local/share/deckless/bin/deckless-steam`
- `~/.local/share/deckless/bin/deckless-bigpicture`
- `~/.local/share/deckless/bin/deckless-i3-bigpicture-bridge`
- `~/.local/bin/steam`
- `~/.local/bin/steam-bigpicture`
- `~/.local/share/applications/steam.desktop`
- `~/.local/share/applications/steam-bigpicture.desktop`
- `~/.config/autostart/deckless-i3-bigpicture-bridge.desktop`

Deckless also stores first-install backups under `~/.local/share/deckless/backups/original`.

## Configuration

### Proxy split

Deckless looks for proxy settings in this order:

1. `DECKLESS_PROXY_ENV`
2. `~/.config/deckless/proxy-env.sh`
3. `~/.config/network/proxy-env.sh`
4. inherited shell proxy variables

Only the top-level Steam webhelper gets the resulting Chromium proxy flags. The main Steam client and launched games have proxy environment variables cleared before Steam starts.

### Optional runtime settings

`~/.config/deckless/deckless.env` can override:

- `DECKLESS_STEAM_BIN`
- `DECKLESS_LANG`
- `DECKLESS_FC_LANG`
- `DECKLESS_INPUT_METHOD`
- `DECKLESS_USE_GAMEMODE`
- `DECKLESS_USE_GAMESCOPE`
- `DECKLESS_GAMESCOPE_REFRESH`
- `DECKLESS_USE_MANGOAPP`

### i3 bridge

The i3 bridge is installed as an XDG autostart entry with `OnlyShowIn=i3;`.

If your i3 session is started by `dex`, `lxsession`, or another autostart runner, the bridge will come up automatically in future sessions. `install.sh` also attempts to start it immediately when it detects a live i3 session.

See [docs/i3.md](docs/i3.md) for the handoff behavior.

## Tested setup

- Arch Linux
- official `steam` package
- X11
- i3
- `gamescope`
- `gamemode`
- `jq`

Other X11 desktop environments may still benefit from the proxy split and Big Picture GPU fixes, but the fullscreen handoff bridge is currently i3-specific.

## Safety and rollback

- Deckless never replaces `/usr/bin/steam`.
- The Steam runtime wrapper is only rewritten while Steam is active.
- The original wrapper is restored after Steam exits.
- `./uninstall.sh` restores the local launchers and desktop entries that existed before the first install.

## Documentation

- [Architecture notes](docs/architecture.md)
- [i3 integration](docs/i3.md)

## License

Deckless is licensed under GPL-3.0-or-later. See [LICENSE](LICENSE).
