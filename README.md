# Rehome

A new project to get started.

## Getting Started

This repository was initialized in GitHub Codespaces.

## About

More details about this project will be added here.

## Development Setup

### 🚀 Quick Start (WSL2 + VS Code)

1. **Open in VS Code with WSL:**
   ```bash
   code .  # From project directory
   ```
   
2. **Verify WSL connection:** Look for "WSL: Ubuntu" in VS Code bottom-left

3. **Run setup script (Ubuntu terminal only):**
   ```bash
   chmod +x scripts/dev-setup.sh
   bash scripts/dev-setup.sh
   ```

4. **Start development servers:**
   ```bash
   # Terminal 1 - Backend
   cd backend && composer run dev
   
   # Terminal 2 - Frontend  
   cd frontend && pnpm dev
   ```

### Manual Setup

**Backend (Laravel):**
```bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate --seed
composer run dev
```

**Frontend (Next.js):**
```bash
cd frontend
pnpm install
pnpm dev
```

### Default URLs

- Next.js: http://localhost:3000
- API/Admin: http://localhost:8000 (/admin)
- Storybook: http://localhost:6006

### Troubleshooting

If hot reload is flaky, ensure inotify limits (script above), bind to 0.0.0.0, and store code on Linux FS.