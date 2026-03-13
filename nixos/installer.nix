{ pkgs, lib, modulesPath, self, ... }:

let
  embeddedConfigDir = "/etc/nixos-config";
  installScript = pkgs.writeShellApplication {
    name = "install-arnav-nixos";
    runtimeInputs = with pkgs; [
      coreutils
      gitMinimal
      rsync
      util-linux
    ];
    text = ''
      set -euo pipefail

      target_root="''${1:-/mnt}"
      live_config="${embeddedConfigDir}"
      target_config="$target_root/etc/nixos-config"

      if ! mountpoint -q "$target_root"; then
        echo "Expected the target root filesystem to be mounted at $target_root." >&2
        echo "Partition and mount the target disk first, then mount the EFI partition at $target_root/boot." >&2
        exit 1
      fi

      if [ ! -d "$target_root/boot" ] || ! mountpoint -q "$target_root/boot"; then
        echo "Expected the boot/EFI partition to be mounted at $target_root/boot." >&2
        exit 1
      fi

      mkdir -p "$target_config"
      rsync -a --delete "$live_config/" "$target_config/"

      nixos-generate-config --root "$target_root"
      install -Dm644 \
        "$target_root/etc/nixos/hardware-configuration.nix" \
        "$target_config/nixos/hardware-configuration.nix"

      echo "Installing arnav-nix from $target_config ..."
      nixos-install --root "$target_root" --flake "$target_config#arnav-nix"
    '';
  };
in
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  networking.hostName = "venkey-installer";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    curl
    gitMinimal
    installScript
    rsync
    vim
    wget
  ];

  environment.etc."nixos-config".source = self.outPath;

  isoImage.isoName = "venkey-arnav-installer.iso";
  isoImage.volumeID = lib.mkForce "VENKEY_NIX";

  system.stateVersion = "25.11";
}
