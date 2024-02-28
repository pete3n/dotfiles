{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    acpi
    auto-cpufreq
    binwalk
    cryptsetup
    dhcpcd
    dig
    docker-compose
    entr
    eza
    fd
    fzf
    git
    gparted
    home-manager
    iw
    jq
    killall
    lazydocker
    libnotify
    ncdu
    nix-tree
    nmap
    openvpn
    parted
    pavucontrol
    pciutils
    pipewire
    qemu
    qemu-utils
    ripgrep
    tcpdump
    thermald
    tldr
    tmux
    traceroute
    tshark
    unzip
    usbutils
    vim
    wireshark
    wpa_supplicant
    yazi
    zip
  ];
}
