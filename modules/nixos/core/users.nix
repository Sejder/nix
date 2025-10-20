{ config, lib, ... }:

{
  users.users = lib.genAttrs config.systemUsers.users (username: {
    isNormalUser = true;
    description = username;
    extraGroups = [ "networkmanager" "wheel" ];
  });
}