# home-nvidia.nix — Hyprland environment variables for NVIDIA GPUs
# Import this module only on machines with NVIDIA GPUs.
{ ... }:

{
  wayland.windowManager.hyprland.settings.env = [
    "LIBVA_DRIVER_NAME,nvidia"
    "XDG_SESSION_TYPE,wayland"
    "GBM_BACKEND,nvidia-drm"
    "__GLX_VENDOR_LIBRARY_NAME,nvidia"
  ];
}
