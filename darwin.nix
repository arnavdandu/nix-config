{ pkgs, ... }: {
  users.users.arnav = {
    name = "arnav";
    home = "/Users/arnav";
  };

  system.primaryUser = "arnav";
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPackages = with pkgs; [
    nixfmt
    nil
    nix-tree
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
