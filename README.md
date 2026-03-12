# nix-config

Arnav's multi-system Nix configuration — a single flake managing both a NixOS desktop and a macOS (nix-darwin) laptop.

## Structure

```
flake.nix                    # entry point — darwin + nixos outputs
darwin.nix                   # macOS system config (nix-darwin)
nixos/
  configuration.nix          # NixOS system config
  hardware-configuration.nix # auto-generated hardware config
  nvidia.nix                 # NVIDIA GPU driver module (optional)
home-common.nix              # shared home-manager (fish, git, packages)
home-darwin.nix              # macOS-specific home (Ghostty macOS settings)
home-nixos.nix               # NixOS-specific home (Hyprland, firefox, linux apps)
home-nvidia.nix              # NVIDIA Hyprland env vars (optional)
```

## Hosts

| Host | OS | Arch | Purpose |
|------|----|------|---------|
| `Arnavs-MacBook-Pro` | macOS (nix-darwin) | aarch64-darwin | Laptop |
| `arnav-nix` | NixOS | x86_64-linux | Desktop |

## Home-Manager Split

Configuration shared across both machines lives in `home-common.nix`:
- Shell (fish), git, CLI tools (ripgrep, fd, fzf, btop, etc.)
- Dev tools (Python, Lean/elan, Deno, LaTeX, Emacs, VS Code)
- Media utilities (ffmpeg, yt-dlp, graphviz)

Platform-specific config is split into:
- **`home-darwin.nix`** — Ghostty macOS keybinds, darwin-only packages
- **`home-nixos.nix`** — Hyprland window manager, Firefox, Cursor

## Desktop Environment (NixOS)

The NixOS machine runs **Hyprland** (Wayland compositor) with:
- **Bar**: Waybar
- **Launcher**: Rofi
- **Notifications**: Dunst
- **Wallpaper**: swww
- **Terminal**: Kitty / Ghostty (Catppuccin Mocha theme)
- **Screenshots**: grim + slurp + wl-copy
- **Clipboard history**: cliphist (Super + C to browse)
- **Idle/lock**: hypridle + hyprlock

### Key Bindings

| Binding | Action |
|---------|--------|
| `Super + Return` | Open terminal (Kitty) |
| `Super + D` | App launcher (Rofi) |
| `Super + Q` | Kill active window |
| `Super + Shift + M` | Exit Hyprland |
| `Super + V` | Toggle floating |
| `Super + F` | Fullscreen |
| `Super + C` | Clipboard history |
| `Super + 1-9` | Switch workspace |
| `Super + Shift + 1-9` | Move window to workspace |
| `Super + h/j/k/l` | Vim-style focus |
| `Print` | Screenshot (region select) |
| `Shift + Print` | Screenshot (full screen) |

## Usage

**macOS (nix-darwin):**
```bash
darwin-rebuild switch --flake .#Arnavs-MacBook-Pro
```

**NixOS:**
```bash
sudo nixos-rebuild switch --flake .#arnav-nix
```

**Update flake inputs:**
```bash
nix flake update
```

## NVIDIA GPU Support

NVIDIA drivers are in a separate optional module (`nixos/nvidia.nix` + `home-nvidia.nix`) so the config works on machines with or without NVIDIA GPUs.

**On an NVIDIA machine** (current setup) — no changes needed, both modules are imported in `flake.nix`.

**On a non-NVIDIA machine** — remove the two imports from `flake.nix`:

```diff
  modules = [
    ./nixos/configuration.nix
    ./nixos/hardware-configuration.nix
-   ./nixos/nvidia.nix
    ...
    home-manager.users.arnav = {
-     imports = [ ./home-common.nix ./home-nixos.nix ./home-nvidia.nix ];
+     imports = [ ./home-common.nix ./home-nixos.nix ];
    };
  ];
```

`nvidia.nix` configures the kernel driver (`modesetting`, open kernel modules, stable package). `home-nvidia.nix` sets Hyprland environment variables (`GBM_BACKEND`, `__GLX_VENDOR_LIBRARY_NAME`, etc.) needed for NVIDIA on Wayland.

> **Note**: `nvidia.nix` uses `open = true` (open kernel modules), which requires a Turing+ GPU (RTX 20xx or newer). For older cards, edit `nvidia.nix` and set `open = false`.

## Notes

- `hardware-configuration.nix` is machine-specific and auto-generated — keep it in the repo for full reproducibility, or gitignore it.
- Shared packages/config go in `home-common.nix`. Platform-specific stuff goes in `home-darwin.nix` or `home-nixos.nix`.
- Hyprland binary cache (`hyprland.cachix.org`) is configured on NixOS to speed up builds.
- `programs.nix-ld` is enabled on NixOS to support dynamically linked binaries (e.g., Claude Code VS Code extension).
- GNOME/GDM is enabled alongside Hyprland as a fallback session.
