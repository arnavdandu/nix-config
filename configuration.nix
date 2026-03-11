{ pkgs, ... }: {
  # THIS is the key line that was missing — declares your user at the system level
  users.users.arnav = {
    name = "arnav";
    home = "/Users/arnav";
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPackages = with pkgs; [
    fish
    fzf
    git
  ];

  programs.fish.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = 5;
}