
#!/usr/bin/env bash

set -euo pipefail

# Ensure the script runs as root
if [[ "$EUID" -ne 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo bash setup-docker.sh"
    exit 1
fi

echo "Updating Ubuntu packages..."

apt-get update

echo "Installing prerequisites..."

apt-get install -y ca-certificates curl

# Create Docker keyring directory
install -m 0755 -d /etc/apt/keyrings

# Download Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    -o /etc/apt/keyrings/docker.asc

chmod a+r /etc/apt/keyrings/docker.asc

# Configure Docker's official repository
echo "Adding Docker repository..."

cat > /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# Update package index
apt-get update

# Install Docker Engine and plugins
echo "Installing Docker..."

apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# Enable Docker on system startup
systemctl enable docker
systemctl start docker

echo "=================================="
echo "Docker installation completed!"
echo "=================================="

docker --version
docker compose version

echo "Docker service status:"
systemctl is-active docker
