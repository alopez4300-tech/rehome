# 🏠 Rehome

Full-stack project management application built with Laravel + Next.js.

## 🚀 Quickstart

### 1. Setup (one-time)
```bash
bash scripts/dev-setup.sh
```

### 2. Daily Development

```bash
# Start backend + frontend
bash scripts/dev-start.sh

# Start backend + frontend + Storybook
bash scripts/dev-start.sh --storybook
```

### 3. Access your app

* **Backend API:** [http://localhost:8000](http://localhost:8000)
* **Frontend:** [http://localhost:3000](http://localhost:3000)
* **Storybook:** [http://localhost:6006](http://localhost:6006) (when run with `--storybook`)
* **Admin Panel:** [http://localhost:8000/admin](http://localhost:8000/admin)

---

📌 **Note:**

* Always run these commands inside the **Ubuntu (WSL2) terminal**.
* Never use PowerShell or CMD.
* The scripts handle everything — migrations, dependencies, and server startup.

**👉 [See DEVELOPMENT-WORKFLOW.md](./DEVELOPMENT-WORKFLOW.md) for complete setup instructions**

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