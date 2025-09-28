# WSL2 Development Guide for Rehome

## Initial Setup (After Ubuntu Installation)

### 1. First Time Ubuntu Setup
When Ubuntu first launches, you'll be prompted to:
- Create a username (suggestion: keep it simple, like your Windows username)
- Create a password (you'll need this for sudo commands)

### 2. Run the Setup Script
```bash
# Navigate to the project (from Windows filesystem)
cd /mnt/c/Users/alope/Documents/rehome

# Make the setup script executable
chmod +x scripts/setup-wsl2.sh

# Run the setup script
bash scripts/setup-wsl2.sh
```

### 3. Alternative: Clone to WSL Filesystem (Recommended for Performance)
```bash
# Clone to your home directory in WSL for better performance
cd ~
git clone https://github.com/alopez4300-tech/rehome.git
cd rehome

# Run setup
bash scripts/setup-wsl2.sh
```

## Daily Development Workflow

### Backend (Laravel)
```bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate --seed
composer run dev  # Starts server on http://localhost:8000
```

### Frontend (Next.js)
```bash
cd frontend
pnpm install
pnpm dev  # Starts server on http://localhost:3000
```

### Both Services at Once
```bash
# Terminal 1 - Backend
cd backend && composer run dev

# Terminal 2 - Frontend  
cd frontend && pnpm dev
```

## VS Code Integration

### Option 1: Open in WSL from Windows
1. Open VS Code in Windows
2. Install "Remote - WSL" extension
3. Open Command Palette (Ctrl+Shift+P)
4. Run "WSL: Open Folder in WSL"
5. Navigate to your project

### Option 2: Direct WSL Command
```bash
# From inside WSL
code .  # Opens current directory in VS Code
```

## File System Best Practices

- **Windows filesystem**: `/mnt/c/Users/alope/Documents/rehome`
  - Good for: Quick access from Windows
  - Performance: Slower I/O operations
  
- **WSL filesystem**: `~/rehome` or `/home/username/rehome`
  - Good for: Development work
  - Performance: Much faster I/O operations
  - Recommended for: Node modules, composer vendor, etc.

## Troubleshooting

### Port Already in Use
```bash
# Kill process on port 3000
sudo kill -9 $(sudo lsof -t -i:3000)

# Kill process on port 8000
sudo kill -9 $(sudo lsof -t -i:8000)
```

### File Permissions
```bash
# Fix permissions if needed
sudo chown -R $USER:$USER .
```

### Git Line Endings
Already configured via `.gitattributes`, but if needed:
```bash
git config core.autocrlf false
git config core.eol lf
```

## URLs

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **Filament Admin**: http://localhost:8000/admin  
- **Storybook**: http://localhost:6006

## Performance Tips

1. Keep project files in WSL filesystem for better performance
2. Use WSL2 (not WSL1) 
3. Configure `.wslconfig` for optimal memory/CPU usage
4. Use VS Code with Remote-WSL extension
5. Run Docker inside WSL2 if needed

## Git Workflow in WSL

All git commands work normally:
```bash
git status
git add .
git commit -m "Your message"
git push
```

Your git configuration from Windows should carry over, but verify:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```