# System wide Flatpak base config
{ config, lib, pkgs, ... }:

let
  flathubURL = "https://flathub.org/repo/flathub.flatpakrepo";

  flatpakSetup = pkgs.writeShellScriptBin "setupFlatpaks" ''
  ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub ${flathubURL}
    ${pkgs.flatpak}/bin/flatpak install -y flathub com.valvesoftware.Steam
    ${pkgs.flatpak}/bin/flatpak install -y flathub com.heroicgameslauncher.hgl
    ${pkgs.flatpak}/bin/flatpak install -y flathub com.usebottles.bottles
    ${pkgs.flatpak}/bin/flatpak install -y flathub com.skype.Client

    ${pkgs.flatpak}/bin/flatpak install -y flathub org.onlyoffice.desktopeditors
  '';

in {
  # Enable Flatpak, configure flathub repo, and install base Flatpaks
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk ];
  systemd.services.setup-flatpaks = {
    description = "Setup system flatpaks";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${flatpakSetup}/bin/setupFlatpaks";
      StandardOutput = "journal+console";
      StandardError = "journal+console";
    };
    unitConfig = {
      ConditionPathExists = "!/var/lib/init-flatpaks-done";
    };
    postStart = ''touch /var/lib/init-flatpaks-done'';
  };
}
