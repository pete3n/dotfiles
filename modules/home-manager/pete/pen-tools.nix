{
  pkgs,
  lib,
  ...
}: {
  home.packages = lib.mkAfter (with pkgs; [
    aircrack-ng
    AngryOxide
    bettercap
    chisel
    gpsd
    (hashcat.override {
      cudaSupport = true;
    })
    hcxdumptool
    hcxtools
    unstable.kismet
    masscan
    proxychains
    reaverwps-t6x
    rustscan
    socat
    termshark
  ]);
}
