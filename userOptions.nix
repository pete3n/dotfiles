{ lib, ... }:

{
  options = {
    userOptions.username = lib.mkOption {
      type = lib.types.str;
      default = "nix-user";
      description = "Username option to pass to sub-modules";
    };
  };
}
