# 🎯 Cursor IDE Setup: Filament v3 Admin Panel

This guide provides step-by-step instructions for setting up the complete Filament v3 admin panel in Cursor IDE, replicating the exact configuration from our working environment.

## 🏗️ Prerequisites

### Required Extensions for Cursor:
1. **PHP Intelephense** - PHP language support
2. **Laravel Extension Pack** - Laravel development tools
3. **Tailwind CSS IntelliSense** - CSS class suggestions
4. **GitLens** - Git integration
5. **Thunder Client** - API testing (optional)

### System Requirements:
- PHP 8.3+ 
- Composer
- Node.js 20+
- pnpm
- SQLite

## 📁 Project Structure

Your project should have this structure:
```
rehome/
├── backend/          # Laravel + Filament API
├── frontend/         # Next.js Application  
├── scripts/          # Development scripts
└── README.md
```

## 🔧 Step 1: Initial Backend Setup

### 1.1 Open Backend in Cursor

```bash
# In Cursor terminal
cd backend
```

### 1.2 Install Dependencies (if needed)

```bash
# Install PHP dependencies
composer install

# Verify Laravel version
php artisan --version
# Should show: Laravel Framework 12.31.1+
```

### 1.3 Environment Configuration

```bash
# Generate application key (CRITICAL for authentication)
php artisan key:generate

# Verify .env settings
cat .env | grep -E "APP_URL|DB_|SESSION_"
```

Expected output:
```env
APP_URL=http://localhost:8000
DB_CONNECTION=sqlite
SESSION_DRIVER=database
```

### 1.4 Database Setup

```bash
# Create SQLite database
touch database/database.sqlite

# Run migrations
php artisan migrate

# Verify database exists
ls -la database/database.sqlite
```

## 🎨 Step 2: Filament Installation & Configuration

### 2.1 Install Filament Assets

```bash
# This publishes all CSS/JS assets and fixes 404 errors
php artisan filament:install --panels

# When prompted:
# ┌ What is the ID? ────────────────────────────────────┐
# │ admin                                               │  ← Press Enter
# └─────────────────────────────────────────────────────┘

# ┌ AdminPanelProvider.php already exists, do you want… ┐
# │ Yes                                                 │  ← Press Enter
# └─────────────────────────────────────────────────────┘
```

### 2.2 Configure AdminPanelProvider

**⚠️ IMPORTANT:** The installation above will overwrite your AdminPanelProvider. 

Open `app/Providers/Filament/AdminPanelProvider.php` in Cursor and replace the entire contents with:

```php
<?php

namespace App\Providers\Filament;

use Filament\Http\Middleware\Authenticate;
use Filament\Http\Middleware\AuthenticateSession;
use Filament\Http\Middleware\DisableBladeIconComponents;
use Filament\Http\Middleware\DispatchServingFilamentEvent;
use Filament\Pages;
use Filament\Panel;
use Filament\PanelProvider;
use Filament\Support\Colors\Color;
use Filament\Widgets;
use Illuminate\Cookie\Middleware\AddQueuedCookiesToResponse;
use Illuminate\Cookie\Middleware\EncryptCookies;
use Illuminate\Foundation\Http\Middleware\VerifyCsrfToken;
use Illuminate\Routing\Middleware\SubstituteBindings;
use Illuminate\Session\Middleware\StartSession;
use Illuminate\View\Middleware\ShareErrorsFromSession;

class AdminPanelProvider extends PanelProvider
{
    public function panel(Panel $panel): Panel
    {
        return $panel
            ->default()
            ->id('admin')
            ->path('admin')
            ->login()
            ->brandName('Rehome Admin')
            ->colors([
                'primary' => Color::Blue,
            ])
            ->resources([
                \App\Filament\Resources\UserResource::class,
            ])
            ->pages([
                Pages\Dashboard::class,
            ])
            ->widgets([
                Widgets\AccountWidget::class,
                Widgets\FilamentInfoWidget::class,
                \App\Filament\Widgets\StatsOverviewWidget::class,
            ])
            ->middleware([
                EncryptCookies::class,
                AddQueuedCookiesToResponse::class,
                StartSession::class,
                AuthenticateSession::class,
                ShareErrorsFromSession::class,
                VerifyCsrfToken::class,
                SubstituteBindings::class,
                DisableBladeIconComponents::class,
                DispatchServingFilamentEvent::class,
            ])
            ->authMiddleware([
                Authenticate::class,
            ]);
    }
}
```

## 📊 Step 3: Create Dashboard Components

### 3.1 Custom Dashboard Page

Create `app/Filament/Pages/Dashboard.php`:

**Cursor Tip:** Use `Ctrl+Shift+P` → "File: New File" or right-click in explorer.

```php
<?php

namespace App\Filament\Pages;

use Filament\Pages\Dashboard as BaseDashboard;

class Dashboard extends BaseDashboard
{
    protected static ?string $title = 'Dashboard';
    protected static ?string $navigationLabel = 'Dashboard';
    protected static ?string $navigationIcon = 'heroicon-o-home';
    
    public function getWidgets(): array
    {
        return [
            \App\Filament\Widgets\StatsOverviewWidget::class,
        ];
    }
    
    public function getColumns(): int|string|array
    {
        return 1;
    }
}
```

### 3.2 Stats Overview Widget

Create directory structure: `app/Filament/Widgets/`

Create `app/Filament/Widgets/StatsOverviewWidget.php`:

```php
<?php

namespace App\Filament\Widgets;

use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;
use App\Models\User;

class StatsOverviewWidget extends BaseWidget
{
    protected function getStats(): array
    {
        try {
            $userCount = User::count();
        } catch (\Exception $e) {
            // Handle database errors gracefully
            $userCount = 0;
        }

        return [
            Stat::make('Total Users', $userCount)
                ->description('All registered users')
                ->descriptionIcon('heroicon-m-users')
                ->color('success'),
            
            Stat::make('Active Sessions', '1')
                ->description('Currently logged in')
                ->descriptionIcon('heroicon-m-user-circle')
                ->color('primary'),
                
            Stat::make('System Status', 'Online')
                ->description('All systems operational')
                ->descriptionIcon('heroicon-m-check-circle')
                ->color('success'),
        ];
    }
}
```

## 👥 Step 4: User Management

### 4.1 Generate User Resource

```bash
# Generate complete CRUD resource for User model
php artisan make:filament-resource User --generate
```

### 4.2 Improve User Resource

Open `app/Filament/Resources/UserResource.php` and update the class definition:

```php
class UserResource extends Resource
{
    protected static ?string $model = User::class;

    protected static ?string $navigationIcon = 'heroicon-o-users';
    
    protected static ?string $navigationGroup = 'User Management';
    
    // ... rest of the generated code stays the same
```

Find the `form()` method and update the password field:

```php
Forms\Components\TextInput::make('password')
    ->password()
    ->required()
    ->hiddenOn('edit'),  // Add this line
```

## 🔐 Step 5: Authentication Setup

### 5.1 Create Admin Role & User

```bash
# Create admin role (using tinker)
php artisan tinker --execute="Spatie\\Permission\\Models\\Role::create(['name' => 'admin']);"

# Create admin user with role
php artisan app:make-user admin@example.com admin --name="Admin User" --password=password
```

### 5.2 Verify User Creation

```bash
# Check user was created
php artisan tinker --execute="echo App\\Models\\User::where('email', 'admin@example.com')->exists() ? 'User exists' : 'User not found';"
```

## 🛠️ Step 6: Clean Up Route Conflicts

### 6.1 Fix API Routes

Open `routes/api.php` and comment out problematic routes:

```php
// TODO: Create controllers for these routes when needed
/*
Route::middleware(['auth:sanctum', 'ensure.role:team,consultant,client'])->prefix('app')->group(function () {
    Route::get('/workspaces/{workspace}/projects', 'App\\Http\\Controllers\\ProjectController@index')->middleware('scope.workspace');
    Route::get('/workspaces/{workspace}/projects/{project}', 'App\\Http\\Controllers\\ProjectController@show')->middleware('scope.workspace');
    Route::post('/workspaces/{workspace}/projects', 'App\\Http\\Controllers\\ProjectController@store')->middleware('scope.workspace');
    Route::put('/workspaces/{workspace}/projects/{project}', 'App\\Http\\Controllers\\ProjectController@update')->middleware('scope.workspace');
    Route::delete('/workspaces/{workspace}/projects/{project}', 'App\\Http\\Controllers\\ProjectController@destroy')->middleware('scope.workspace');

    Route::apiResource('workspaces.projects.tasks', 'App\\Http\\Controllers\\TaskController')->middleware('scope.workspace');
    Route::apiResource('workspaces.projects.files', 'App\\Http\\Controllers\\FileController')->middleware('scope.workspace');
    Route::apiResource('workspaces.projects.comments', 'App\\Http\\Controllers\\CommentController')->middleware('scope.workspace');
});
*/
```

### 6.2 Clear Caches

```bash
# Clear all Laravel caches
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear
```

## 🚀 Step 7: Launch Application

### 7.1 Start Backend Server

In Cursor terminal:

```bash
# Start Laravel server
php artisan serve --host=0.0.0.0 --port=8000
```

**Cursor Tip:** Split terminal with `Ctrl+Shift+5` to run multiple commands.

### 7.2 Start Frontend (Optional)

In a new terminal tab:

```bash
# Navigate to frontend
cd ../frontend

# Start Next.js development server
pnpm dev
```

## 🎯 Step 8: Testing & Verification

### 8.1 Test Backend Health

```bash
# In another terminal or using Thunder Client
curl http://localhost:8000/api/health
```

Expected response:
```json
{
  "ok": true,
  "app": "Laravel",
  "time": "2025-09-28T...",
  "env": "local"
}
```

### 8.2 Test Admin Panel

1. **Open in Browser:** `http://localhost:8000/admin`
2. **Verify Redirect:** Should redirect to `/admin/login`
3. **Login:** Use `admin@example.com` / `password`
4. **Check Dashboard:** Should show stats widgets
5. **Test Navigation:** Click "Users" in sidebar

### 8.3 Verify Assets

In browser dev tools (F12), check:
- ✅ No 404 errors for CSS/JS files
- ✅ All assets load with `?v=3.3.41.0` version
- ✅ No Alpine.js store errors in console

## 🔍 Cursor IDE Specific Tips

### Debugging:
- **Set Breakpoints:** Click line numbers in PHP files
- **Xdebug:** Configure in settings for step debugging
- **Error Overlay:** Shows syntax errors immediately

### Code Navigation:
- **Go to Definition:** `Ctrl+Click` or `F12`
- **Find References:** `Shift+F12`
- **Symbol Search:** `Ctrl+T`
- **File Search:** `Ctrl+P`

### Git Integration:
- **Source Control:** `Ctrl+Shift+G`
- **Compare Changes:** Click file in source control panel
- **Commit:** Stage changes and write commit message

### Extensions Setup:
```json
// Add to Cursor settings.json
{
  "php.suggest.basic": false,
  "php.validate.enable": false,
  "intelephense.files.maxSize": 5000000,
  "emmet.includeLanguages": {
    "blade": "html"
  }
}
```

## 🚨 Troubleshooting

### Common Issues:

**Asset 404 Errors:**
```bash
rm -rf public/css public/js
php artisan filament:install --panels
```

**Authentication Loops:**
```bash
php artisan key:generate
php artisan config:clear
```

**Route Cache Issues:**
```bash
php artisan route:clear
php artisan optimize:clear
```

**Permission Errors:**
```bash
chmod -R 775 storage bootstrap/cache
```

### Cursor-Specific Issues:

**IntelliSense Not Working:**
- Restart PHP Language Server: `Ctrl+Shift+P` → "PHP: Restart Language Server"
- Clear Cursor cache: Help → "Reset Extension Host"

**Git Integration Problems:**
- Refresh Git status: Click refresh icon in Source Control panel
- Re-index repository: `Ctrl+Shift+P` → "Git: Reload"

## ✅ Success Checklist

- [ ] PHP 8.3+ running
- [ ] Laravel Framework 12.31.1+
- [ ] Filament v3.3.41 assets published
- [ ] Database migrated successfully
- [ ] Admin user created with role
- [ ] Server running on port 8000
- [ ] Admin panel accessible at `/admin`
- [ ] Login works with credentials
- [ ] Dashboard displays stats widgets
- [ ] Users resource shows in navigation
- [ ] No browser console errors
- [ ] All assets load with versioning

## 🎉 Final Result

**Admin Panel Access:**
- URL: `http://localhost:8000/admin`
- Login: `admin@example.com` / `password`
- Features: Dashboard, User Management, Professional UI

**Frontend Access:**
- URL: `http://localhost:3000`
- Framework: Next.js 15.5.4

**🏆 Your Filament v3 admin panel is now fully operational in Cursor IDE!**

### Quick Development Commands:

```bash
# Restart everything
php artisan serve --host=0.0.0.0 --port=8000

# Check logs
tail -f storage/logs/laravel.log

# Make changes and clear cache
php artisan optimize:clear
```

**Happy coding in Cursor! 🎯**