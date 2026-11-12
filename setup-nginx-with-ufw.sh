
#!/usr/bin/env bash

set -euo pipefail

# Ensure the script runs as root
if [[ "$EUID" -ne 0 ]]; then
    echo "Please run with sudo:"
    echo "sudo bash setup-nginx.sh"
    exit 1
fi

echo "Updating Ubuntu packages..."
apt update

echo "Installing Nginx..."
apt install -y nginx

echo "Enabling Nginx..."
systemctl enable nginx
systemctl start nginx

# Configure Ubuntu firewall
echo "Configuring UFW..."

# Allow SSH first to avoid locking yourself out
ufw allow OpenSSH

# Allow HTTP and HTTPS
ufw allow 'Nginx Full'

# Enable firewall
ufw --force enable

echo "Testing Nginx configuration..."
nginx -t

echo "Reloading Nginx..."
systemctl reload nginx

echo "=================================="
echo "Nginx installation completed!"
echo "=================================="

systemctl status nginx --no-pager
ufw status
