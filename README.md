# 🏠 Rehome

Full-stack project management application built with Laravel + Next.js.

## 🚀 Quick Start

**👉 [See DEVELOPMENT-WORKFLOW.md](./DEVELOPMENT-WORKFLOW.md) for complete setup instructions**

### TL;DR for Developers

1. **Open in WSL2:**
   ```powershell
   cd C:\Users\alope\Documents\rehome && code .
   ```

2. **Setup (Ubuntu terminal):**
   ```bash
   bash scripts/dev-setup.sh
   ```

3. **Start servers:**
   ```bash
   bash scripts/dev-start.sh
   ```

4. **Access:**
   - Frontend: http://localhost:3000
   - Backend: http://localhost:8000
   - Admin: http://localhost:8000/admin

## 🛠️ Tech Stack

- **Backend**: Laravel 12 + PHP 8.2+ + Filament v3 Admin
- **Frontend**: Next.js 15 + TypeScript + Tailwind CSS
- **Database**: SQLite (dev) with Laravel migrations
- **Development**: WSL2 + Ubuntu (multi-IDE support)

## 📋 Features

- User authentication and authorization
- Project management with tasks and files
- Admin panel with Filament v3
- Component library with Storybook
- Cross-platform development (Windows/WSL2/macOS/Linux/Codespaces)

### Default URLs

- Next.js: http://localhost:3000
- API/Admin: http://localhost:8000 (/admin)
- Storybook: http://localhost:6006

### Troubleshooting

If hot reload is flaky, ensure inotify limits (script above), bind to 0.0.0.0, and store code on Linux FS.