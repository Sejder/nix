{
  description = "My modular NixOS + Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib.extend (self: super: { custom = import ./lib { inherit (nixpkgs) lib; }; });


      mkHost = hostName: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs lib; }; 
        modules = [
          ./hosts/${hostName}/configuration.nix                             
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mikke = import ./users/mikke.nix;
          }
        ];
      };
    in {
      nixosConfigurations = {
        ideapad = mkHost "ideapad";
        slimbook = mkHost "slimbook";
      };
    };
}
