{ pkgs, ... }: {
  # ── NixOS-only packages ───────────────────────────────────
  home.packages = with pkgs; [
    firefox
    code-cursor
    # add any Linux-only packages here (e.g. desktop apps)
  ];

  # ── Ghostty (Linux) ──────────────────────────────────────
  xdg.configFile."ghostty/config".text = ''
    font-family = JetBrains Mono
    font-size = 14
    theme = Catppuccin Mocha
    command = fish
  '';
}
