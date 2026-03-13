{
  description = "Arnav's multi-system Nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    catppuccin.url = "github:catppuccin/nix";

    hyprland.url = "github:hyprwm/Hyprland";

    solaar = {
      url = "https://flakehub.com/f/Svenum/Solaar-Flake/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, catppuccin, home-manager, hyprland, solaar, ... }:
  let
    username = "arnav";
    homeBackupExtension = "bak";
    mkHomeManagerModule = { imports, extraSpecialArgs ? {} }: {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = homeBackupExtension;
      home-manager.extraSpecialArgs = extraSpecialArgs;
      home-manager.users.${username} = {
        inherit imports;
      };
    };
  in
  rec {

    # ── macOS ──────────────────────────────────────────────
    darwinConfigurations."Arnavs-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./darwin.nix
        home-manager.darwinModules.home-manager
        (mkHomeManagerModule {
          imports = [ ./home-common.nix ./home-darwin.nix catppuccin.homeModules.catppuccin ];
        })
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
        solaar.nixosModules.default

        home-manager.nixosModules.home-manager
        (mkHomeManagerModule {
          extraSpecialArgs = { inherit inputs; };
          imports = [
            ./home-common.nix
            ./home-nixos.nix
            ./home-nvidia.nix  # remove this line on non-NVIDIA machines
            catppuccin.homeModules.catppuccin
          ];
        })
      ];
    };

    nixosConfigurations."venkey-installer" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs self; };
      modules = [
        ./nixos/installer.nix
      ];
    };

    packages.x86_64-linux.venkey-installer-iso =
      nixosConfigurations."venkey-installer".config.system.build.isoImage;


    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-rfc-style;

    devShells.x86_64-linux.default =
      let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      in
      pkgs.mkShell {
        packages = with pkgs; [
          nil
          nixfmt-rfc-style
        ];
      };
  };
}
