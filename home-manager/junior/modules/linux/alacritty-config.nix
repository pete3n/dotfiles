{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.7;
        padding = {
          x = 5;
          y = 5;
        };
      };
      font = {
        size = 12;
      };
      colors = {
        primary = {
          background = "#090300";
          foreground = "#a5a2a2";
        };
        cursor = {
          text = "#090300";
          cursor = "#a5a2a2";
        };
        normal = {
          black = "#090300";
          red = "#db2d20";
          green = "#01a252";
          yellow = "#fded02";
          blue = "#01a0e4";
          magenta = "#a16a94";
          cyan = "#b5e4f4";
          white = "#a5a2a2";
        };
        bright = {
          black = "#5c5855";
          red = "#db2d20";
          green = "#01a252";
          yellow = "#fded02";
          blue = "#01a0e4";
          magenta = "#a16a94";
          cyan = "#b5e4f4";
          white = "#f7f7f7";
        };
      };
    };
  };
}
