{
  description = "My NixOS Flake Configuration";

  inputs = {
    # Nixpkgs (stable or unstable)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs"; # Ensures Home Manager uses the same nixpkgs
    };
    catppuccin.url = "github:catppuccin/nix";
    niri.url = "github:sodiboo/niri-flake";
    nixarr.url = "github:rasmus-kirk/nixarr";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      catppuccin,
      niri,
      nixarr,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        # Replace "nixos" with your actual desired hostname if it's different
        # This "nixos" must match the `networking.hostName` in your configuration.nix
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux"; # Or your system's architecture
          specialArgs = { inherit inputs; }; # Pass inputs to your modules
          modules = [
            # Your main configuration file
            ./configuration.nix
            catppuccin.nixosModules.catppuccin

            ({
              nixpkgs.overlays = [ niri.overlays.niri ];
            })

            # nixarr module
            nixarr.nixosModules.default

            # Home Manager module
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.sean = import ./home.nix;
            }
          ];
        };
      };
    };
}
