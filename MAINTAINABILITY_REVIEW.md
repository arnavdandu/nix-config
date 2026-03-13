# nix-config maintainability review

This review focuses on long-term readability, reducing duplication, and making host-specific choices clearer for future edits.

## Strengths

- Good separation between system modules (`nixos/`, `darwin.nix`) and user modules (`home-*.nix`).
- NVIDIA-specific configuration is isolated into optional modules.
- Installer path is reproducible and self-contained.

## Observed maintainability risks

1. **Repeated Home Manager wiring in `flake.nix`**
   - `home-manager.useGlobalPkgs`, `useUserPackages`, and `backupFileExtension` were repeated for each host.
   - Repetition makes host additions error-prone and increases drift risk.

2. **Host/user literals duplicated across files**
   - Username and backup extension were inlined in multiple places.
   - These are stable values and should be centralized where practical.

3. **Mixed optional-module comments in list tails**
   - `home-nvidia.nix` guidance previously lived as a trailing list comment, which can be missed while editing.
   - Inline comments near the optional import are clearer.

4. **Package list duplication in `home-common.nix`**
   - `fzf` appeared in two sections.
   - Duplicate package declarations are harmless but add noise during review.

5. **README operational commands have a path typo risk**
   - Some sections clone into repo root but then `cd nix-config/nixos` even though flake lives at root.
   - This can confuse fresh installs and creates support overhead.

## Improvements implemented in this change

- Added a small `mkHomeManagerModule` helper in `flake.nix` to centralize common Home Manager wiring.
- Introduced shared `username` and `homeBackupExtension` locals in `flake.nix`.
- Moved NVIDIA import guidance to the specific list entry for better visibility.
- Removed duplicate `fzf` from `home-common.nix` package list.

## Suggested next steps (not yet implemented)

- Add a tiny `lib/constants.nix` (or `hosts/default.nix`) for hostnames, usernames, and system strings.
- Split `home-nixos.nix` into topical modules (`hyprland.nix`, `kitty.nix`, `waybar.nix`) if it keeps growing.
- Add `nix fmt` + `nix flake check` to CI for drift prevention.
- Add a short comment convention guide (`what` vs `why`) to keep comments high-signal.
- Add a host matrix table in README that maps each host to imported optional modules.
