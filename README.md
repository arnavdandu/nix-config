# nix-config

Arnav's multi-system Nix configuration.

## Structure

```
flake.nix                    # entry point — darwin + nixos outputs
darwin.nix                   # macOS system config (nix-darwin)
nixos/
  configuration.nix          # NixOS system config
  hardware-configuration.nix # (generated, don't commit — or do, your call)
home-common.nix              # shared home-manager (fish, packages, git)
home-darwin.nix              # macOS-specific home (Ghostty macOS settings)
home-nixos.nix               # NixOS-specific home (firefox, linux apps)
```

## Usage

**macOS (nix-darwin):**
```bash
darwin-rebuild switch --flake .#Arnavs-MacBook-Pro
```

**NixOS:**
```bash
sudo nixos-rebuild switch --flake .#arnav-nix
```

## Notes

- `hardware-configuration.nix` is machine-specific and auto-generated.
  Keep it in the repo if you want full reproducibility, or gitignore it.
- Shared packages/config go in `home-common.nix`.
- Platform-specific stuff goes in `home-darwin.nix` or `home-nixos.nix`.
