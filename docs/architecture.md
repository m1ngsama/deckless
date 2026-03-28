# Architecture

Deckless is intentionally small.

## Core idea

The official Steam package remains the source of truth. Deckless wraps Steam from user-space and temporarily manages only the parts that need desktop-specific policy.

## Components

### `deckless-steam`

This is the main launcher.

- resolves the active Steam runtime path
- sources optional Deckless config
- loads proxy settings
- writes a session-only replacement for `steamwebhelper_sniper_wrap.sh`
- clears proxy environment variables before starting the official Steam client
- restores the original wrapper after Steam exits

### `deckless-bigpicture`

This launcher keeps the normal `steam -tenfoot` flow but adds `gamemode` and `gamescope` when available.

### `deckless-i3-bigpicture-bridge`

This bridge listens to i3 window events and hands fullscreen from Big Picture to a newly created non-Steam window on the same workspace. When that tracked game window closes, the bridge restores fullscreen to Big Picture.

## Why patch the Steam webhelper wrapper at runtime

Steam itself already uses `steamwebhelper_sniper_wrap.sh` as the last hop before `steamwebhelper`. Replacing that wrapper only while Steam is running gives Deckless a narrow control point for:

- webhelper-only proxy flags
- removing forced `--disable-gpu` arguments
- exporting graphics and audio variables that help Big Picture stay on hardware acceleration

That is much safer than permanently replacing Steam files or forcing all Steam traffic through the system proxy.

## Why clear proxy variables before launching Steam

Many Linux desktops inherit proxy variables globally. That is convenient for browsers and other web apps, but it can be wrong for Steam:

- games often need direct paths
- downloads may already work without a proxy
- only store and community web content may actually need the proxy

Deckless keeps the proxy only where it is needed: the top-level webhelper.
