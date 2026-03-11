{ pkgs, ... }: {
  # THIS is the key line that was missing — declares your user at the system level
  users.users.arnav = {
    name = "arnav";
    home = "/Users/arnav";
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

    environment.systemPackages = with pkgs; [
    # nix tools
    nixfmt            # nix formatter (the older standard one)
    nil               # nix LSP for editor integration
    nix-tree          # visualize nix store dependencies

    # core system tools
    fish
    fzf 
    git
    curl
    wget
    ];
  programs.fish.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = 5;
}