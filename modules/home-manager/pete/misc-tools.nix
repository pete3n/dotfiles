{
  lib,
  pkgs,
  ...
}: {
  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
      theme_background = false;
      color_theme = "nord";
    };
  };
}
