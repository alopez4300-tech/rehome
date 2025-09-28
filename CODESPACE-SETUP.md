# 🚀 GitHub Codespace Setup: Filament v3 Admin Panel

This guide will help you set up the complete Filament v3 admin panel in a GitHub Codespace environment, replicating the exact configuration from the local development setup.

## 📋 Prerequisites Verification

First, verify your environment is ready:

```bash
# Check PHP version (should be 8.3+)
php --version

# Check Laravel version
cd backend && php artisan --version

# Check Node.js for frontend
node --version
```

## 🔧 Step 1: Backend Setup (Laravel + Filament)

### 1.1 Navigate to Backend Directory
```bash
cd /workspaces/rehome/backend
```

### 1.2 Generate Application Key
```bash
# Critical: Generate Laravel encryption key (prevents authentication errors)
php artisan key:generate
```

### 1.3 Database Setup
```bash
# Create SQLite database file
touch database/database.sqlite

# Run database migrations
php artisan migrate
```

### 1.4 Install and Configure Filament Assets
```bash
# Install Filament assets (resolves CSS/JS 404 errors)
php artisan filament:install --panels

# When prompted:
# - Panel ID: admin
# - Overwrite AdminPanelProvider: Yes
```

### 1.5 Fix AdminPanelProvider Configuration

After the asset installation, the AdminPanelProvider will be reset. Replace the contents of `app/Providers/Filament/AdminPanelProvider.php` with:

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

### 1.6 Create Custom Dashboard Page

Create `app/Filament/Pages/Dashboard.php`:

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

### 1.7 Create Stats Overview Widget

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

### 1.8 Generate User Resource

```bash
# Generate complete User resource with forms and tables
php artisan make:filament-resource User --generate
```

### 1.9 Update User Resource

Edit `app/Filament/Resources/UserResource.php` to improve the resource:

```php
<?php

namespace App\Filament\Resources;

use App\Filament\Resources\UserResource\Pages;
use App\Models\User;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class UserResource extends Resource
{
    protected static ?string $model = User::class;
    
    protected static ?string $navigationIcon = 'heroicon-o-users';
    
    protected static ?string $navigationGroup = 'User Management';

    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\TextInput::make('name')
                    ->required(),
                Forms\Components\TextInput::make('email')
                    ->email()
                    ->required(),
                Forms\Components\DateTimePicker::make('email_verified_at'),
                Forms\Components\TextInput::make('password')
                    ->password()
                    ->required()
                    ->hiddenOn('edit'),
            ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\TextColumn::make('name')
                    ->searchable(),
                Tables\Columns\TextColumn::make('email')
                    ->searchable(),
                Tables\Columns\TextColumn::make('email_verified_at')
                    ->dateTime()
                    ->sortable(),
                Tables\Columns\TextColumn::make('created_at')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
                Tables\Columns\TextColumn::make('updated_at')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                //
            ])
            ->actions([
                Tables\Actions\EditAction::make(),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    Tables\Actions\DeleteBulkAction::make(),
                ]),
            ]);
    }

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListUsers::route('/'),
            'create' => Pages\CreateUser::route('/create'),
            'edit' => Pages\EditUser::route('/{record}/edit'),
        ];
    }
}
```

### 1.10 Create Admin User

```bash
# Create admin role first
php artisan tinker --execute="Spatie\\Permission\\Models\\Role::create(['name' => 'admin']);"

# Create admin user with role
php artisan app:make-user admin@example.com admin --name="Admin User" --password=password
```

### 1.11 Clean Up Route Conflicts

Edit `routes/api.php` and comment out any routes referencing non-existent controllers:

```php
// TODO: Create controllers for these routes
// Route::middleware(['auth:sanctum', 'ensure.role:team,consultant,client'])->prefix('app')->group(function () {
//     // ... commented out routes
// });
```

### 1.12 Update Environment

Make sure your `.env` file has the correct settings:

```env
APP_URL=https://your-codespace-url.github.dev
# or for port forwarding:
APP_URL=https://your-codespace-url-8000.app.github.dev

DB_CONNECTION=sqlite
SESSION_DRIVER=database
SESSION_LIFETIME=120
SESSION_ENCRYPT=false
SESSION_PATH=/
SESSION_DOMAIN=null
```

## 🎯 Step 2: Start Backend Server

```bash
# Start Laravel development server
php artisan serve --host=0.0.0.0 --port=8000
```

**Access Points:**
- Admin Panel: `https://your-codespace-url-8000.app.github.dev/admin`
- Login: `admin@example.com` / `password`

## 🖥️ Step 3: Frontend Setup (Next.js)

In a new terminal:

```bash
# Navigate to frontend
cd /workspaces/rehome/frontend

# Start Next.js development server  
pnpm dev
```

**Access Point:**
- Frontend: `https://your-codespace-url-3000.app.github.dev`

## ✅ Verification Steps

1. **Backend Health Check:**
   ```bash
   curl https://your-codespace-url-8000.app.github.dev/api/health
   ```

2. **Admin Panel Access:**
   - Visit: `https://your-codespace-url-8000.app.github.dev/admin`
   - Should redirect to login page
   - Login with: `admin@example.com` / `password`
   - Should see dashboard with stats widgets

3. **Asset Loading:**
   - Check browser dev tools for no 404 errors
   - All CSS/JS should load with version numbers

## 🔧 Troubleshooting

### Common Issues:

**404 Asset Errors:**
```bash
php artisan filament:install --panels
```

**Route Errors:**
```bash
php artisan route:clear
php artisan config:clear
```

**Authentication Issues:**
```bash
# Ensure APP_KEY is set
php artisan key:generate
```

**Database Issues:**
```bash
# Reset and remigrate
rm database/database.sqlite
touch database/database.sqlite
php artisan migrate
```

## 📱 GitHub Codespace Specific Notes

1. **Port Forwarding:** Codespaces automatically forwards ports 3000 and 8000
2. **HTTPS URLs:** All Codespace URLs use HTTPS by default
3. **Environment Variables:** Update APP_URL to match your Codespace URL
4. **File Permissions:** Usually not an issue in Codespaces
5. **Performance:** Codespaces may be slower than local development

## 🎉 Success Indicators

- ✅ No 404 errors in browser console
- ✅ Admin login works smoothly
- ✅ Dashboard displays with widgets
- ✅ User resource shows in navigation
- ✅ All Filament styling applies correctly
- ✅ Sidebar navigation functions properly

**🏆 Your Filament v3 admin panel should now be fully operational in GitHub Codespaces!**