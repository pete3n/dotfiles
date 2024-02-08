# Special config for Intel graphics and the integrated descrete RTX 3050
{
  config,
  lib,
  pkgs,
  ...
}: {
  XPS-9510_igpu.configuration = {
    system.nixos.tags = ["Intel-UHD" "RTX_3050"];

    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.production;
      modesetting.enable = true;
      powerManagement.enable = true;
      open = true;
      nvidiaSettings = true;

      prime = {
        offload.enable = true;
        nvidiaBusId = "PCI:1:0:0";
        intelBusId = "PCI:0:2:0";
      };
    };

    # Enable OpenGL
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [nvidia-vaapi-driver intel-media-driver];
      extraPackages32 = with pkgs.pkgsi686Linux; [nvidia-vaapi-driver intel-media-driver];
    };

    # I don't fully understand why we need xserver
    # I assume because of X-Wayland
    services.xserver.videoDrivers = ["modesetting" "nvidia"];
  };
}
