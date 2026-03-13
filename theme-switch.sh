#!/usr/bin/env bash
# Toggle the NeXTSTEP theme on or off in flake.nix, then rebuild.
set -e

FLAKE="$(cd "$(dirname "$0")" && pwd)/flake.nix"
THEME_LINE="./theme-nextstep.nix"

if grep -q "$THEME_LINE" "$FLAKE"; then
  echo "→ Disabling NeXTSTEP theme..."
  sed -i "/$THEME_LINE/d" "$FLAKE"
  echo "  Theme removed from flake.nix"
else
  echo "→ Enabling NeXTSTEP theme..."
  # Insert after home-nvidia.nix import
  sed -i '/home-nvidia\.nix/a\                        ./theme-nextstep.nix' "$FLAKE"
  echo "  Theme added to flake.nix"
fi

echo "→ Rebuilding..."
cd "$(dirname "$0")"
sudo nixos-rebuild switch --flake .#arnav-nix
echo "✓ Done! You may want to reload Hyprland (Super+Shift+M and log back in) or run: hyprctl reload"
