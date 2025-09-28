# 🚀 Rehome Setup Scripts

This directory contains automated setup scripts for the Rehome project's Filament v3 admin panel.

## 📁 Available Scripts

### 🎯 `setup-admin-panel.sh` - Complete Admin Setup
**The comprehensive solution for setting up Filament v3 admin panel**

**Features:**
- ✅ Environment detection (Local, GitHub Codespaces, Cursor IDE)
- ✅ Automatic Laravel key generation
- ✅ Database setup with SQLite
- ✅ Filament asset installation
- ✅ AdminPanelProvider configuration
- ✅ Dashboard with statistics widgets
- ✅ User management resource
- ✅ Admin user creation with roles
- ✅ Route cleanup and cache clearing
- ✅ Comprehensive verification

**Usage:**
```bash
# From project root
./scripts/setup-admin-panel.sh

# Or from backend directory
../scripts/setup-admin-panel.sh

# Make executable first if needed
chmod +x ./scripts/setup-admin-panel.sh
```

### ⚡ `quick-setup.sh` - One-Liner Installer
**Simplified entry point for the full setup**

**Usage:**
```bash
# From project root
./scripts/quick-setup.sh

# Or curl-based installation (when hosted)
curl -sSL https://raw.githubusercontent.com/your-repo/rehome/main/scripts/quick-setup.sh | bash
```

## 🔧 Requirements

### System Requirements
- **PHP**: 8.1+ (tested with 8.3.6)
- **Composer**: Latest version
- **expect**: For automated interactive prompts
  - Ubuntu/Debian: `sudo apt-get install expect`
  - macOS: `brew install expect`

### Laravel Requirements
- Laravel 10+ (tested with 12.31.1)
- SQLite support
- Required Laravel packages (installed via composer)

## 🌍 Environment Support

### 💻 Local Development
- **OS**: Linux, macOS, Windows (WSL2)
- **URL**: `http://localhost:8000/admin`
- **Database**: SQLite file in `database/database.sqlite`

### ☁️ GitHub Codespaces
- **Auto-detection**: Script detects Codespace environment
- **URL**: `https://{codespace-name}-8000.app.github.dev/admin`
- **Port forwarding**: Automatically configured
- **Database**: SQLite (persistent in Codespace)

### 🎯 Cursor IDE
- **Local setup**: Same as local development
- **Remote setup**: Supports remote development containers
- **URL**: `http://localhost:8000/admin`

## 📋 What Gets Installed

### Core Components
1. **Filament Admin Panel v3**: Complete admin interface
2. **Authentication System**: Login/logout with session management
3. **Dashboard**: Custom dashboard with statistics widgets
4. **User Management**: Full CRUD for user administration
5. **Role System**: Spatie Laravel Permissions integration

### Default Credentials
- **Email**: `admin@example.com`
- **Password**: `password`
- **Role**: `admin`

### Generated Files
```
app/
├── Filament/
│   ├── Pages/
│   │   └── Dashboard.php
│   ├── Resources/
│   │   └── UserResource.php
│   └── Widgets/
│       └── StatsOverviewWidget.php
└── Providers/
    └── Filament/
        └── AdminPanelProvider.php
```

## 🐛 Troubleshooting

### Common Issues

**1. Missing expect command**
```bash
# Ubuntu/Debian
sudo apt-get install expect

# macOS
brew install expect
```

**2. Permission denied**
```bash
chmod +x ./scripts/setup-admin-panel.sh
```

**3. Database connection issues**
```bash
# Verify SQLite file exists
ls -la backend/database/database.sqlite

# Recreate if missing
touch backend/database/database.sqlite
php artisan migrate --force
```

**4. Asset loading errors (404)**
```bash
# Re-run asset installation
cd backend
php artisan filament:install --panels
```

**5. Route conflicts**
```bash
# Clear route cache
php artisan route:clear
php artisan route:cache
```

### Debug Mode
Enable debug output by setting environment variable:
```bash
export DEBUG=1
./scripts/setup-admin-panel.sh
```

## 🔄 Manual Verification Steps

After running the setup script:

1. **Start Laravel server**:
   ```bash
   cd backend
   php artisan serve --host=0.0.0.0 --port=8000
   ```

2. **Access admin panel**:
   - Visit: `http://localhost:8000/admin`
   - Login: `admin@example.com` / `password`

3. **Verify components**:
   - ✅ Dashboard loads with statistics
   - ✅ User management accessible
   - ✅ No console errors
   - ✅ Responsive design works

## 📚 Related Documentation

- [`CODESPACE-SETUP.md`](../CODESPACE-SETUP.md) - Manual GitHub Codespaces setup
- [`CURSOR-SETUP.md`](../CURSOR-SETUP.md) - Manual Cursor IDE setup
- [`backend/README.md`](../backend/README.md) - Laravel backend documentation
- [`backend/FILAMENT-V3-UPGRADE.md`](../backend/FILAMENT-V3-UPGRADE.md) - Filament upgrade notes

## 🤝 Contributing

To improve the setup scripts:

1. Test changes across all supported environments
2. Update version compatibility in documentation
3. Add error handling for edge cases
4. Maintain backwards compatibility

## 📄 License

These scripts are part of the Rehome project and follow the same licensing terms.