{
  description = "My modular NixOS + Home Manager configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nvf = {
      url = "github:notashelf/nvf/v0.8";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-desktop = {
      url = "github:k3d3/claude-desktop-linux-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      #inputs.flake-utils.follows = "flake-utils";
    };

    # agenix = {
    #   url = "github:ryantm/agenix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nix-secrets = {
      url = "git+ssh://git@github.com/Mikkelsej/nix-secrets.git?ref=main";
      flake = false;
    };
  };
  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nixos-hardware,
    nvf,
    claude-desktop,
    plasma-manager,
    # agenix,
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
        specialArgs = {
          inherit inputs lib nix-secrets nixpkgs-unstable;
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };
        modules = [
          ./hosts/${hostName}/configuration.nix
          # agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          ({config, ...}: {
            home-manager = {
              useGlobalPkgs = false;
              useUserPackages = true;
              users = lib.genAttrs config.systemUsers.users (
                username:
                  import ./users/${username}.nix
              );
              extraSpecialArgs = {
                hostName = config.networking.hostName;
                deviceType = config.device.type;

                inherit nixpkgs-unstable claude-desktop;
                unstable-pkgs = import nixpkgs-unstable {
                  system = "x86_64-linux";
                  config.allowUnfree = true;
                };
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
      galaxybook = mkHost "galaxybook";
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
