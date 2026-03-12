# nix-config

Arnav's multi-system Nix configuration — a single flake managing both a NixOS desktop and a macOS (nix-darwin) laptop.

## Quick Start

### Fresh NixOS install

```bash
# 1. Clone the repo
git clone https://github.com/arnavdandu/nix-config.git
cd nix-config/nixos

# 2. Copy your hardware config (generated during NixOS install)
sudo cp /etc/nixos/hardware-configuration.nix nixos/hardware-configuration.nix

# 3. Build and switch
sudo nixos-rebuild switch --flake .#arnav-nix
```

### Fresh macOS install

```bash
# 1. Install Nix (if not already installed)
sh <(curl -L https://nixos.org/nix/install)

# 2. Clone the repo
git clone https://github.com/arnavdandu/nix-config.git
cd nix-config/nixos

# 3. Build and switch
darwin-rebuild switch --flake .#Arnavs-MacBook-Pro
```

### Day-to-day usage

```bash
# Rebuild after editing config
sudo nixos-rebuild switch --flake .#arnav-nix      # NixOS
darwin-rebuild switch --flake .#Arnavs-MacBook-Pro  # macOS

# Update all flake inputs (nixpkgs, home-manager, hyprland, etc.)
nix flake update

# Garbage collect old generations
sudo nix-collect-garbage -d
```

## Hosts

| Host | OS | Arch | Purpose |
|------|----|------|---------|
| `arnav-nix` | NixOS | x86_64-linux | Desktop (NVIDIA GPU) |
| `Arnavs-MacBook-Pro` | macOS (nix-darwin) | aarch64-darwin | Laptop |

## Repository Structure

```
flake.nix                    # entry point — darwin + nixos outputs
darwin.nix                   # macOS system config (nix-darwin)
nixos/
  configuration.nix          # NixOS system config
  hardware-configuration.nix # auto-generated hardware config
  nvidia.nix                 # NVIDIA GPU driver module (optional)
home-common.nix              # shared home-manager (fish, git, packages)
home-darwin.nix              # macOS-specific home (Ghostty, darwin-only pkgs)
home-nixos.nix               # NixOS-specific home (Hyprland, Kitty, GTK, linux apps)
home-nvidia.nix              # NVIDIA Hyprland env vars (optional)
```

## Home-Manager Split

Configuration shared across both machines lives in `home-common.nix`:
- **Shell**: fish (with custom `lxf` function to fuzzy-find LaTeX projects)
- **Git**: global user config
- **CLI tools**: ripgrep, fd, fzf, btop, htop, gh, rsync, cmake
- **Dev tools**: Python 3 (+ numpy/matplotlib), Lean/elan, opam, Deno, VS Code, Emacs
- **LaTeX**: texliveFull, TeXstudio
- **Media**: ffmpeg, yt-dlp, graphviz, tesseract, fortune

Platform-specific config is split into:
- **`home-darwin.nix`** — Ghostty terminal config, Tailscale, macOS-only packages
- **`home-nixos.nix`** — Hyprland, Kitty, GTK/icon theme, Firefox, Cursor, Wayland tools

## Desktop Environment (NixOS)

The NixOS machine runs **Hyprland** (Wayland compositor) with **GNOME/GDM** available as a fallback session.

| Component | Tool |
|-----------|------|
| Compositor | Hyprland (dwindle layout) |
| Display Manager | GDM |
| Terminal | Kitty (JetBrains Mono, Catppuccin Mocha) |
| Bar | Waybar |
| Launcher | Rofi |
| Notifications | Dunst |
| Wallpaper | swww |
| Screenshots | grim + slurp → wl-copy |
| Clipboard history | cliphist |
| Idle / Lock | hypridle + hyprlock |
| Icons | Papirus-Dark |

### Hyprland Key Bindings

| Binding | Action |
|---------|--------|
| `Super + Return` | Open terminal (Kitty) |
| `Super + D` | App launcher (Rofi) |
| `Super + Q` | Kill active window |
| `Super + Shift + M` | Exit Hyprland |
| `Super + V` | Toggle floating |
| `Super + F` | Fullscreen |
| `Super + S` | Toggle split |
| `Super + P` | Pseudo-tile |
| `Super + C` | Clipboard history |
| `Super + h/j/k/l` | Vim-style focus |
| `Super + Arrow keys` | Move focus |
| `Super + 1-9` | Switch workspace |
| `Super + Shift + 1-9` | Move window to workspace |
| `Super + scroll` | Cycle workspaces |
| `Super + LMB drag` | Move window |
| `Super + RMB drag` | Resize window |
| `Print` | Screenshot (region select → clipboard) |
| `Shift + Print` | Screenshot (full screen → clipboard) |

## Services (NixOS)

### Tailscale
Enabled system-wide. Provides mesh VPN between all devices.

### SSH
OpenSSH is enabled with hardened defaults:
- Root login disabled
- Password authentication disabled (key-only)
- Authorized key: ed25519 key for `arnavdandu@gmail.com`

### Syncthing
Runs as the `arnav` user for file sync between Mac and desktop.
- Web UI: `http://127.0.0.1:8384`
- Ports: 22000/tcp (sync), 21027/udp (discovery) — opened automatically
- Config stored at `~/.config/syncthing`

**Pairing with another device:**
1. Open the Syncthing web UI on both machines
2. On each machine, go to **Actions > Show ID** and copy the device ID
3. On each machine, click **Add Remote Device** and paste the other machine's ID
4. On the machine that has the folders, click **Add Folder**, set the path, and share with the other device
5. Accept the folder share on the receiving device

### Wake-on-LAN
Enabled on `enp6s0` (Ethernet). Requires WoL to also be enabled in BIOS/UEFI.

```bash
# Get the MAC address (run on NixOS before shutdown)
ip link show enp6s0 | grep ether

# Wake from another machine on the same LAN
wakeonlan AA:BB:CC:DD:EE:FF
```

Note: WoL requires the sender to be on the same local network — it won't work over Tailscale since the target machine is off.

## NVIDIA GPU Support

NVIDIA drivers are in separate optional modules (`nixos/nvidia.nix` + `home-nvidia.nix`) so the config works on machines with or without NVIDIA GPUs.

- `nvidia.nix` — kernel driver config (modesetting, open kernel modules, stable package)
- `home-nvidia.nix` — Hyprland env vars (`GBM_BACKEND`, `__GLX_VENDOR_LIBRARY_NAME`, etc.) for NVIDIA on Wayland

**On an NVIDIA machine** (current setup): no changes needed, both modules are imported in `flake.nix`.

**On a non-NVIDIA machine**: remove the two imports from `flake.nix`:

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

**Verifying NVIDIA is working:**
```bash
nvidia-smi                    # should show your GPU and driver version
lsmod | grep nvidia           # should list nvidia, nvidia_modeset, nvidia_drm
glxinfo | grep "OpenGL renderer"  # should show your NVIDIA GPU
```

> `nvidia.nix` uses `open = true` (open kernel modules), which requires a Turing+ GPU (RTX 20xx or newer). For older cards, set `open = false` in `nvidia.nix`.

## Maintenance

### EFI partition full
NixOS stores boot entries for each generation. If `/boot` fills up:
```bash
sudo nix-collect-garbage -d
sudo nixos-rebuild switch --flake .#arnav-nix
```
The config limits stored generations to 10 (`boot.loader.systemd-boot.configurationLimit = 10`) and auto-GCs generations older than 14 days weekly.

### Nix store disk usage
```bash
nix-store --gc --print-dead    # see what would be freed
sudo nix-collect-garbage -d    # delete all old generations and GC
nix store optimise              # deduplicate the store
```

## Notes

- `hardware-configuration.nix` is machine-specific and auto-generated — keep it in the repo for reproducibility
- Shared packages/config go in `home-common.nix`; platform-specific config goes in `home-darwin.nix` or `home-nixos.nix`
- Hyprland binary cache (`hyprland.cachix.org`) is configured on NixOS to speed up builds
- `programs.nix-ld` is enabled on NixOS to support dynamically linked binaries (e.g., Claude Code VS Code extension)
- macOS uses Ghostty as terminal; NixOS uses Kitty
