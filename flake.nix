{
  description = "Unified NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };


  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      hostnames = [ "slimbook" "galaxybook" "ideapad" ];

      mkHost = hostname: nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs hostname;
          isNixOS = true;
        };

        modules = [
          ./hosts/${hostname}/configuration.nix
          home-manager.nixosModules.default
        ];
      };
    in {
      nixosConfigurations = builtins.listToAttrs
        (map (name: { name = name; value = mkHost name; }) hostnames);

      homeConfigurations = {
        mikke = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            ./hosts/galaxybook/home.nix
          ];

          extraSpecialArgs = {
            inherit inputs;
            isNixOS = false;
            hostname = "galaxybook";
          };
        };
      };
    };
}
