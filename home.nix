{ pkgs, ... }: {
    home.stateVersion = "24.11";
    home.packages = with pkgs; [
        texliveFull
        lean4
        opam
        # CLI tools
        ripgrep
        fd
        fzf
        btop
        coreutils
        wget
        rsync
        fortune
        yt-dlp
        gh
        git
        cmake
        # dev tools
        deno
        pyenv
        emacs
        # misc
        graphviz
        tesseract
        ffmpeg  # if you use it, covers many of the media libs
    ];
  programs.fish = {
    enable = true;
    functions = {
      lxf = ''
        set base (string length -q -- $argv[1]; and echo $argv[1]; or echo $HOME/research)
        set dir (find $base -name "*.tex" -exec dirname {} \; | sort -u | fzf --prompt="LaTeX project> ")
        if test -n "$dir"
          cd $dir
          code .
        end
      '';
    };
  };
  # in home.nix
  xdg.configFile."ghostty/config".text = ''
    font-family = JetBrains Mono
    font-size = 14
    theme = Catppuccin Mocha
    macos-option-as-alt = true
    command = /opt/homebrew/bin/fish
    keybind = global:ctrl+opt+t=toggle_quick_terminal
  '';
}