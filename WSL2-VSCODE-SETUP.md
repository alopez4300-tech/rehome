# WSL2 + VS Code Development Setup

## 🚀 Quick Setup Guide

### 1. Open Project in WSL
From Windows PowerShell/CMD, navigate to your project and open in WSL:
```powershell
cd C:\Users\alope\Documents\rehome
code .
```

**OR** from Ubuntu terminal:
```bash
cd /mnt/c/Users/alope/Documents/rehome
code .
```

### 2. Verify WSL Integration
- Look for **"WSL: Ubuntu"** in VS Code's bottom-left corner
- Your terminal should show Ubuntu prompt (not PowerShell)
- File paths should show Linux format (`/mnt/c/...` or `~/...`)

## 🔧 Development Commands (Use Ubuntu Terminal Only)

### Backend (Laravel)
```bash
# Navigate to backend
cd backend

# Install dependencies
composer install

# Setup environment
cp .env.example .env
php artisan key:generate

# Create missing migrations (from our Filament upgrade)
php artisan make:migration create_workspaces_table
php artisan make:migration create_invoices_table
php artisan make:migration create_workspace_user_table

# Run migrations
php artisan migrate --seed

# Start development server
composer run dev
# OR: php artisan serve --host=0.0.0.0 --port=8000
```

### Frontend (Next.js)
```bash
# Navigate to frontend (in new terminal)
cd frontend

# Install dependencies
pnpm install

# Start development server
pnpm dev
# Starts on http://localhost:3000
```

### Storybook (Optional)
```bash
# From frontend directory
pnpm storybook
# Starts on http://localhost:6006
```

## 🌐 Access URLs

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **Filament Admin**: http://localhost:8000/admin
- **Storybook**: http://localhost:6006

## ⚙️ VS Code Configuration

### Required Extensions (Auto-install via workspace)
- Remote - WSL ✅
- PHP Intelephense
- Laravel Blade Syntax
- Laravel Artisan
- Tailwind CSS IntelliSense
- TypeScript and JavaScript Language Features

### Terminal Settings
- **Default**: Ubuntu (WSL)
- **Profile**: Automatically uses Ubuntu
- **File watching**: Enabled for hot reload

## 🔍 Troubleshooting

### Issue: PowerShell/CMD Opens Instead of Ubuntu
**Solution**: 
1. Click terminal dropdown arrow
2. Select "Ubuntu (WSL)" 
3. Or use `Ctrl+Shift+` ` and choose Ubuntu

### Issue: "Command not found" (composer, php, node, pnpm)
**Solution**: Ensure you're in Ubuntu terminal, not PowerShell
```bash
# Check your shell
echo $SHELL
# Should show: /bin/bash

# Check if tools are installed
which php composer node pnpm
```

### Issue: File watching not working
**Solution**: Already configured in workspace settings
- `remote.WSL.fileWatcher.polling: true`
- Excludes `node_modules` and `vendor`

### Issue: Slow file operations
**Solution**: 
- Keep project files in WSL filesystem (`~/rehome`) instead of Windows (`/mnt/c/...`)
- Or use the existing setup with proper watch polling

## 📁 File System Best Practices

### Current Setup (Windows → WSL)
```
Windows: C:\Users\alope\Documents\rehome
WSL:     /mnt/c/Users/alope/Documents/rehome
```

### Optimal Setup (WSL Native)
```bash
# Clone to WSL filesystem for best performance
cd ~
git clone https://github.com/alopez4300-tech/rehome.git
cd rehome
```

## 🔄 Consistency with Codespaces

This setup ensures:
- ✅ Same Ubuntu environment locally and in Codespaces
- ✅ Same terminal commands work everywhere
- ✅ Same file paths and line endings
- ✅ Same development workflow

## ⚡ Quick Start Checklist

- [ ] VS Code shows "WSL: Ubuntu" in bottom-left
- [ ] Terminal shows Ubuntu prompt (`user@hostname:~/path$`)
- [ ] `composer --version` works in terminal
- [ ] `php --version` shows PHP 8.3+
- [ ] `node --version` shows Node.js 20+
- [ ] `pnpm --version` shows pnpm 9+
- [ ] Backend runs on http://localhost:8000
- [ ] Frontend runs on http://localhost:3000
- [ ] Hot reload works for both services

---

**🎯 Remember**: Always use the Ubuntu terminal in VS Code for consistency!