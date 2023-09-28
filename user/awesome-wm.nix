{ config, pkgs, ... }:

let
  # Script to copy Awesome WM config
  sourcePath="/etc/nixos/user/";
  copyAwesomeConfig = pkgs.writeShellScriptBin "copy_awesome_config" ''
    if [ ! -d "/home/${config.userOptions.username}/.config/awesome" ]; then
      echo "Creating ~/.config/awesome directory..."
      mkdir -p "/home/${config.userOptions.username}/.config/awesome"
    fi
    echo "Copying config files..."

    # Copy but don't overwrite Awesome config files
    cp -rnv ${sourcePath}${config.userOptions.username}-home/awesome/* /home/${config.userOptions.username}/.config/awesome/
    chown -R ${config.userOptions.username}:users /home/${config.userOptions.username}/.config/awesome
  '';

in {
  systemd.services.copy-awesome-config = {
    description = "Copy Awesome WM Configuration";
    after = [ "local-fs.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${copyAwesomeConfig}/bin/copy_awesome_config";
      StandardOutput = "journal+console";
      StandardError = "journal+console";
    };
    unitConfig = {
      ConditionPathExists = "!/var/lib/copy-${config.userOptions.username}-awesome-done";
    };
    postStart = ''touch /var/lib/copy-${config.userOptions.username}-awesome-done'';
  };
}
