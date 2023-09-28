{ config, pkgs, ... }:

let
  wallpaperArchive = pkgs.copyPathToStore "/etc/nixos/user/${config.userOptions.username}-home/wallpapers.tar.gz";

  # Script to copy wallpapers
  copyWallpapers = pkgs.writeShellScriptBin "copy_wallpapers" ''
    export PATH=${pkgs.gzip}/bin:$PATH
    if [ ! -d "/usr/share/wallpapers" ]; then
      echo "Create wallpaper directory..."
      mkdir -p "/usr/share"
    fi
    echo "Decompressing archive..."
    ${pkgs.gnutar}/bin/tar xzvf ${wallpaperArchive} -C /usr/share/
  '';

in {
  systemd.services.copy-wallpapers = {
    description = "Copy user wallpapers";
    after = [ "local-fs.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${copyWallpapers}/bin/copy_wallpapers";
      StandardOutput = "journal+console";
      StandardError = "journal+console";
    };
    unitConfig = {
      ConditionPathExists = "!/var/lib/copy-${config.userOptions.username}-wallpapers-done";
    };
    postStart = ''touch /var/lib/copy-${config.userOptions.username}-wallpapers-done'';
  };
}
