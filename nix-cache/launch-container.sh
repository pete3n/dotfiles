#!/bin/sh
docker build -t nix-cache:latest .
docker run -d \
    -v /mnt/user/nix-cache:/var/nix/cache \
    -v /mnt/user/nix/store:/nix/store \
    --restart=unless-stopped \
    --name=nix_nginx_proxy \
    -p 5000:5000 \
    -p 80:80 \
    nix-cache:latest
