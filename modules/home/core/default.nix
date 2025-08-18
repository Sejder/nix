{ pkgs, lib, ... }:

{
  imports = lib.custom.scanPathsRecursive ./.;
}