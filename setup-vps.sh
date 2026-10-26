#!/usr/bin/env bash
# Deploys (or updates) the ADD website on an Ubuntu/Debian VPS with nginx.
# Usage:  sudo bash deploy/setup-vps.sh your-domain.com [--https]
# Run it from inside the cloned repository. Re-run it any time to update.
set -euo pipefail

DOMAIN="${1:?Usage: sudo bash deploy/setup-vps.sh your-domain.com [--https]}"
WEBROOT=/var/www/add-guild
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "==> Installing nginx and Node.js 20"
apt-get update -y
apt-get install -y nginx curl git
if ! command -v node >/dev/null || [ "$(node -v | cut -d. -f1 | tr -d v)" -lt 18 ]; then
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
  apt-get install -y nodejs
fi

echo "==> Pulling latest code and building"
cd "$REPO_DIR"
git pull --ff-only || true
npm install
npm run build

echo "==> Publishing to $WEBROOT"
mkdir -p "$WEBROOT"
rsync -a --delete dist/ "$WEBROOT"/ 2>/dev/null || { rm -rf "$WEBROOT"/*; cp -r dist/* "$WEBROOT"/; }

echo "==> Configuring nginx for $DOMAIN"
sed "s/DOMAIN_PLACEHOLDER/$DOMAIN/" deploy/nginx.conf > /etc/nginx/sites-available/add-guild
ln -sf /etc/nginx/sites-available/add-guild /etc/nginx/sites-enabled/add-guild
rm -f /etc/nginx/sites-enabled/default
nginx -t
systemctl reload nginx

if [ "${2:-}" = "--https" ]; then
  echo "==> Getting a free HTTPS certificate"
  apt-get install -y certbot python3-certbot-nginx
  certbot --nginx -d "$DOMAIN" --non-interactive --agree-tos --register-unsafely-without-email --redirect
fi

echo "Done. Visit http://$DOMAIN (or https:// if you used --https)"
