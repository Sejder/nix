{
  description = "My modular NixOS + Home Manager configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable-nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    nvf,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    # Create custom lib that can be used independently
    customLib = import ./lib {lib = nixpkgs.lib;};

    # Extended lib for NixOS (preserves all existing extensions)
    lib = nixpkgs.lib.extend (self: super: {custom = customLib;});
    mkHost = hostName:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs lib;};
        modules = [
          ./hosts/${hostName}/configuration.nix
          home-manager.nixosModules.home-manager
          ({config, ...}: {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users = {
                mikke = import ./users/mikke.nix;
              };
              extraSpecialArgs = {
                hostName = config.networking.hostName;
              };
              sharedModules = [
                nvf.homeManagerModules.default
              ];
              backupFileExtension = "backup";

            };
          })
        ];
      };
  in {
    nixosConfigurations = {
      ideapad = mkHost "ideapad";
      home = mkHost "home";
      slimbook = mkHost "slimbook";
    };
    homeConfigurations.mikke = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {hostName = "wsl";};
      # No extraSpecialArgs needed - modules import lib directly
      modules = [
        ./users/mikke.nix
        nvf.homeManagerModules.default
      ];
    };
  };
}
