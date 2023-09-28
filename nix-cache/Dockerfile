FROM ubuntu:22.04

# Install required packages and Nix
RUN apt update && apt install -y curl xz-utils nginx

# Create nixbld group and user
RUN groupadd -r nixbld && \
    for i in $(seq 1 10); do useradd -r -g nixbld -G nixbld -d /var/empty -s /usr/sbin/nologin "nixbld$i"; done

# Create the /nix directory
RUN mkdir -m 0755 /nix && chown root /nix

# Install Nix in two steps to avoid the tar and xz issue
RUN curl -LO https://releases.nixos.org/nix/nix-2.9.2/nix-2.9.2-x86_64-linux.tar.xz && \
    unxz nix-2.9.2-x86_64-linux.tar.xz && \
    tar xf nix-2.9.2-x86_64-linux.tar -C / && \
    USER=root sh /nix-2.9.2-x86_64-linux/install

# Source Nix Profile
ENV PATH="/root/.nix-profile/bin:$PATH"

# Install nix-serve
RUN nix-env -iA nixpkgs.nix-serve

# COPY nginx.conf
COPY nginx.conf /etc/nginx/sites-available/default

# Expose the default port for nix-serve
EXPOSE 5000 80

# Command to run nix-serve and nginx proxy
CMD ["sh", "-c", "nix-serve --listen 0.0.0.0:5000 --cache /nix/store & nginx -g 'daemon off;'"]
