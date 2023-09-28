# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, lib, ... }:

{
  imports = [ 
      ./userOptions.nix
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
        # Placeholder for specific hardware imports
	./hardware/hw_xps9510.nix 
	# Placeholder for system-wide software imports
	
 ./software/sw_dod_cac.nix
 ./software/sw_flatpaks.nix
	# Placeholder for user configuration imports
	
  ./user/user-pete.nix
    ];

  nix = {
   # Local cache servers
    settings.trusted-substituters = [
      "http://nix-cache.local:80" # nginx transparent proxy
    ];

    settings.substituters = [
      "http://nix-cache.local:80" 
    ];

    # Enable Flakes Support
    settings.experimental-features = [ "nix-command" "flakes" ];

    # Configure Carbage Collection
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 31d";
    };

    # Extra options to keep build dependencies and derivatives for offline builds.
    # This is less aggressive than the system.includeBuildDependencies = true option
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # Include all dependencies for buildling.
  # WARNING: This drastically increases the size of the install
  # system.includeBuildDependencies = true;

  #### FILESYSTEM CONFIG ####
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/42fb402e-13b5-45ba-85c8-260deb67e957";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/203B-3759";
      fsType = "vfat";
    };

    "/var" = {
      device = "/dev/disk/by-uuid/0aca9b33-f2da-4414-94d4-b433778743cd";
      fsType = "ext4";
    };

    "/home" = {
      device = "/dev/disk/by-uuid/152d5d5b-2770-43ba-8f11-13f9afb8911f";
      fsType = "ext4";
    };
  };

  #### NETWORK CONFIG ####
  # Use traditional interface names like wlan0
  boot.kernelParams = [ "net.ifnames=0" ];

  networking = {
    hostName = "nixos";
    useDHCP = false; # Disable automatic DHCP
    nameservers = [ "172.16.2.1" "208.67.222.222" "208.67.220.220" "1.1.1.1" ]; # pfSense LAN, then use OpenDNS, then CF
  
    # Disable all wireless by default (use wpa_supplicant manually)
    wireless.enable = false;   
    networkmanager.enable = false; 
    
    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  
    # Use iptables instead of nftables, this is required for Docker
    nftables.enable = false; 

    # We will manually configure all rules for iptables below
    # Overwrite the NixOS iptables configuration
    firewall.enable = false;
    
  };
  
  services.resolved = {
    enable = true;
    dnssec = "false";
    domains = [ "~."  ];
    extraConfig = ''
      DNSOverTLS=true
    '';
  };

  #### Sound Config ####
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  #### Fonts and Locale ####
  # Set your time zone.
  time.timeZone = "America/New_York";
  # Font installation
  fonts.packages = with pkgs; [
    nerdfonts
  ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    packages = with pkgs; [ terminus_font ];

    keyMap = "us";
  };

  #### SERVICES CONFIGURATIONS ####
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable Thunderbolt 
  services.hardware.bolt.enable = true;

  # Enable thermal daemon
  services.thermald.enable = lib.mkDefault true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

   # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
 
  # Enable Docker
  virtualisation.docker.enable = true;

  # System wide packages 
  environment.systemPackages = with pkgs; [
   
    # System utils
    iptables
    pciutils
    usbutils
    iw
    wpa_supplicant
    dhcpcd 
    dig
    openvpn
    killall
    acpi
    tldr

    # Terminal
    alacritty
    tmux
    vim
    powershell
    xclip
  
    # Windows System
    awesome # Window manager
    picom # Compositor
    feh # Wallpaper viewer
    xorg.xinit # X init system
    arandr # Graphical frontend for xrandr dispaly layouts
    vulkan-tools # Vulkan graphics tools
    pavucontrol # Pulse audio volume control menu

    # Development
    gcc
    gnumake
    gdb
    cargo
    go
    git

    # Media
    gimp-with-plugins
    vlc
    youtube-dl
    yt-dlp
    shotcut
    handbrake
    ffmpeg
    rhythmbox

    # Virtualization
    qemu
    docker-compose

    # Disk utils
    parted
    gparted

    # File archives
    zip
    unzip

    # Work Related
    nmap
    tcpdump
    aircrack-ng
    hcxtools
    kismet
    wireshark
    tshark
  ];

  # Fix to link /bin/bash to the system bash location
  system.activationScripts.linkBash = {
    text = ''
      ln -sf /run/current-system/sw/bin/bash /bin/bash
    '';
  };
 
  # Manually configure iptables rules
  systemd.services.iptables-rules = {
    description = "Custom iptables rules";
    wantedBy = [ "multi-user.target" ];
    script = let
      iptables = "${pkgs.iptables}/bin/iptables";
    in ''
      # Flush existing rules
      ${iptables} -F
     
      # Delete nixos-fw chains
      for chain in $({iptables} -L -n | grep 'Chain nixos-fw' awk '{print $2}'); do
        ${iptables} -F $chain
        ${iptables} -X $chain
      done

      # Set default policies
      ${iptables} -P INPUT DROP
      ${iptables} -P FORWARD ACCEPT
      ${iptables} -P OUTPUT ACCEPT

      # Rules
      ${iptables} -I INPUT -i lo -j ACCEPT
      ${iptables} -I INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
      ${iptables} -A INPUT -j DROP
    '';
  };
}
