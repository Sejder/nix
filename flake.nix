{
  description = "My modular NixOS + Home Manager configuration";
  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-secrets = {
      url = "git+ssh://git@github.com/Mikkelsej/nix-secrets.git?ref=main";
      flake = false;
    };
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    nvf,
    agenix,
    nix-secrets,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    customLib = import ./lib {lib = nixpkgs.lib;};

    lib = nixpkgs.lib.extend (self: super: {custom = customLib;});
    mkHost = hostName:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs lib nix-secrets;};
        modules = [
          ./hosts/${hostName}/configuration.nix
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          ({config, ...}: {
            home-manager = {
              useGlobalPkgs = false;
              useUserPackages = true;
              users = lib.genAttrs config.systemUsers.users (username:
                import ./users/${username}.nix
              );
              extraSpecialArgs = {
                hostName = config.networking.hostName;
                deviceType = config.device.type;
              };
              sharedModules = [
                nvf.homeManagerModules.default
                inputs.plasma-manager.homeModules.plasma-manager
              ];
              backupCommand = "${pkgs.trashy}/bin/trash";
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
      modules = [
        ./users/mikke-wsl.nix
        nvf.homeManagerModules.default
      ];
    };
  };
}
