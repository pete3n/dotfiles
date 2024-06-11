# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usb_storage" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/77d76011-5fc6-446d-957f-490371e1a6fd";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-a3395856-595a-4b96-ae2a-21c9e7fc176a".device = "/dev/disk/by-uuid/a3395856-595a-4b96-ae2a-21c9e7fc176a";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/618C-9C6B";
    fsType = "vfat";
  };

  #  swapDevices = [
  #    {device = "/dev/disk/by-uuid/cd68e956-623e-453c-97a9-44c8bcab01b6";}
  #  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
