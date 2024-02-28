{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Nix User Repository, Firefox-Addons
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    nixvim.url = "github:pete3n/nixvim-flake";
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = {
    deploy-rs,
    firefox-addons,
    home-manager,
    nixpkgs,
    nixpkgs-unstable,
    nixvim,
    self,
    ...
  } @ inputs: let
    inherit (self) outputs;

    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in rec {
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (
      system:
        import ./pkgs {
          inherit system;
          pkgs = nixpkgs.legacyPackages.${system};
          config = {
            allowUnfree = true;
          };
        }
    );

    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};

    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    # These are for system-wide configuration
    nixosModules = import ./modules/nixos;

    # User defintions for the system (careful these create/overwrite users)
    systemUsers = import ./users;

    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    # These are for users level configuration
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#system-tag'
    nixosConfigurations = {
      eco-getac = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/getac/configuration.nix
          nixosModules.console
          nixosModules.getac-modules.specialisations
          nixosModules.iptables-default
          nixosModules.system-tools
          nixosModules.X11-tools
          systemUsers.eco
        ];
      };

      pete-xps = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/xps/configuration.nix
          nixosModules.console
          nixosModules.xps-modules.specialisations
          nixosModules.iptables-default
          nixosModules.nvidia-scripts
          nixosModules.gaming
          nixosModules.system-tools
          nixosModules.X11-tools
          nixosModules.yubi-smartcard
          systemUsers.pete
        ];
      };
      junior-argon = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/xps-sc2/configuration.nix
          nixosModules.console
          nixosModules.xps-modules.specialisations
          nixosModules.iptables-default
          nixosModules.system-tools
          nixosModules.X11-tools
          systemUsers.junior
        ];
      };
    };

    eco-getac-system = nixosConfigurations.eco-getac.config.system.build.toplevel;
    pete-xps-system = nixosConfigurations.pete-xps.config.system.build.toplevel;
    junior-argon-system = nixosConfigurations.junior-argon.config.system.build.toplevel;

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "eco@nix-tac" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/home.nix
          homeManagerModules.eco-modules.alacritty-config
          homeManagerModules.eco-modules.awesome-config
          homeManagerModules.eco-modules.hyprland-config
          homeManagerModules.eco-modules.neovim-env
          homeManagerModules.eco-modules.pen-tools
          homeManagerModules.eco-modules.tmux-config
          homeManagerModules.eco-modules.user-config
        ];
      };

      "pete@nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        lib = nixpkgs.lib;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/home.nix
          homeManagerModules.pete-modules.alacritty-config
          homeManagerModules.pete-modules.awesome-config
          homeManagerModules.pete-modules.user-config
          homeManagerModules.pete-modules.crypto
          homeManagerModules.pete-modules.firefox-config
          homeManagerModules.pete-modules.hyprland-config
          homeManagerModules.pete-modules.media-tools
          homeManagerModules.pete-modules.messengers
          homeManagerModules.pete-modules.misc-tools
          homeManagerModules.pete-modules.pen-tools
          homeManagerModules.pete-modules.neovim-env
          homeManagerModules.pete-modules.office-cloud
          homeManagerModules.pete-modules.tmux-config
        ];
      };

      "junior@argon" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        lib = nixpkgs.lib;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/home.nix
          homeManagerModules.junior-modules.awesome-config
          homeManagerModules.junior-modules.alacritty-config
          homeManagerModules.junior-modules.user-config
          homeManagerModules.junior-modules.hyprland-config
          homeManagerModules.junior-modules.media-tools
          homeManagerModules.junior-modules.misc-tools
          homeManagerModules.junior-modules.pen-tools
          homeManagerModules.junior-modules.neovim-env
          homeManagerModules.junior-modules.tmux-config
        ];
      };
    };
    eco-nix-tac-home = homeConfigurations."eco@nix-tac".activationPackage;
    pete-nixos-home = homeConfigurations."pete@nixos".activationPackage;
    junior-argon-home = homeConfigurations."junior@argon".activationPackage;

    deploy.nodes = {
      eco-getac = {
        hostname = "nix-tac";
        profiles = {
          system = {
            sshUser = "eco";
            user = "root";
            autoRollback = true;
            magicRollback = true;
            remoteBuild = false;
            path = deploy-rs.lib.x86_64-linux.activate.nixos nixosConfigurations.eco-getac;
            # Using x86_64 to allow pushing configs without NixOS and binfmt support
          };
          home = {
            sshUser = "eco";
            user = "eco";
            autoRollback = false;
            magicRollback = false;
            remoteBuild = false;
            path = deploy-rs.lib.x86_64-linux.activate.custom homeConfigurations."eco@nix-tac".activationPackage "./activate";
          };
        };
      };
    };
  };
}
