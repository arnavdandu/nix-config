# home-nixos.nix
{ pkgs, inputs, ... }:

{
  # ── NixOS-only packages ───────────────────────────────────
  home.packages = with pkgs; [
    firefox
    code-cursor
    cliphist
    wl-clipboard
    hyprlock
    hypridle
  ];

  # ── Ghostty (Linux) ──────────────────────────────────────
  xdg.configFile."ghostty/config".text = ''
    font-family = JetBrains Mono
    font-size = 14
    theme = Catppuccin Mocha
    command = fish
  '';

  # ── Hyprland ─────────────────────────────────────────────
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mod" = "SUPER";

      monitor = ",preferred,auto,1";

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(cba6f7ff) rgba(89b4faff) 45deg";
        "col.inactive_border" = "rgba(585b70ff)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          new_optimizations = true;
        };
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad.natural_scroll = true;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # ── Keybinds ───────────────────────────────────────
      bind = [
        "$mod, Return, exec, kitty"
        "$mod, Q, killactive,"
        "$mod SHIFT, M, exit,"
        "$mod, V, togglefloating,"
        "$mod, D, exec, rofi -show drun -show-icons"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"
        "$mod, F, fullscreen,"

        # Move focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Also vim-style focus
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"

        # Move window to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"

        # Scroll through workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        # Screenshot (region select → clipboard)
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "SHIFT, Print, exec, grim - | wl-copy"

        # Clipboard history
        "$mod, C, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
      ];

      # Mouse binds
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # ── Window rules ─────────────────────────────────────
      windowrulev2 = [
        "float, class:^(pavucontrol)$"
        "float, class:^(nm-connection-editor)$"
        "float, class:^(blueman-manager)$"
        "float, title:^(Open File)$"
        "float, title:^(Save File)$"
        "float, title:^(Confirm to replace files)$"
        "opacity 0.95, class:^(kitty)$"
        "opacity 0.95, class:^(com.mitchellh.ghostty)$"
      ];

      # ── Autostart ──────────────────────────────────────
      exec-once = [
        "swww-daemon"
        "waybar"
        "dunst"
        "nm-applet --indicator"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "hypridle"
      ];
    };
  };
}
