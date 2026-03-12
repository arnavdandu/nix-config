{ config, lib, pkgs, ... }:

{
  imports = [];  # hardware-configuration.nix is imported via flake.nix

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "arnav-nix";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # GNOME desktop
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Audio
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  # User
  users.users.arnav = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.fish;
  };

  # System-level packages (NixOS-only stuff)
  environment.systemPackages = with pkgs; [
    nixfmt
    nil
    nix-tree
    vim
    wget
    curl
    gcc
    gnumake
  ];

  programs.fish.enable = true;

  # Allow running dynamically linked binaries (e.g. Claude Code VS Code extension)
  programs.nix-ld.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11";
}
