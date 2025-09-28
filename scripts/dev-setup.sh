#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Running Rehome development setup..."

# Run bootstrap if it exists
if [ -f "scripts/bootstrap-linux.sh" ]; then
    echo "📦 Running bootstrap-linux.sh..."
    bash scripts/bootstrap-linux.sh
fi

# Install frontend dependencies
echo "📦 Installing frontend dependencies..."
cd frontend
pnpm install
cd ..

# Install backend dependencies
echo "📦 Installing backend dependencies..."
cd backend
composer install --no-interaction --prefer-dist
cd ..

# Copy environment files if they don't exist
if [ ! -f "backend/.env" ] && [ -f "backend/.env.example" ]; then
    echo "📄 Copying .env.example to .env..."
    cp backend/.env.example backend/.env
fi

# Generate Laravel key if needed
echo "🔑 Setting up Laravel application key..."
cd backend
php artisan key:generate --ansi
cd ..

echo "✅ Development setup complete!"
echo ""
echo "Next steps:"
echo "  1. Configure your .env file in backend/"
echo "  2. Run: bash scripts/dev-start.sh --storybook"
echo ""