{ pkgs, ... }: # 1. Remove makeDesktopItem from here

{
  environment.systemPackages = [
    # 2. Access it via pkgs.makeDesktopItem
    (pkgs.makeDesktopItem {
      name = "mathematica";
      desktopName = "Mathematica";
      exec = "${pkgs.mathematica}/bin/wolframnb";
    })
    pkgs.mathematica
  ];
}