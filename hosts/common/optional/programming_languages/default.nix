{ config, pkgs, ... }:
{
    imports = [
      
    ];

    home.packages = with pkgs; [
      # Python
      python3Full

      # Java
      jdk
      
      # C
      gcc
    ];
}