{ pkgs, ... }: {
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # ── LaTeX ──────────────────────────────────────────────
    texliveFull
    texstudio

    # ── Lean / formal methods ─────────────────────────────
    elan          # lean version manager (provides lean)
    opam

    # ── Python ────────────────────────────────────────────
    python3
    python3Packages.pip
    python3Packages.virtualenv
    python3Packages.numpy
    python3Packages.matplotlib

    # ── CLI tools ─────────────────────────────────────────
    ripgrep
    fd
    fzf
    btop
    htop
    coreutils
    wget
    rsync
    gh
    git
    cmake

    # ── Dev tools ─────────────────────────────────────────
    deno
    vscode
    emacs

    # ── Media / misc ──────────────────────────────────────
    graphviz
    tesseract
    ffmpeg
    fortune
    yt-dlp
    vesktop
  ];

  # ── Fish shell ────────────────────────────────────────────
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

  # ── Git (customize these) ─────────────────────────────────
  programs.git = {
    enable = true;
    settings.user.name = "Arnav Dandu";
    settings.user.email = "arnavdandu@gmail.com";
  };
}
