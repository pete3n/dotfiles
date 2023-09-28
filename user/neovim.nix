{ config, pkgs, ... }:
let
  # Script to copy NeoVIM config files
  sourcePath = "/etc/nixos/user/";
  copyNvimConfig = pkgs.writeShellScriptBin "copy_nvim_config" ''
    if [ ! -d "/home/${config.userOptions.username}/.config/nvim" ]; then
      echo "Creating /home/${config.userOptions.username}/.config/nvim directory..."
      mkdir -p "/home/${config.userOptions.username}/.config/nvim"
    fi
    echo "Copying config files..."
    # Copy NeoVim config files. Don't overwrite.
    cp -rnv ${sourcePath}${config.userOptions.username}-home/nvim/* /home/${config.userOptions.username}/.config/nvim/
    chown -R ${config.userOptions.username}:users /home/${config.userOptions.username}/.config/nvim
  '';

in {
  systemd.services.copy-nvim-config = {
    description = "Copy NeoVim Configuration";
    after = [ "local-fs.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${copyNvimConfig}/bin/copy_nvim_config";
      StandardOutput = "journal+console";
      StandardError = "journal+console";
    };
    unitConfig = {
      ConditionPathExists = "!/var/lib/copy-${config.userOptions.username}-nvim-done";
    };
    postStart = ''touch /var/lib/copy-${config.userOptions.username}-nvim-done'';
  };
}
