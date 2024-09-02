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
    file
    fzf
    git
    gparted
    home-manager
    iw
    jq
    keychain
    killall
    lazydocker
    libnotify
    lsd
    ncdu
    nix-tree
    nmap
    openvpn
    parted
    pavucontrol
    pciutils
    pipewire
    procs
    qemu
    qemu-utils
    ripgrep
    sd
    sshs
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
    zoxide
    zip
  ];
}
