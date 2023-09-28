#! /bin/sh
nix-instantiate '<nixpkgs/nixos>' -A system --arg configuration ./configuration.nix
