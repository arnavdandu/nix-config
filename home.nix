{ pkgs, ... }: {
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    texliveFull
    lean4
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
}