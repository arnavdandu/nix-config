{ pkgs, ... }: {
  users.users.arnav = {
    name = "arnav";
    home = "/Users/arnav";
  };

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
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  system.stateVersion = 5;
}
