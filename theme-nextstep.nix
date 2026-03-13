# theme-nextstep.nix — NeXTSTEP / 90s Apple aesthetic
# Import this module to activate the theme; remove the import to revert.
{ pkgs, lib, ... }:

let
  # ── NeXTSTEP palette ─────────────────────────────────────────
  bg        = "#333333";
  bgLight   = "#aaaaaa";
  bgMid     = "#838383";
  bgDark    = "#1e1e1e";
  fg        = "#000000";
  fgLight   = "#ffffff";
  border    = "#000000";
  borderLt  = "#555555";
  accent    = "#7a7a9a";   # muted steel-blue, NeXT-ish highlight
  titlebar  = "#666666";
  selection = "#4a4a6a";

  gtkCss = ''
    /* NeXTSTEP-inspired overrides */
    @define-color theme_bg_color ${bgLight};
    @define-color theme_fg_color ${fg};
    @define-color theme_selected_bg_color ${selection};
    @define-color theme_selected_fg_color ${fgLight};

    window, .background {
      background-color: ${bgLight};
      color: ${fg};
    }

    headerbar, .titlebar {
      background: linear-gradient(to bottom, #999999, ${titlebar});
      border-bottom: 2px solid ${border};
      color: ${fgLight};
      border-radius: 0;
      box-shadow: inset 0 1px 0 rgba(255,255,255,0.2),
                  inset 0 -1px 0 rgba(0,0,0,0.3);
    }

    button {
      background: linear-gradient(to bottom, #cccccc, #999999);
      border: 1px solid ${border};
      border-radius: 2px;
      color: ${fg};
      box-shadow: inset 0 1px 0 rgba(255,255,255,0.4);
    }

    button:hover {
      background: linear-gradient(to bottom, #dddddd, #aaaaaa);
    }

    button:active {
      background: linear-gradient(to bottom, #888888, #aaaaaa);
      box-shadow: inset 0 2px 3px rgba(0,0,0,0.3);
    }

    menu, .menu, popover {
      background-color: ${bgLight};
      border: 2px solid ${border};
      border-radius: 0;
      box-shadow: 2px 2px 0 rgba(0,0,0,0.5);
    }

    entry, textview {
      background-color: #ffffff;
      border: 2px inset ${borderLt};
      border-radius: 0;
    }

    scrollbar slider {
      background-color: ${bgMid};
      border: 1px solid ${border};
      border-radius: 0;
    }
  '';

  waybarStyle = ''
    * {
      font-family: "MesloLGS Nerd Font", "Helvetica", monospace;
      font-size: 13px;
      border: none;
      border-radius: 0;
    }

    window#waybar {
      background: linear-gradient(to bottom, #999999, ${titlebar});
      border-bottom: 2px solid ${border};
      color: ${fgLight};
    }

    #workspaces button {
      padding: 2px 8px;
      margin: 2px;
      background: linear-gradient(to bottom, #bbbbbb, #888888);
      border: 1px solid ${border};
      color: ${fg};
      border-radius: 2px;
      box-shadow: inset 0 1px 0 rgba(255,255,255,0.3);
    }

    #workspaces button.active {
      background: linear-gradient(to bottom, #666666, #444444);
      color: ${fgLight};
      box-shadow: inset 0 2px 3px rgba(0,0,0,0.4);
    }

    #clock, #battery, #network, #pulseaudio, #cpu, #memory, #tray {
      padding: 0 10px;
      margin: 2px 1px;
      background: linear-gradient(to bottom, #bbbbbb, #888888);
      border: 1px solid ${border};
      color: ${fg};
      border-radius: 2px;
      box-shadow: inset 0 1px 0 rgba(255,255,255,0.3);
    }

    tooltip {
      background-color: ${bgLight};
      border: 2px solid ${border};
      border-radius: 0;
      color: ${fg};
    }
  '';

  rofiTheme = pkgs.writeText "nextstep.rasi" ''
    * {
      bg:       ${bgLight};
      fg:       ${fg};
      sel-bg:   ${selection};
      sel-fg:   ${fgLight};
      border:   ${border};
      font:     "MesloLGS Nerd Font 13";
    }

    window {
      background-color: @bg;
      border:           3px solid;
      border-color:     @border;
      border-radius:    0;
      width:            35%;
    }

    mainbox {
      background-color: @bg;
      children:         [ inputbar, listview ];
      spacing:          0;
    }

    inputbar {
      background-color: #999999;
      text-color:       @fg;
      padding:          8px;
      border:           0 0 2px 0;
      border-color:     @border;
    }

    prompt, entry {
      background-color: inherit;
      text-color:       @fg;
    }

    entry {
      background-color: #ffffff;
      padding:          4px 8px;
      border:           1px solid;
      border-color:     @border;
    }

    listview {
      background-color: @bg;
      lines:            10;
      padding:          4px;
      scrollbar:        true;
    }

    element {
      background-color: @bg;
      text-color:       @fg;
      padding:          6px 8px;
      border-radius:    0;
    }

    element selected {
      background-color: @sel-bg;
      text-color:       @sel-fg;
    }

    scrollbar {
      background-color: #999999;
      handle-color:     #666666;
      handle-width:     12px;
      border:           1px solid;
      border-color:     @border;
    }
  '';

in {
  # ── Disable Catppuccin when this theme is active ──────────────
  catppuccin.enable = lib.mkForce false;

  # ── GTK: NeXTSTEP overrides ──────────────────────────────────
  gtk = {
    enable = true;
    font = {
      name = "Sans";
      size = 11;
    };
    gtk3.extraCss = gtkCss;
    gtk4.extraCss = gtkCss;
  };

  # ── Kitty: NeXTSTEP terminal colors ──────────────────────────
  programs.kitty = {
    settings = {
      foreground           = "#e0e0e0";
      background           = bgDark;
      cursor               = "#e0e0e0";
      selection_foreground  = fgLight;
      selection_background  = selection;
      url_color            = accent;

      # Black
      color0  = "#1e1e1e";
      color8  = "#555555";
      # Red
      color1  = "#b04040";
      color9  = "#d06060";
      # Green
      color2  = "#50a050";
      color10 = "#70c070";
      # Yellow
      color3  = "#b0a040";
      color11 = "#d0c060";
      # Blue
      color4  = "#5070a0";
      color12 = "#7090c0";
      # Magenta
      color5  = "#906090";
      color13 = "#b080b0";
      # Cyan
      color6  = "#508080";
      color14 = "#70a0a0";
      # White
      color7  = "#aaaaaa";
      color15 = "#e0e0e0";

      tab_bar_style        = "separator";
      tab_separator        = " | ";
      active_tab_foreground   = fgLight;
      active_tab_background   = titlebar;
      inactive_tab_foreground = bgMid;
      inactive_tab_background = bgDark;
    };
  };

  # ── Hyprland: sharp, boxy, minimal ──────────────────────────
  wayland.windowManager.hyprland.settings = {
    general = lib.mkForce {
      gaps_in = 2;
      gaps_out = 4;
      border_size = 2;
      "col.active_border" = "rgba(aaaaaaff)";
      "col.inactive_border" = "rgba(333333ff)";
      layout = "dwindle";
    };

    decoration = lib.mkForce {
      rounding = 0;
      blur = {
        enabled = false;
      };
      shadow = {
        enabled = true;
        range = 8;
        render_power = 2;
        color = "rgba(000000aa)";
        offset = "3 3";
      };
    };

    animations = lib.mkForce {
      enabled = true;
      bezier = "snappy, 0.2, 1.0, 0.3, 1.0";
      animation = [
        "windows, 1, 3, snappy"
        "windowsOut, 1, 3, snappy, popin 90%"
        "fade, 1, 3, default"
        "workspaces, 1, 3, snappy"
      ];
    };
  };

  # ── Waybar: NeXTSTEP bar ─────────────────────────────────────
  programs.waybar = {
    enable = true;
    style = waybarStyle;
  };

  # ── Dunst: boxy notifications ────────────────────────────────
  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "MesloLGS Nerd Font 11";
        frame_width = 2;
        frame_color = border;
        corner_radius = 0;
        separator_color = "frame";
        padding = 8;
        horizontal_padding = 10;
        offset = "10x10";
      };
      urgency_low = {
        background = bgLight;
        foreground = fg;
      };
      urgency_normal = {
        background = bgLight;
        foreground = fg;
      };
      urgency_critical = {
        background = "#b04040";
        foreground = fgLight;
        frame_color = "#b04040";
      };
    };
  };

  # ── Rofi: override launch command in Hyprland ────────────────
  # Point rofi to the NeXTSTEP theme file
  home.file.".config/rofi/nextstep.rasi".source = rofiTheme;

  # Shell alias to switch rofi theme easily
  programs.fish.shellAbbrs = {
    rofi-next = "rofi -show drun -show-icons -theme nextstep";
  };
}
