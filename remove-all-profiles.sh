#! /bin/sh
cd /nix/var/nix/profiles/system-profiles/

for profile in *; do
    echo "Removing profile: $profile"
    sudo rm -r "$profile"
    sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system-profiles/"$profile"
done

sudo nix-collect-garbage -d
sudo nixos-rebuild switch
#
