# Codespaces Setup

This repository is configured for GitHub Codespaces with a comprehensive development environment that includes:

## What's Included

- **Ubuntu base image** with Node.js 20, PHP 8.3, and Composer
- **Auto-forwarded ports**: 8000 (Laravel), 3000 (Next.js), 6006 (Storybook), 5173 (Vite)
- **VS Code extensions**: Prettier, PHP Intelephense, Docker support
- **Automatic setup**: Runs setup script on container creation

## Quick Start

1. **Open in Codespaces**: Click "Code" → "Codespaces" → "Create codespace on main"

2. **Wait for setup**: The container will automatically:
   - Install dependencies for both frontend and backend
   - Set up Laravel environment
   - Make scripts executable

3. **Start development servers**:
   ```bash
   # Start everything (Laravel + Next.js + Storybook)
   bash scripts/dev-start.sh --storybook
   
   # Or start just Laravel backend
   bash scripts/dev-start.sh --backend-only
   
   # Or start just Next.js frontend  
   bash scripts/dev-start.sh --frontend-only
   ```

## Available Services

Once started, you can access:

- **🟡 Laravel Backend**: `https://<codespace>-8000.app.github.dev`
- **🔵 Next.js Frontend**: `https://<codespace>-3000.app.github.dev` 
- **📚 Storybook**: `https://<codespace>-6006.app.github.dev`

## Environment Configuration

The setup automatically:
- Installs all dependencies via `pnpm` and `composer`
- Copies `.env.example` to `.env` if needed
- Generates Laravel application key
- Configures proper file watching for hot reload

## Manual Setup (if needed)

If you need to run setup again:
```bash
bash scripts/dev-setup.sh
```

## Troubleshooting

- **Port conflicts**: Codespaces automatically handles port forwarding
- **Permission issues**: Scripts are automatically made executable
- **Dependency issues**: Re-run `bash scripts/dev-setup.sh`

For more details, see the main `README.md` and development workflow documentation.