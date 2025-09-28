#!/bin/bash
# Development startup script for WSL2
# Run this from the Ubuntu terminal in VS Code

set -e

echo "🚀 Starting Rehome Development Environment"
echo "=========================================="

# Check if we're in WSL
if [[ ! -f /proc/version ]] || ! grep -q Microsoft /proc/version 2>/dev/null; then
    echo "⚠️  Warning: This script should be run in WSL2 Ubuntu terminal"
    echo "   Make sure VS Code shows 'WSL: Ubuntu' in the bottom-left corner"
    read -p "Continue anyway? (y/N): " -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo ""
echo "📋 Environment Check:"
echo "===================="
echo "Node.js: $(node --version 2>/dev/null || echo 'Not installed')"
echo "pnpm: $(pnpm --version 2>/dev/null || echo 'Not installed')"
echo "PHP: $(php --version 2>/dev/null | head -1 || echo 'Not installed')"
echo "Composer: $(composer --version 2>/dev/null | head -1 || echo 'Not installed')"

echo ""
echo "🔧 Backend Setup (Laravel):"
echo "============================"
cd backend

# Install PHP dependencies
if [ ! -d "vendor" ]; then
    echo "Installing Composer dependencies..."
    composer install
else
    echo "✅ Composer dependencies already installed"
fi

# Setup environment file
if [ ! -f ".env" ]; then
    echo "Creating .env file..."
    cp .env.example .env
    php artisan key:generate
else
    echo "✅ .env file exists"
fi

# Run migrations
echo "Running database migrations..."
php artisan migrate --force

echo ""
echo "📦 Frontend Setup (Next.js):"
echo "============================="
cd ../frontend

# Install Node.js dependencies
if [ ! -d "node_modules" ]; then
    echo "Installing pnpm dependencies..."
    pnpm install
else
    echo "✅ pnpm dependencies already installed"
fi

cd ..

echo ""
echo "🎉 Setup Complete!"
echo "=================="
echo ""
echo "To start development servers:"
echo ""
echo "Backend (Terminal 1):"
echo "  cd backend && composer run dev"
echo "  # Starts Laravel at http://localhost:8000"
echo ""
echo "Frontend (Terminal 2):"
echo "  cd frontend && pnpm dev"
echo "  # Starts Next.js at http://localhost:3000"
echo ""
echo "📱 Access Points:"
echo "  • Frontend: http://localhost:3000"
echo "  • Backend API: http://localhost:8000"
echo "  • Admin Panel: http://localhost:8000/admin"
echo "  • Storybook: http://localhost:6006 (run: pnpm storybook)"
echo ""
echo "🔥 Ready to code! Remember to use Ubuntu terminal for all commands."