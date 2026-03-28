#!/usr/bin/env bash
set -euo pipefail

data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
install_root="${data_home}/deckless"
backup_root="${install_root}/backups/original"
bin_dir="${HOME}/.local/bin"
app_dir="${data_home}/applications"
autostart_dir="${config_home}/autostart"
config_dir="${config_home}/deckless"

restore_or_remove() {
  local target="$1"
  local relative="$2"

  if [[ -e "${backup_root}/${relative}" || -L "${backup_root}/${relative}" ]]; then
    mkdir -p "$(dirname "$target")"
    rm -f "$target"
    cp -a "${backup_root}/${relative}" "$target"
  else
    rm -f "$target"
  fi
}

if [[ -d "$install_root" ]]; then
  pkill -u "$USER" -fx "/usr/bin/bash ${install_root}/bin/deckless-i3-bigpicture-bridge" >/dev/null 2>&1 || true
fi

restore_or_remove "${bin_dir}/steam" "bin/steam"
restore_or_remove "${bin_dir}/steam-bigpicture" "bin/steam-bigpicture"
restore_or_remove "${app_dir}/steam.desktop" "applications/steam.desktop"
restore_or_remove "${app_dir}/steam-bigpicture.desktop" "applications/steam-bigpicture.desktop"
restore_or_remove "${autostart_dir}/deckless-i3-bigpicture-bridge.desktop" "autostart/deckless-i3-bigpicture-bridge.desktop"

rm -rf "$install_root"

if [[ -d "$config_dir" ]] && [[ -z "$(ls -A "$config_dir" 2>/dev/null)" ]]; then
  rmdir "$config_dir"
fi

printf 'Deckless uninstalled.\n'
