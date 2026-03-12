{ pkgs, ... }: {
  # ── macOS-only packages ───────────────────────────────────
  home.packages = with pkgs; [
    # add any Darwin-only packages here
    tailscale
  ];

  # ── Syncthing ────────────────────────────────────────────
  services.syncthing.enable = true;

  # ── Ghostty (macOS) ──────────────────────────────────────
  xdg.configFile."ghostty/config".text = ''
    font-family = JetBrains Mono
    font-size = 14
    theme = Catppuccin Mocha
    macos-option-as-alt = true
    command = fish
    keybind = global:ctrl+opt+t=toggle_quick_terminal
  '';
}
