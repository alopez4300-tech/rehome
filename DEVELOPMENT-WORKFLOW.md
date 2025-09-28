# 🚀 Rehome Development Workflow (WSL2 + Ubuntu)

> **⚠️ CRITICAL: Always Use Ubuntu (WSL2) Terminal**  
> All development must be done inside the Ubuntu terminal (not PowerShell, CMD, or Git Bash).  
> This ensures consistency across VS Code, Cursor AI, Windsurf, PHPStorm, and Codespaces.

---

## 🎯 Quick Start (Any Editor/AI)

### 1. Open the Project
```powershell
# From Windows (PowerShell/CMD) - ONE TIME ONLY
cd C:\Users\alope\Documents\rehome
code .
```

✅ **Verify**: VS Code/Cursor/Windsurf shows **"WSL: Ubuntu"** in bottom-left corner  
✅ **PHPStorm**: Set WSL2 PHP interpreter + Ubuntu terminal profile  
✅ **Codespaces**: Already runs Ubuntu by default

### 2. One-Time Environment Setup
```bash
# In Ubuntu terminal (inside editor)
chmod +x scripts/dev-setup.sh
bash scripts/dev-setup.sh
```

### 3. Daily Development Start
```bash
# Quick startup (both backend + frontend)
bash scripts/dev-start.sh
```

**OR manually:**
```bash
# Terminal 1 - Backend
cd backend && composer run dev

# Terminal 2 - Frontend  
cd frontend && pnpm dev
```

### 4. Access Your Application
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **Admin Panel**: http://localhost:8000/admin
- **Storybook**: http://localhost:6006 (run: `pnpm storybook`)

---

## 📋 Backend Commands (Laravel)

```bash
cd backend

# Dependencies
composer install              # Install PHP packages

# Environment
cp .env.example .env          # First time only
php artisan key:generate      # Generate app key

# Database
php artisan migrate           # Run migrations
php artisan migrate:fresh --seed  # Reset with test data

# Development Server
composer run dev              # Laravel + Vite (recommended)
# OR: php artisan serve --host=0.0.0.0 --port=8000

# Admin Panel
php artisan make:filament-user  # Create admin user
```

---

## 📦 Frontend Commands (Next.js)

```bash
cd frontend

# Dependencies
pnpm install                  # Install Node packages

# Development
pnpm dev                      # Next.js server
pnpm build                    # Production build
pnpm storybook               # Component development

# Code Quality
pnpm lint                     # Biome linting
pnpm typecheck               # TypeScript check
```

---

## 🗄️ Database Management

```bash
# Apply new migrations
php artisan migrate

# Reset database (⚠️ destroys data)
php artisan migrate:fresh --seed

# Create new migration
php artisan make:migration create_example_table

# Seed data
php artisan db:seed
```

---

## 🔄 Git Workflow (Ubuntu Terminal Only)

```bash
# Always commit from Ubuntu terminal
git status
git add .
git commit -m "feat: your descriptive message"
git push origin main

# Check current setup
git config --list
```

---

## 🛠️ Development Scripts

- **`scripts/dev-setup.sh`** - Complete environment bootstrap
- **`scripts/dev-start.sh`** - Start both backend + frontend servers
- **`scripts/bootstrap-linux.sh`** - Linux system dependencies
- **`scripts/setup-wsl2.sh`** - Complete WSL2 setup

---

## 🎨 Current Tech Stack

### Backend (Laravel)
- **PHP 8.2+** with Laravel 12
- **Filament v3** - Admin panel at `/admin`
- **Laravel Sanctum** - API authentication
- **Spatie Permissions** - Role-based access
- **SQLite** - Development database
- **Models**: User, Project, Task, File, Comment, Workspace, Invoice

### Frontend (Next.js)
- **Next.js 15** with TypeScript
- **Tailwind CSS** - Styling framework
- **Storybook** - Component development
- **Biome** - Linting and formatting
- **Components**: TaskBoard, UI components

### Development Tools
- **Composer** - PHP dependency management
- **pnpm** - Node.js package manager
- **Multi-IDE Support** - VS Code, Cursor, Windsurf, PHPStorm
- **Cross-platform** - Windows, WSL2, macOS, Linux, Codespaces

---

## 🚨 Common Issues & Solutions

### Issue: PowerShell/CMD Opens Instead of Ubuntu
**Solution**: 
1. Click terminal dropdown arrow in VS Code
2. Select "Ubuntu (WSL)" 
3. Or press `Ctrl+Shift+`` and choose Ubuntu

### Issue: "Command not found" (composer, php, node, pnpm)
**Solution**: Ensure you're in Ubuntu terminal
```bash
# Verify you're in Ubuntu
echo $SHELL  # Should show /bin/bash
uname -a     # Should mention WSL/Ubuntu

# Check tools
which php composer node pnpm
```

### Issue: File Watching Not Working
**Solution**: Already configured in workspace settings
- Files in `node_modules/` and `vendor/` are excluded
- WSL file watching polling is enabled

### Issue: Line Ending Problems
**Solution**: `.gitattributes` handles this automatically
- All text files use LF endings
- Binary files are preserved

---

## 📚 Reference Documentation

- **`DEVELOPMENT-STATUS.md`** - Current progress and features
- **`WSL2-VSCODE-SETUP.md`** - Detailed VS Code + WSL2 guide
- **`MULTI-IDE-GUIDE.md`** - Multi-IDE development setup
- **`FILAMENT-V3-UPGRADE.md`** - Filament upgrade details

---

## ✅ Pre-Flight Checklist

Before starting development, verify:

- [ ] Editor shows "WSL: Ubuntu" (VS Code/Cursor/Windsurf) or WSL interpreter (PHPStorm)
- [ ] Ubuntu terminal opens by default
- [ ] `php --version` shows PHP 8.2+
- [ ] `composer --version` works
- [ ] `node --version` shows Node 20+
- [ ] `pnpm --version` shows pnpm 9+
- [ ] Backend starts at http://localhost:8000
- [ ] Frontend starts at http://localhost:3000
- [ ] Admin panel accessible at http://localhost:8000/admin

---

## 🎯 For AI Assistants

When helping with this project:
1. **Always assume Ubuntu (WSL2) terminal**
2. **Never suggest PowerShell/CMD commands**
3. **Use the provided scripts when possible**
4. **Reference this workflow for consistency**
5. **All file paths should use Linux format**

---

**🔥 Remember: Ubuntu terminal for everything. This ensures perfect consistency across all development environments and AI assistants!**