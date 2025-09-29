# Rehome Docker Development

This document provides instructions for running Rehome in Docker containers.

## 🚀 Quick Start

1. **Prerequisites**
   - Docker Desktop installed and running
   - Docker Compose v2.x
   - Git

2. **Setup and Run**
   ```bash
   # Clone and setup
   git clone <your-repo>
   cd rehome
   
   # Start Docker environment
   bash scripts/docker-setup.sh
   ```

3. **Access Applications**
   - **Laravel Backend**: http://localhost:8000
   - **Laravel Admin**: http://localhost:8000/admin
   - **Next.js Frontend**: http://localhost:3000
   - **Storybook**: http://localhost:6006
   - **PhpMyAdmin**: http://localhost:8080
   - **Mailhog**: http://localhost:8025

## 🔐 Default Credentials

- **Admin Panel**: admin@example.com / password
- **Database**: rehome / rehome_password
- **PhpMyAdmin**: root / root_password

## 🐳 Docker Services

### Core Services
- **backend**: Laravel 12 with PHP 8.3, Nginx, MySQL
- **frontend**: Next.js 15 with Node 20
- **mysql**: MySQL 8.0 database
- **redis**: Redis 7 for caching and sessions

### Development Tools
- **storybook**: Component development (dev mode only)
- **phpmyadmin**: Database management UI
- **mailhog**: Email testing and debugging

## 📋 Common Commands

```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down
# or
bash scripts/docker-stop.sh

# View logs
docker-compose logs -f backend
docker-compose logs -f frontend

# Shell access
docker-compose exec backend sh
docker-compose exec frontend sh

# Run Laravel commands
docker-compose exec backend php artisan migrate
docker-compose exec backend php artisan tinker

# Run npm/pnpm commands
docker-compose exec frontend pnpm install
docker-compose exec frontend pnpm build

# Restart specific service
docker-compose restart backend
```

## 🛠️ Development Workflow

### Laravel Backend Development
```bash
# Run migrations
docker-compose exec backend php artisan migrate

# Run seeders
docker-compose exec backend php artisan db:seed

# Clear caches
docker-compose exec backend php artisan optimize:clear

# Generate Filament resources
docker-compose exec backend php artisan make:filament-resource ModelName
```

### Next.js Frontend Development
```bash
# Install dependencies
docker-compose exec frontend pnpm install

# Run development server (auto-starts)
docker-compose exec frontend pnpm dev

# Build for production
docker-compose exec frontend pnpm build

# Run Storybook
docker-compose exec storybook pnpm storybook
```

## 🔧 Configuration

### Environment Variables

**Backend (.env)**
```env
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=rehome
DB_USERNAME=rehome
DB_PASSWORD=rehome_password

REDIS_HOST=redis
REDIS_PORT=6379

MAIL_MAILER=smtp
MAIL_HOST=mailhog
MAIL_PORT=1025
```

**Frontend (.env.local)**
```env
NEXT_PUBLIC_API_URL=http://localhost:8000
```

### Volume Mounts

- **Backend**: `./backend` → `/var/www/html`
- **Frontend**: `./frontend` → `/app`
- **MySQL Data**: `mysql_data` volume
- **Redis Data**: `redis_data` volume

## 🐛 Troubleshooting

### Common Issues

1. **Port Conflicts**
   ```bash
   # Check what's using the port
   lsof -i :8000
   
   # Kill the process
   kill -9 <PID>
   ```

2. **Permission Issues**
   ```bash
   # Fix Laravel storage permissions
   docker-compose exec backend chown -R www-data:www-data storage bootstrap/cache
   ```

3. **Database Connection Issues**
   ```bash
   # Check MySQL status
   docker-compose logs mysql
   
   # Restart MySQL
   docker-compose restart mysql
   ```

4. **Frontend Build Issues**
   ```bash
   # Clear Next.js cache
   docker-compose exec frontend rm -rf .next
   
   # Reinstall dependencies
   docker-compose exec frontend rm -rf node_modules pnpm-lock.yaml
   docker-compose exec frontend pnpm install
   ```

### Reset Everything
```bash
# Stop and remove all containers, networks, and volumes
docker-compose down -v --rmi all

# Remove any remaining containers
docker system prune -a

# Start fresh
bash scripts/docker-setup.sh
```

## 🚢 Production Deployment

For production deployment, use the main `docker-compose.yml` without the override:

```bash
# Build production images
docker-compose -f docker-compose.yml build

# Start production containers
docker-compose -f docker-compose.yml up -d
```

## 📊 Monitoring

### Container Health
```bash
# Check container status
docker-compose ps

# View resource usage
docker stats

# Check logs
docker-compose logs -f --tail=100
```

### Application Health
- **Backend Health**: http://localhost:8000/health (if implemented)
- **Database**: PhpMyAdmin at http://localhost:8080
- **Email**: Mailhog at http://localhost:8025

## 🔄 Updates

```bash
# Pull latest images
docker-compose pull

# Rebuild containers
docker-compose build --no-cache

# Restart with new images
docker-compose up -d
```