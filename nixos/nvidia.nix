# nixos/nvidia.nix — NVIDIA GPU driver support
# Import this module only on machines with NVIDIA GPUs.
{ config, pkgs, ... }:

{
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;                # use open kernel modules (Turing+); set false for older GPUs
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
