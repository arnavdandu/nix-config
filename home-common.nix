{ pkgs, ... }:
{
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # ── LaTeX ──────────────────────────────────────────────
    texliveFull
    texstudio

    # ── Lean / formal methods ─────────────────────────────
    elan # lean version manager (provides lean)
    opam

    # ── Haskell ────────────────────────────────────────────
    ghc
    cabal-install
    stack
    ghcid
    haskell-language-server
    ormolu
    hlint
    haskellPackages.cabal-fmt
    haskellPackages.cabal2nix
    haskellPackages.hpack
    haskellPackages.implicit-hie

    # ── Web dev ────────────────────────────────────────────
    nodejs_22
    pnpm
    typescript
    nodePackages.typescript-language-server
    eslint
    prettier
    vscode-langservers-extracted
    tailwindcss
    esbuild
    dart-sass

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
    fastfetch

    # ── Dev tools ─────────────────────────────────────────
    deno
    emacs

    # ── Zsh extras ───────────────────────────────────────
    zsh-powerlevel10k
    nerd-fonts.meslo-lg

    # ── Media / misc ──────────────────────────────────────
    graphviz
    tesseract
    ffmpeg
    fortune
    yt-dlp
    jekyll
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

  # ── Zsh + Oh My Zsh ─────────────────────────────────────────
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "z"
        "sudo"
        "docker"
        "docker-compose"
        "fzf"
        "command-not-found"
        "history-substring-search"
        "colored-man-pages"
      ];
    };
  };

  # ── Catppuccin ───────────────────────────────────────────────
  catppuccin = {
    enable = true;
    flavor = "macchiato";
    accent = "mauve";
  };

  # ── Git (customize these) ─────────────────────────────────
  programs.git = {
    enable = true;
    settings.user.name = "Arnav Dandu";
    settings.user.email = "arnavdandu@gmail.com";
  };

  # ── Tmux ─────────────────────────────────────────────────
  programs.tmux = {
    enable = true;
    mouse = true;
    baseIndex = 1;
    terminal = "tmux-256color";
    historyLimit = 10000;
    escapeTime = 0;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      resurrect
      continuum
    ];
    extraConfig = ''
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '15'
    '';
  };
}
