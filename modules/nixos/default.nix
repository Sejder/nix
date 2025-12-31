{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Import your custom lib directly - no dependency on config
  myLib = import ../../lib { inherit lib; };
in
{
  imports = myLib.scanPathsRecursive ./. ++ [ ../../assets/wallpapers ];
}
