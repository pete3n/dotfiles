# Special config for external Aorus RTX 3080 GPU
# Uses X11 and the Awesome windo manager
{ config, lib, pkgs, ... }:

{
  XPS-9510_egpu.configuration = {
    system.nixos.tags = [ "Aorus-eGPU" "RTX-3080" "X11" "Awesome-WM"];

    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.production;
      modesetting.enable = false;
      powerManagement.enable = false;
      open = true;
      nvidiaSettings = true;

      prime = {
        offload = {
	  enable = true;
	  enableOffloadCmd = true;
        };
        allowExternalGpu = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:63:0:0";
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
      videoDrivers = ["nvidia"];
      
      config = pkgs.lib.mkOverride 0 ''
        
	Section "Module"
	  Load		"modesetting"
	EndSection

	Section "Device"
	    Identifier     "eGPU-RTX3080"
	    Driver         "nvidia"
	    VendorName     "NVIDIA Corporation"
	    BoardName      "NVIDIA GeForce RTX 3080"
	    BusID          "PCI:63:0:0"
	    Option	   "AllowExternalGpus" "True"
	    Option	   "AllowEmptyInitialConfiguration"
	EndSection
      '';

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
