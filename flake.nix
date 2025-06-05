{
  description = "My NixOS Flake Configuration";

  inputs = {
    # Nixpkgs (stable or unstable)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05"; # Or "nixos-24.05" for stable

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs"; # Ensures Home Manager uses the same nixpkgs
    };

    catppuccin.url = "github:catppuccin/nix";

    # media server things
    nixarr.url = "github:rasmus-kirk/nixarr";
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, nixarr, ... }@inputs: {
    nixosConfigurations = {
      # Replace "nixos" with your actual desired hostname if it's different
      # This "nixos" must match the `networking.hostName` in your configuration.nix
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # Or your system's architecture
        specialArgs = { inherit inputs; }; # Pass inputs to your modules
        modules = [
          # Your main configuration file
          ./configuration.nix

          # nixarr module
          nixarr.nixosModules.default

          # Home Manager module
          home-manager.nixosModules.home-manager {
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
    };
  };
}
