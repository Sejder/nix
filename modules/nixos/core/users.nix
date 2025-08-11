{ ... }:

{
  users.users.mikke = {
    isNormalUser = true;
    description = "mikke";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}