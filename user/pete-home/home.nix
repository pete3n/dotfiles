{ config, lib, pkgs, ... }:

let
  nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
    inherit pkgs;
  };
  yamlFormat = pkgs.formats.yaml { };
  alacrittyConfig = import ./alacritty.nix { inherit config lib pkgs; };

in {
  imports = [ 
    ./scripts.nix # Shortcuts may depend on this so make sure it is imported first
    ./shortcuts.nix
  ];
  
  home.username = "pete";
  home.homeDirectory = "/home/pete";
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    # Terminal tools
    neovim
    htop
    neofetch
    python311Packages.base58
    # Encryption tools
    gnupg
    pinentry-curses
    cryptomator
    yubioath-flutter
    # Messaging
    signal-desktop
    element-desktop
    # Crypto
    bisq-desktop
    monero-gui
    # Cloud tools
    nextcloud-client
    # Dev dependencies
    nodejs_20
    openssl
    # Media
    ytmdl
  ];

  home.sessionVariables = {
    # These variables must be set as a Rust dependency for Cargo
    OPENSSL_DIR = "${pkgs.openssl.dev}";
    OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
  };

  programs.bash = {
    enable = true;

    # Start tmux with vty and configure GPG for SSH auth for Git
    initExtra = ''
      if [ "$TERM" != "linux" ] && command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
        tmux attach -t default || tmux new -s default
      fi

      # GPG SSH Auth
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket) 
    '';
  };

  # Show neofetch for login
  home.sessionVariablesExtra = ''
    if command -v neofetch &> /dev/null; then
      neofetch
    fi
  '';

  programs.neovim = {
    defaultEditor = true;
  };

  # Xinit settings
  home.file.".xinitrc".text = ''
    # Add our .desktop file directory to the XDG path
    export XDG_DATA_DIRS="''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}:$HOME/.local/state/nix/profiles/profile/share/applications"

        # Start Window Manager
    exec awesome
  '';

  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty;
    settings = alacrittyConfig;
  };

  xdg.configFile."alacritty/alacritty.yml".source =
    yamlFormat.generate "alacritty.yml" alacrittyConfig;
 
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    plugins = with pkgs; [
      rofi-calc
    ];
    theme = "rofi_theme";
  };
  home.file.".local/share/rofi/themes/rofi_theme.rasi".source = ./rofi_theme.rasi;

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    profiles = {
      "pete" = {
        id = 0;
        settings = {
          "browser.startup.homepage" = "https://www.duckduckgo.com";
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        };
      };
    };
  };
}
