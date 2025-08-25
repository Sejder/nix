{
  description = "My modular NixOS + Home Manager configuration";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nvf.url = "github:notashelf/nvf";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, nvf, ... }@inputs:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib.extend (self: super: { custom = import ./lib { inherit (nixpkgs) lib; }; });
    
    mkHost = hostName: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs lib; };
      modules = [
        ./hosts/${hostName}/configuration.nix
        #nvf.nixosModules.default
        
        home-manager.nixosModules.home-manager

        ({ config, ... }: {

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
          };
        })
      ];
    };
  in {
    nixosConfigurations = {
      ideapad = mkHost "ideapad";
      slimbook = mkHost "slimbook";
    };
    
    homeConfigurations.mikke = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [ 
        ./users/mikke.nix
        nvf.homeManagerModules.default
      ];
    };
  };
}
