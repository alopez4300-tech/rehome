# Multi-IDE Development Guide

This project is optimized for development across multiple IDEs. Each has specific strengths:

## IDE Configurations Included

### 🎯 Cursor (AI-Powered Development)
- **Config**: `.cursorrules` - Project context and rules for AI assistance
- **Strengths**: AI-powered code generation, intelligent suggestions
- **Best for**: Rapid prototyping, AI-assisted development

### 🌊 Windsurf (Advanced AI Assistant)
- **Config**: Inherits from VS Code settings + EditorConfig
- **Strengths**: Advanced AI collaboration, context-aware assistance
- **Best for**: Complex problem solving, architectural decisions

### 🐘 PHPStorm (PHP/Laravel Excellence)
- **Config**: `.idea/` directory with PHP-specific settings
- **Strengths**: Excellent Laravel support, debugging, refactoring
- **Best for**: Backend development, complex PHP debugging

### 💙 VS Code (Full-Stack Flexibility)
- **Config**: `.vscode/settings.json` + workspace file
- **Strengths**: Great extension ecosystem, WSL integration
- **Best for**: Full-stack development, remote development

## Quick Setup per IDE

### Cursor Setup
1. Open project in Cursor
2. AI will automatically read `.cursorrules` for project context
3. Install recommended extensions when prompted

### Windsurf Setup
1. Open project in Windsurf
2. Extensions and settings inherited from VS Code config
3. AI context automatically detected

### PHPStorm Setup
1. Open project in PHPStorm
2. Configure PHP interpreter: `Settings > PHP > CLI Interpreter`
3. Set Composer path: `Settings > PHP > Composer`
4. Enable Laravel plugin if not auto-detected

### VS Code Setup
1. Open `rehome.code-workspace` file
2. Install recommended extensions when prompted
3. For WSL: Use "Remote-WSL" extension

## Shared Configurations

### EditorConfig (`.editorconfig`)
- Consistent formatting across all IDEs
- 4 spaces for PHP, 2 spaces for JS/TS
- LF line endings, UTF-8 encoding

### Git Configuration
- Line ending normalization via `.gitattributes`
- Ignore patterns for all IDE temp files

## Development Workflow

### 1. Choose Your IDE Based on Task
- **Complex PHP/Laravel work**: PHPStorm
- **Frontend development**: VS Code or Cursor
- **AI-assisted development**: Cursor or Windsurf
- **Full-stack debugging**: PHPStorm or VS Code

### 2. Terminal Commands Work Everywhere
```bash
# Backend
cd backend
composer install
php artisan serve

# Frontend  
cd frontend
pnpm install
pnpm dev
```

### 3. Debugging Setup

**PHPStorm**:
- Built-in Xdebug support
- Laravel-aware debugging

**VS Code**:
- PHP Debug extension
- Launch configurations in `.vscode/launch.json`

**Cursor/Windsurf**:
- Inherit VS Code debugging setup
- AI assistance for debugging

## File Exclusions

All IDEs configured to exclude:
- `node_modules/`
- `vendor/`
- `.git/`
- `storage/logs/`
- `.next/`
- Build artifacts

## AI Context (Cursor/Windsurf)

The `.cursorrules` file provides AI assistants with:
- Project structure overview
- Technology stack details
- Development patterns to follow
- Key models and relationships

## Formatting & Linting

- **PHP**: PSR-12 standard via Laravel Pint
- **TypeScript/JavaScript**: Biome for formatting and linting
- **Consistent across all IDEs** via EditorConfig

## Tips for Multi-IDE Development

1. **Commit often** - Keep changes synced across IDEs
2. **Use EditorConfig** - Ensures consistent formatting
3. **Terminal-based commands** - Work the same everywhere
4. **Git ignore** - Prevents IDE-specific files from being committed
5. **Environment files** - Use `.env` for configuration

## Troubleshooting

### Different Formatting
- Check EditorConfig support in your IDE
- Verify formatter settings match project standards

### Path Issues
- Use relative paths in configs when possible
- Check IDE-specific path resolution

### Extension Conflicts
- Some extensions may conflict between IDEs
- Check extension recommendations per IDE