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
    };

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

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nvf,
      plasma-manager,
      nix-secrets,
      claude-desktop,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      sharedExtraArgs = {
        inherit
          inputs
          nix-secrets
          nixpkgs-unstable
          claude-desktop
          ;
        unstable-pkgs = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };

      sharedHomeModules = [
        nvf.homeManagerModules.default
        plasma-manager.homeModules.plasma-manager
      ];

      customLib = import ./lib { inherit (nixpkgs) lib; };
      lib = nixpkgs.lib.extend (_self: _super: { custom = customLib; });

      mkHost =
        hostName:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs lib nix-secrets;
            pkgs-unstable = sharedExtraArgs.unstable-pkgs;
          };
          modules = [
            ./hosts/${hostName}/configuration.nix
            home-manager.nixosModules.home-manager
            (
              { config, ... }:
              {
                home-manager = {
                  useGlobalPkgs = false;
                  useUserPackages = true;
                  backupCommand = "${pkgs.trashy}/bin/trash";

                  extraSpecialArgs = sharedExtraArgs // {
                    inherit (config.networking) hostName;
                    deviceType = config.device.type;
                  };

                  users = lib.genAttrs config.systemUsers.users (username: import ./users/${username}.nix);

                  sharedModules = sharedHomeModules;
                };
              }
            )
          ];
        };
    in
    {
      nixosConfigurations = {
        ideapad = mkHost "ideapad";
        home = mkHost "home";
        slimbook = mkHost "slimbook";
        galaxybook = mkHost "galaxybook";
      };

      homeConfigurations.mikke = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};

        extraSpecialArgs = sharedExtraArgs // {
          hostName = "wsl";
          deviceType = "wsl";
        };

        modules = [
          ./users/mikke-wsl.nix
        ]
        ++ sharedHomeModules;
      };
    };
}
