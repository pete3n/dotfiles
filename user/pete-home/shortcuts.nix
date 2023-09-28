{ config, lib, pkgs, ... }:
let
  paVolume = pkgs.writeTextFile {
    name = "volume.desktop";
    destination = "/share/applications/volume.desktop";
    text = ''
      [Desktop Entry]
      Name=Pulse Volume Control
      GenericName=Volume Controller
      Comment=Launch Pavucontrol
      Exec=${pkgs.pavucontrol}/bin/pavucontrol
      Icon=pavucontrol
      Terminal=false
      StartupNotify=false
      Categories=AudioVideo
    '';
  };

in {
  home.packages = [ 
    paVolume 
  ];
}
