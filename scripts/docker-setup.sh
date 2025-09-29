#!/usr/bin/env bash
set -euo pipefail

echo "🐳 Docker Development Setup for Rehome"
echo "======================================"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if docker-compose is available
if ! command -v docker-compose > /dev/null 2>&1; then
    echo "❌ docker-compose is not installed. Please install Docker Compose."
    exit 1
fi

echo "✅ Docker is running"

# Create necessary directories
echo "📁 Creating required directories..."
mkdir -p backend/storage/logs
mkdir -p backend/bootstrap/cache
mkdir -p docker/mysql/data

# Generate APP_KEY if not exists
if [ ! -f backend/.env ]; then
    echo "📝 Creating backend .env file..."
    cp backend/.env.example backend/.env
fi

# Check if APP_KEY exists in .env
if ! grep -q "APP_KEY=base64:" backend/.env; then
    echo "🔑 Generating Laravel APP_KEY..."
    cd backend
    php artisan key:generate --no-interaction
    cd ..
fi

# Build and start containers
echo "🔨 Building Docker containers..."
docker-compose build

echo "🚀 Starting containers..."
docker-compose up -d

# Wait for MySQL to be ready
echo "⏳ Waiting for MySQL to be ready..."
sleep 10

# Run Laravel setup
echo "🎯 Setting up Laravel..."
docker-compose exec backend php artisan migrate --force
docker-compose exec backend php artisan db:seed --force
docker-compose exec backend php artisan storage:link
docker-compose exec backend php artisan filament:assets
docker-compose exec backend php artisan optimize:clear

# Create admin user
echo "👤 Creating admin user..."
docker-compose exec backend php artisan app:make-user admin@example.com admin --name="Admin User" --password=password

echo ""
echo "✅ Docker setup complete!"
echo ""
echo "📍 Service URLs:"
echo "  🟡 Laravel Backend: http://localhost:8000"
echo "  🟡 Laravel Admin: http://localhost:8000/admin"
echo "  🔵 Next.js Frontend: http://localhost:3000"
echo "  📚 Storybook: http://localhost:6006"
echo "  📊 PhpMyAdmin: http://localhost:8080"
echo "  📧 Mailhog: http://localhost:8025"
echo ""
echo "🔐 Admin Login: admin@example.com / password"
echo "🔐 Database: rehome / rehome / rehome_password"
echo ""
echo "Commands:"
echo "  🐳 Stop containers: docker-compose down"
echo "  🔄 Restart: docker-compose restart"
echo "  📋 View logs: docker-compose logs -f [service]"
echo "  🔧 Shell access: docker-compose exec [service] sh"