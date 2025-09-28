#!/usr/bin/env bash
set -euo pipefail

sudo apt update
sudo apt install -y build-essential python3 make g++ pkg-config

# Image & canvas libs (safe to install; no-op if unused)
sudo apt install -y libvips-dev libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev || true

# Reliable file watching
if ! grep -q "fs.inotify.max_user_watches" /etc/sysctl.conf; then
  echo "fs.inotify.max_user_watches=524288" | sudo tee -a /etc/sysctl.conf
fi
if ! grep -q "fs.inotify.max_user_instances" /etc/sysctl.conf; then
  echo "fs.inotify.max_user_instances=1024" | sudo tee -a /etc/sysctl.conf
fi
sudo sysctl -p || true

echo "Bootstrap complete."
