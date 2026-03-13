#!/usr/bin/env bash
set -euo pipefail

target_root="${1:-/mnt}"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target_config="$target_root/etc/nixos-config"

if ! mountpoint -q "$target_root"; then
  echo "Expected the target root filesystem to be mounted at $target_root." >&2
  echo "Mount your existing NixOS root there first, then mount the EFI partition at $target_root/boot." >&2
  exit 1
fi

if [ ! -d "$target_root/boot" ] || ! mountpoint -q "$target_root/boot"; then
  echo "Expected the boot/EFI partition to be mounted at $target_root/boot." >&2
  exit 1
fi

sudo mkdir -p "$target_config"
sudo rsync -a --delete "$repo_root/" "$target_config/"

sudo nixos-generate-config --root "$target_root"
sudo install -Dm644 \
  "$target_root/etc/nixos/hardware-configuration.nix" \
  "$target_config/nixos/hardware-configuration.nix"

echo "Installing arnav-nix from $target_config ..."
sudo nixos-install --root "$target_root" --flake "$target_config#arnav-nix"
