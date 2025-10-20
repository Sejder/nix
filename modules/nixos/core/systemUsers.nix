{
  lib,
  config,
  ...
}: let
  cfg = config.systemUsers;
in {
  options.systemUsers = {
    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of users to create on this system";
      example = ["mikke" "spouse" "kids"];
    };

    primaryUser = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Primary user for system-level features (autologin, docker, etc.)";
      example = "mikke";
    };
  };

  config = {
    assertions = [
      {
        assertion = cfg.users != [];
        message = "systemUsers.users must be set at the host level with at least one user.";
      }
      {
        assertion = cfg.primaryUser != "";
        message = "systemUsers.primaryUser must be set at the host level.";
      }
      {
        assertion = builtins.elem cfg.primaryUser cfg.users;
        message = "systemUsers.primaryUser must be one of the users in systemUsers.users.";
      }
    ];
  };
}
