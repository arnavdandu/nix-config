{
  description = "Arnav's multi-system Nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    catppuccin.url = "github:catppuccin/nix";

    hyprland.url = "github:hyprwm/Hyprland";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, catppuccin, home-manager, hyprland, ... }: {

    # ── macOS ──────────────────────────────────────────────
    darwinConfigurations."Arnavs-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./darwin.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "bak";
          home-manager.users.arnav = {
            imports = [ ./home-common.nix ./home-darwin.nix catppuccin.homeModules.catppuccin ];
          };
        }
      ];
    };

    # ── NixOS ──────────────────────────────────────────────
    nixosConfigurations."arnav-nix" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./nixos/configuration.nix
        ./nixos/hardware-configuration.nix
        ./nixos/nvidia.nix              # remove this line on non-NVIDIA machines

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "bak";
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.arnav = {
            imports = [ ./home-common.nix 
                        ./home-nixos.nix 
                        ./home-nvidia.nix 
                        catppuccin.homeModules.catppuccin
            ];  # remove home-nvidia.nix on non-NVIDIA machines
          };
        }
      ];
    };
  };
}
