{
  pkgs,
  config,
  lib,
  ...
}:

{
  options.features.fonts = lib.mkOption {
    type = lib.types.str;
    default = "jetbrainsMono";
    description = "Select which font to enable by default.";
  };

  config = lib.mkIf (config.features.fonts == "jetbrainsMono") {
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrains Mono" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
      };
    };

    home.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
  };
}
