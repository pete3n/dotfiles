{ config, pkgs, ... }:

{
  # Fix for Keychron K2 keyboard in Apple mode
  boot.extraModprobeConfig = ''
    options hid_apple fnmode=2
  '';
}
