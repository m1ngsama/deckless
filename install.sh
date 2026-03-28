#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
install_root="${data_home}/deckless"
backup_root="${install_root}/backups/original"
bin_dir="${HOME}/.local/bin"
app_dir="${data_home}/applications"
config_dir="${config_home}/deckless"
autostart_dir="${config_home}/autostart"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    printf 'Missing required command: %s\n' "$1" >&2
    exit 1
  fi
}

backup_once() {
  local target="$1"
  local relative="$2"

  [[ -e "$target" || -L "$target" ]] || return 0
  [[ -e "${backup_root}/${relative}" || -L "${backup_root}/${relative}" ]] && return 0

  mkdir -p "$(dirname "${backup_root}/${relative}")"
  cp -a "$target" "${backup_root}/${relative}"
}

write_launcher() {
  local target="$1"
  local exec_target="$2"

  cat >"$target" <<EOF
#!/usr/bin/env bash
set -euo pipefail

exec "${exec_target}" "\$@"
EOF
  chmod 0755 "$target"
}

write_steam_desktop() {
  cat >"${app_dir}/steam.desktop" <<EOF
[Desktop Entry]
Name=Steam
Comment=Official Steam with direct game traffic and proxied community web content
Exec=${bin_dir}/steam %U
Icon=steam
Terminal=false
Type=Application
Categories=Network;FileTransfer;Game;
MimeType=x-scheme-handler/steam;x-scheme-handler/steamlink;
PrefersNonDefaultGPU=true
EOF
}

write_bigpicture_desktop() {
  cat >"${app_dir}/steam-bigpicture.desktop" <<EOF
[Desktop Entry]
Name=Steam Big Picture
Comment=Launch Steam Big Picture with Deckless session tweaks
Exec=${bin_dir}/steam-bigpicture
Icon=steam
Terminal=false
Type=Application
Categories=Game;
PrefersNonDefaultGPU=true
EOF
}

write_i3_autostart() {
  cat >"${autostart_dir}/deckless-i3-bigpicture-bridge.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Deckless i3 Big Picture Bridge
Comment=Bridge fullscreen between Steam Big Picture and games on i3
Exec=/usr/bin/bash ${install_root}/bin/deckless-i3-bigpicture-bridge
OnlyShowIn=i3;
NoDisplay=true
Terminal=false
EOF
}

maybe_start_i3_bridge() {
  local bridge_cmd="/usr/bin/bash ${install_root}/bin/deckless-i3-bigpicture-bridge"

  command -v i3-msg >/dev/null 2>&1 || return 0
  [[ -n "${DISPLAY:-}" ]] || return 0

  if i3-msg -t get_version >/dev/null 2>&1; then
    if ! pgrep -u "$USER" -fx "$bridge_cmd" >/dev/null 2>&1; then
      i3-msg "exec --no-startup-id ${bridge_cmd}" >/dev/null 2>&1 || true
    fi
  fi
}

require_command bash
require_command jq

if [[ ! -x /usr/bin/steam ]]; then
  printf 'Expected the official Steam client at /usr/bin/steam\n' >&2
  exit 1
fi

mkdir -p \
  "${install_root}/bin" \
  "${backup_root}/bin" \
  "${backup_root}/applications" \
  "${backup_root}/autostart" \
  "$bin_dir" \
  "$app_dir" \
  "$config_dir" \
  "$autostart_dir"

backup_once "${bin_dir}/steam" "bin/steam"
backup_once "${bin_dir}/steam-bigpicture" "bin/steam-bigpicture"
backup_once "${app_dir}/steam.desktop" "applications/steam.desktop"
backup_once "${app_dir}/steam-bigpicture.desktop" "applications/steam-bigpicture.desktop"
backup_once "${autostart_dir}/deckless-i3-bigpicture-bridge.desktop" "autostart/deckless-i3-bigpicture-bridge.desktop"

install -Dm755 "${repo_root}/bin/deckless-steam" "${install_root}/bin/deckless-steam"
install -Dm755 "${repo_root}/bin/deckless-bigpicture" "${install_root}/bin/deckless-bigpicture"
install -Dm755 "${repo_root}/bin/deckless-i3-bigpicture-bridge" "${install_root}/bin/deckless-i3-bigpicture-bridge"
install -Dm755 "${repo_root}/bin/deckless-sync-webhelper-wrapper" "${install_root}/bin/deckless-sync-webhelper-wrapper"
install -Dm755 "${repo_root}/bin/deckless-webhelper-heal" "${install_root}/bin/deckless-webhelper-heal"
install -Dm755 "${repo_root}/bin/deckless-webhelper-cleanup" "${install_root}/bin/deckless-webhelper-cleanup"
install -Dm644 "${repo_root}/config/proxy-env.example.sh" "${config_dir}/proxy-env.example.sh"
install -Dm644 "${repo_root}/config/deckless.env.example" "${config_dir}/deckless.env.example"

write_launcher "${bin_dir}/steam" "${install_root}/bin/deckless-steam"
write_launcher "${bin_dir}/steam-bigpicture" "${install_root}/bin/deckless-bigpicture"
write_steam_desktop
write_bigpicture_desktop
write_i3_autostart

maybe_start_i3_bridge

cat <<EOF
Deckless installed.

Installed launchers:
  ${bin_dir}/steam
  ${bin_dir}/steam-bigpicture

Config examples:
  ${config_dir}/proxy-env.example.sh
  ${config_dir}/deckless.env.example

If you want a dedicated Deckless proxy file, create:
  ${config_dir}/proxy-env.sh

If you want optional runtime overrides, create:
  ${config_dir}/deckless.env
EOF
