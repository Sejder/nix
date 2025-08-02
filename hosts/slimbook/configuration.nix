{ config, pkgs, inputs, lib, hostname, isNixOS, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default  # Import Home Manager module
      ./../../modules/nixos/maintainence.nix 
      ./../../modules/nixos/display-managers/sddm.nix     
      ./../../modules/nixos/server/default.nix 
    ];


  services.power-profiles-daemon.enable = true;  
  time.hardwareClockInLocalTime = false;

  # Bootloader setup
  boot = {
    plymouth = {
      enable = true;
    };
    consoleLogLevel = 0;  
    kernelParams = [ 
      "quiet"
      "loglevel=0"
      ];  
    initrd.verbose = false;
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 5;
      grub = {
        enable = true;
        efiSupport = true;
        useOSProber = true;
        device = "nodev";
        extraEntries = ''
          menuentry "Reboot into UEFI Firmware Settings" {
            fwsetup
          }
        '';
        default = "0";
        splashImage = null;
        theme = ./../../modules/nixos/grub-themes/Particle-window;
      };
    };
  };

  networking.hostName = "slimbook"; # Define hostname
  networking.networkmanager.enable = true;  # Enable NetworkManager

  # Set the timezone and locale
  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_DK.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };

  console.keyMap = "dk-latin1"; # Set keymap

  # Enable CUPS for printing
  services.printing.enable = true;

  # Sound configuration with Pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # User configuration for 'mikke'
  users.users.mikke = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "mikke";
    extraGroups = [ "networkmanager" "wheel" "input" "video" "audio" "docker" ];
    packages = with pkgs; [
      # Add any user-specific packages here
    ];
  };



  # Ensure GVfs is enabled for full functionality
  services.gvfs.enable = true;

  # Enable the necessary GStreamer plugins for audio/video properties
  nixpkgs.overlays = [
    (final: prev: {
      nautilus = prev.nautilus.overrideAttrs (nprev: {
        buildInputs = nprev.buildInputs ++ (with pkgs.gst_all_1; [
          gst-plugins-good
          gst-plugins-bad
        ]);
      });
    })
  ];

  # Link thumbnailers for preview support
  environment.pathsToLink = [ "share/thumbnailers" ];

  # Hyprland configuration (Wayland compositor)
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Allow unfree packages (for example, proprietary drivers)
  nixpkgs.config.allowUnfree = true;

  # Installed system-wide packages
  environment.systemPackages = with pkgs; [
    vim
    
    
    wget
    git
    firefox
    
    nautilus
    nautilus-open-any-terminal
    
    pipewire
    pavucontrol
    wireplumber
    bluez
    blueman
    pywal
    brightnessctl # For brigtness keybinding
    pulseaudio # For Volume Keybinding
    playerctl # For Volume Control
    bibata-cursors

    home-manager
    # Add support for HEIC image preview in Nautilus
    pkgs.libheif
    pkgs.libheif.out   

    power-profiles-daemon
  ];
  
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  
  services.blueman.enable = true;  

  # Enable xdg portal for Wayland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Enable Home Manager configuration for user 'mikke'
  home-manager = {
    extraSpecialArgs = { inherit inputs hostname isNixOS; };
    users = {
      mikke = import ./home.nix;  # Import user-specific home manager config
    };
    backupFileExtension = "backup";
  };
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  
  virtualisation.docker.enable = true;


  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];
  };

  programs.zsh.enable = true;

  # Optional: Enable OpenSSH if needed
  # services.openssh.enable = true;

  # Set state version (important for NixOS upgrades)
  system.stateVersion = "25.05";  # Ensure you're using the correct state version
}
