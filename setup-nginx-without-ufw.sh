
#!/usr/bin/env bash

set -euo pipefail

# Ensure the script runs as root
if [[ "$EUID" -ne 0 ]]; then
    echo "Please run with sudo:"
    echo "sudo bash setup-nginx.sh"
    exit 1
fi

echo "Updating Ubuntu packages..."
apt-get update

echo "Installing Nginx..."
apt-get install -y nginx

echo "Enabling Nginx on system startup..."
systemctl enable nginx

echo "Starting Nginx..."
systemctl start nginx

echo "Testing Nginx configuration..."
nginx -t

echo "Reloading Nginx..."
systemctl reload nginx

echo "=================================="
echo "Nginx installation completed!"
echo "=================================="

echo "Nginx version:"
nginx -v

echo "Nginx service status:"
systemctl is-active nginx
