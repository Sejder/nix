{
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
      timeout = null;
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
        #theme = ./../../modules/nixos/grub-themes/Particle-window;
      };
    };
  }; 
}