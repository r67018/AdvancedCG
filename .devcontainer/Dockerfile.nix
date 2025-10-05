# Nix-based Docker image for Advanced CG Development
# Using Ubuntu 22.04 as base for better VS Code Server compatibility
FROM ubuntu:22.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install basic tools and dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    xz-utils \
    ca-certificates \
    sudo \
    bash \
    coreutils \
    && rm -rf /var/lib/apt/lists/*

# Install Nix package manager
RUN curl -L https://nixos.org/nix/install | sh -s -- --daemon

# Set up Nix environment variables
ENV PATH="/nix/var/nix/profiles/default/bin:${PATH}"
ENV NIX_PATH="/nix/var/nix/profiles/per-user/root/channels"

# Enable flakes and nix-command
RUN mkdir -p /etc/nix && \
    echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf

# Set working directory
WORKDIR /workspace

# Set environment variables
ENV DISPLAY=:99

# Entry point
CMD ["/bin/bash"]
