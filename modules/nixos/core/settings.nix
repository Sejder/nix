{ inputs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  
  nix = {
    settings.experimental-features = [ "flakes" "nix-command" ];

    optimise = {
      automatic = true;
      dates = [ "11:30" ];
    };

    gc = {
      automatic = true;
      dates = "11:15";
      options = "--delete-older-than 10d";
    };
  };
  
  services.printing.enable = true;
  networking.networkmanager.enable = true;

  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L"
    ];
    dates = "11:00";
  };
}