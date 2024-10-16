{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = true;
    defaultKeymap = "viins";
    shellAliases = {
      lsc = "lsd --classic"; # For annoying colors on SMB/NFS mounts
      wl-copy = "pbcopy"; # I use Wayland too much to remember the pb clip cmds
      wl-paste = "pbpaste";
      cd = "z";
    };
    sessionVariables = {
      EDITOR = "nvim";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "docker"
        "docker-compose"
        "colored-man-pages"
        "git"
        "ssh-agent"
      ];
      theme = "robbyrussell";
      extraConfig =
        #Import ssh key TODO: make less imperative
        ''
          zstyle :omz:plugins:ssh-agent identities pete3n
        '';
    };
    initExtraFirst =
      #bash
      ''
        # Ignore unsafe directory warnings from Darwin
        ZSH_DISABLE_COMPFIX="true"
      '';
    profileExtra =
      # bash
      ''
        # Show fastfetch at login but not for every new TMUX pain/window
        if [ -z "$FASTFETCH_EXECUTED" ] && [ -z "$TMUX" ]; then
        	export FASTFETCH_EXECUTED=1
        	command -v ${pkgs.fastfetch}/bin/fastfetch &> /dev/null &&
        	${pkgs.fastfetch}/bin/fastfetch
        fi
      '';
  };
}
