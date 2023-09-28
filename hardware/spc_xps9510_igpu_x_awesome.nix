# Special config for Intel graphics and the integrated descrete RTX 3050
# Uses X11 and the Awesome window manager
{ config, lib, pkgs, ... }:

{
  XPS-9510_igpu.configuration = {
    system.nixos.tags = [ "Intel-UHD" "RTX_3050" "X11" "Awesome-WM"];

    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.production;
      modesetting.enable = true;
      powerManagement.enable = true;
      open = true;
      nvidiaSettings = true;

      prime = {
        sync = {
	  enable = true;
        };
        nvidiaBusId = "PCI:1:0:0";
        intelBusId = "PCI:0:2:0";
      };
    };

    # Enable OpenGL
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    # X server config
    services.xserver = {
      enable = true;
      layout = "us";
      videoDrivers = ["modesetting" "nvidia"];

      displayManager = {
	startx.enable = true;
      };

      windowManager.awesome = {
	enable = true;
	luaModules = with pkgs.luaPackages; [
	  luarocks
	  luadbi-mysql
	];
      };
    };
  };
}
