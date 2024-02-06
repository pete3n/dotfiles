# User specific config
{ config, lib, pkgs, ... }:

let
  # Set the username here to configure all relative configs
  username = "pete";

  templatePath = ./${username}-home/home.nix;
  homeConfigPath = ./${username}-home;

  allHomeFiles = builtins.attrNames (builtins.readDir homeConfigPath);
  homeNixFiles = builtins.filter (
    file: (builtins.match ".*\\.nix" file != null) ||
      (builtins.match ".*\\.rasi" file != null)
  ) allHomeFiles;

  # Configuration script and service to create an initial home-manager config
  homeManagerDir = "/home/${username}/.config/home-manager";  
  homeManagerScript = pkgs.writeShellScriptBin "setup-${username}-home-manager" ''
    if [ ! -d "${homeManagerDir}" ]; then
      mkdir -p "${homeManagerDir}"
    fi
    
    # Copy user's home-manager .nix files, but don't overwrite
    for file in ${builtins.concatStringsSep " " homeNixFiles}; do
      dest="${homeManagerDir}/$file"
      src="${homeConfigPath}/$file"
        if [ ! -f "$dest" ]; then
	  cp "$src" "$dest"
	fi
      done

    chmod -R u+w ${homeManagerDir}
    ${pkgs.home-manager}/bin/home-manager switch
  '';

  # Define the systemd service to configure home-manager
  setupHomeManager = "setup-${username}-home-manager";
  homeManagerService = {
    description = "Set up Home Manager for ${username}";
    after = [ "home-manager-${username}.service" ];
    requires = [ "home-manager-${username}.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = "${username}";
      Group = "users";
      ExecStart = "${homeManagerScript}/bin/setup-${username}-home-manager";
      StandardOutput = "journal+console";
      StandardError = "journal+console";
      Environment = [
	"USER=${username}"
	"HOME=/home/${username}"
        "PATH=${pkgs.nix}/bin:${pkgs.coreutils}/bin:${pkgs.bash}/bin"
        "NIX_PATH=nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos/nixpkgs"
      ];
    };
    unitConfig = {
      ConditionPathExists = "!/home/${username}/.config/home-manager/init-hm-done";
    };
    postStart = ''echo "WARNING: Removing this file will allow nixos-rebuild to overwrite your home-manager config" > /home/${username}/.config/home-manager/init-hm-done'';
  };

  # Import the Nix User Repository
  nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
    inherit pkgs;
  };

  # This is a workaround until the upstream alacritty.nix is fixed to output YAML
  yamlFormat = pkgs.formats.yaml { };
  alacrittyConfig = import ./${username}-home/alacritty.nix { inherit config lib pkgs; };

in {
  userOptions.username = username;
  # Import special configurations that can't be configured with Home Manager
  imports = [
    ./awesome-wm.nix 
    ./neovim.nix 
    ./wallpapers.nix 
  ];

  # Instantiate the home-manager configuration service
  systemd.services = {
    ${setupHomeManager} = homeManagerService;
  };



  # Webdav service needed to mount Cryptomator volumes
  services.davfs2.enable = true;

  # Gnome gvfs service for Nautilus
  services.gvfs.enable = true;

  # Packages for the user that must be installed system wide
  environment.systemPackages = with pkgs; [
   bisq-desktop
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’
  users.users.${username} = {
     isNormalUser = true;
     extraGroups = [ "wheel" "davfs2" ]; # Enable ‘sudo’ for the user, and allow dav2fs mounting

     # User packages
     packages = with pkgs; [
       home-manager 
       drawio
     ];
  };
}
