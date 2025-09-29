#!/usr/bin/env bash
set -euo pipefail

echo "🛑 Stopping Docker containers..."

# Stop all containers
docker-compose down

# Optional: Remove volumes (uncomment if you want to reset data)
# echo "🗑️ Removing volumes..."
# docker-compose down -v

# Optional: Remove images (uncomment if you want to remove built images)
# echo "🗑️ Removing images..."
# docker-compose down --rmi all

echo "✅ Docker containers stopped successfully!"
echo ""
echo "To start again: bash scripts/docker-setup.sh"