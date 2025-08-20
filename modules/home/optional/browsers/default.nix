{ lib, ... }:

{
  imports = lib.custom.scanPathsRecursive ./.;
}