# Troubleshooting

## Steam web pages still do not load

Check the proxy file Deckless is reading:

1. `DECKLESS_PROXY_ENV`
2. `~/.config/deckless/proxy-env.sh`
3. `~/.config/network/proxy-env.sh`
4. inherited shell proxy variables

Things to verify:

- the proxy URL includes a scheme such as `http://` or `socks5h://`
- local addresses are included in `no_proxy`
- the proxy itself is reachable outside Steam

## Games are using the proxy when they should be direct

Deckless clears standard proxy environment variables before starting Steam. If a game still uses a proxy, the most likely causes are:

- the game has its own proxy setting
- a system-wide transparent proxy is in place
- another launcher is injecting environment variables after Deckless starts Steam

## Big Picture still falls back to software rendering

Confirm that your system has working graphics userspace outside Steam first. Deckless only removes some Steam-side blockers; it cannot fix a broken driver stack.

Useful checks:

- `command -v gamescope`
- `glxinfo -B`
- `vulkaninfo --summary`

Also check whether your system exposes one of these paths:

- `/run/host/usr/lib/gbm`
- `/usr/lib/gbm`
- `/run/host/usr/share/glvnd/egl_vendor.d`
- `/usr/share/glvnd/egl_vendor.d`

## Big Picture launches but the game does not take fullscreen on i3

The i3 bridge depends on:

- `i3-msg`
- `jq`
- an i3 session that processes XDG autostart entries, or a manual bridge start

You can start it manually with:

```bash
/usr/bin/bash ~/.local/share/deckless/bin/deckless-i3-bigpicture-bridge
```

If the game first opens a launcher window, that launcher may briefly take the fullscreen seat before the actual game window appears.

## I want to go back to plain Steam

Run:

```bash
./uninstall.sh
```

Deckless restores previously backed up local launchers and desktop entries when they existed at first install.
