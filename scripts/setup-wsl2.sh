#!/usr/bin/env bash
# WSL2 Development Environment Setup Script
set -euo pipefail

echo "🚀 Setting up WSL2 development environment for rehome..."

# Update package list
echo "📦 Updating package list..."
sudo apt update

# Install essential build tools
echo "🔧 Installing build tools..."
sudo apt install -y curl wget git build-essential

# Install Node.js via nvm
echo "📗 Installing Node.js..."
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# Source nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install and use Node.js v20
nvm install 20
nvm use 20
nvm alias default 20

# Install pnpm
echo "📦 Installing pnpm..."
npm install -g pnpm@9.7.0

# Install PHP 8.3
echo "🐘 Installing PHP 8.3..."
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update
sudo apt install -y php8.3 php8.3-cli php8.3-common php8.3-curl php8.3-mbstring php8.3-xml php8.3-zip php8.3-sqlite3 php8.3-mysql php8.3-pgsql

# Install Composer
echo "🎼 Installing Composer..."
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer

# Run the existing bootstrap script for additional setup
if [ -f "scripts/bootstrap-linux.sh" ]; then
    echo "🔧 Running additional bootstrap setup..."
    bash scripts/bootstrap-linux.sh
fi

echo "✅ WSL2 development environment setup complete!"
echo ""
echo "Next steps:"
echo "1. cd /mnt/c/Users/alope/Documents/rehome"
echo "2. Or clone to WSL filesystem: git clone <your-repo-url> ~/rehome"
echo "3. Backend: cd backend && composer install && php artisan key:generate"
echo "4. Frontend: cd frontend && pnpm install && pnpm dev"
echo ""
echo "🎉 Happy coding!"