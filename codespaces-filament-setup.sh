#!/bin/bash
# Codespaces quick-start for Filament admin (styled)
set -euo pipefail

# 1) Detect URLs
: "${CODESPACE_NAME:?Run inside a GitHub Codespace so CODESPACE_NAME is set}"
BACKEND_URL="https://${CODESPACE_NAME}-8000.app.github.dev"
FRONTEND_URL="https://${CODESPACE_NAME}-3000.app.github.dev"

# 2) Stop any server, clear caches, ensure assets
cd /workspaces/rehome/backend
pkill -f "php artisan serve" || true
php artisan optimize:clear
php artisan filament:assets

# 3) Start Laravel with proxy/cookie aware env (background)
APP_URL="$BACKEND_URL" \
ASSET_URL="$BACKEND_URL" \
SESSION_DRIVER=database \
SESSION_SECURE_COOKIE=true \
TRUSTED_PROXIES="*" \
SANCTUM_STATEFUL_DOMAINS="${CODESPACE_NAME}-8000.app.github.dev,${CODESPACE_NAME}-3000.app.github.dev,localhost,127.0.0.1" \
php artisan serve --host=0.0.0.0 --port=8000 >/dev/null 2>&1 &

# 4) Make port 8000 Public (best-effort via gh CLI)
if command -v gh >/dev/null 2>&1; then
  gh codespace ports visibility 8000:public -c "$CODESPACE_NAME" >/dev/null 2>&1 || true
fi

# 5) Quick checks
sleep 2
echo "== Checking asset endpoints =="
curl -s -o /dev/null -w "CSS %{http_code}\n"  "$BACKEND_URL/css/filament/filament/app.css"
curl -s -o /dev/null -w "JS  %{http_code}\n"  "$BACKEND_URL/js/filament/filament/app.js"

echo
echo "✅ Admin URL:   $BACKEND_URL/admin"
echo "ℹ️ If assets show 401/502, open the Ports panel and set port 8000 -> Public, then hard-refresh (Ctrl/Cmd+Shift+R)."