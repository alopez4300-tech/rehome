# Rehome Development in GitHub Codespaces

This repository supports both **Docker containerization** and **direct development** in GitHub Codespaces.

## 🐳 Docker Development (Recommended)

### **What's Included:**
- **Complete isolated environment**: Laravel, Next.js, MySQL, Redis, PhpMyAdmin, Mailhog
- **Auto-forwarded ports**: 8000, 3000, 6006, 8080, 8025
- **PHP extensions included**: No more manual `intl` installation!
- **VS Code extensions**: Prettier, PHP Intelephense, Docker support

### **Quick Start:**
1. **Open in Codespaces**: Click "Code" → "Codespaces" → "Create codespace on main"

2. **Start Docker environment**:
   ```bash
   # One command setup - everything included!
   bash scripts/docker-setup.sh
   ```

3. **Access applications** (make ports Public in Ports panel):
   - **🟡 Laravel Admin**: `https://<codespace>-8000.app.github.dev/admin`
   - **🔵 Next.js Frontend**: `https://<codespace>-3000.app.github.dev`
   - **📚 Storybook**: `https://<codespace>-6006.app.github.dev`
   - **📊 PhpMyAdmin**: `https://<codespace>-8080.app.github.dev`
   - **📧 Mailhog**: `https://<codespace>-8025.app.github.dev`

### **Credentials:**
- **Admin**: admin@example.com / password
- **Database**: rehome / rehome_password

## ⚡ Direct Development (Alternative)

### **Traditional setup** (if you prefer non-Docker):
```bash
# Start just Laravel backend
bash scripts/dev-start.sh --backend-only

# Or start everything (Laravel + Next.js + Storybook)
bash scripts/dev-start.sh --storybook
```

### **Available Services:**
- **🟡 Laravel Backend**: `https://<codespace>-8000.app.github.dev`
- **🔵 Next.js Frontend**: `https://<codespace>-3000.app.github.dev` 
- **📚 Storybook**: `https://<codespace>-6006.app.github.dev`

## 🛠️ Development Workflow

### **Docker Commands:**
```bash
# Laravel commands
docker-compose exec backend php artisan migrate
docker-compose exec backend php artisan make:model Post
docker-compose exec backend php artisan tinker

# Frontend commands  
docker-compose exec frontend pnpm install
docker-compose exec frontend pnpm add lodash

# View logs
docker-compose logs -f backend
docker-compose logs -f frontend

# Stop everything
bash scripts/docker-stop.sh
```

### **File Editing:**
- ✅ Edit files directly in VS Code
- ✅ Changes sync to containers automatically  
- ✅ Hot reload works for both Laravel and Next.js

## 🐛 Troubleshooting

### **Docker Issues:**
```bash
# Check container status
docker-compose ps

# Restart specific service
docker-compose restart backend

# Clean restart
docker-compose down -v && bash scripts/docker-setup.sh
```

### **Port Issues:**
- Make ports **Public** in the Ports panel (right-click → Port Visibility → Public)
- Docker containers automatically bind to `0.0.0.0`

### **Performance:**
- Docker in Codespaces is fast (no virtualization overhead)
- Use volume mounts for code (already configured)
- Hot reload works perfectly

## 💡 Pro Tips

1. **Use Docker** - Solves extension/environment issues permanently
2. **Keep PhpMyAdmin open** - Great for database debugging  
3. **Use Mailhog** - See all emails your app sends
4. **Ports panel** - Much easier than remembering URLs
5. **Docker logs** - Your debugging friend: `docker-compose logs -f [service]`

## 🔄 Migration from Direct Development

Your existing workflow still works! You can:
1. **Keep both**: Use `dev-start.sh` or `docker-setup.sh` as needed
2. **Gradual switch**: Test Docker, then migrate fully
3. **Team consistency**: Docker ensures everyone has the same environment

For complete Docker documentation, see `DOCKER.md`.