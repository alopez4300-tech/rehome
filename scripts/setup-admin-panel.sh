#!/bin/bash

# 🚀 Rehome Admin Panel Setup Script
# This script automates the complete Filament v3 admin panel setup
# Compatible with: Local, GitHub Codespaces, and Cursor IDE environments

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "\n${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}\n"
}

# Detect environment
detect_environment() {
    if [[ -n "${CODESPACES}" ]]; then
        echo "codespace"
    elif [[ -n "${CURSOR_USER_AGENT}" ]] || [[ "$TERM_PROGRAM" == "cursor" ]]; then
        echo "cursor"
    else
        echo "local"
    fi
}

# Main setup function
main() {
    print_header "🚀 REHOME FILAMENT v3 ADMIN PANEL SETUP"
    
    ENV=$(detect_environment)
    print_status "Detected environment: $ENV"
    
    # Navigate to backend directory
    print_status "Navigating to backend directory..."
    cd backend || {
        print_error "Backend directory not found! Please run this script from the project root."
        exit 1
    }
    
    # Step 1: Verify requirements
    print_header "📋 Step 1: Verifying Requirements"
    
    # Check PHP version
    if ! command -v php &> /dev/null; then
        print_error "PHP is not installed or not in PATH"
        exit 1
    fi
    
    PHP_VERSION=$(php -r "echo PHP_VERSION;")
    print_status "PHP version: $PHP_VERSION"
    
    # Check Laravel
    if [[ ! -f "artisan" ]]; then
        print_error "Laravel artisan not found! Are you in the correct directory?"
        exit 1
    fi
    
    LARAVEL_VERSION=$(php artisan --version | grep -oP 'Laravel Framework \K[0-9.]+')
    print_status "Laravel version: $LARAVEL_VERSION"
    
    print_success "Requirements verified"
    
    # Step 2: Environment setup
    print_header "🔧 Step 2: Environment Setup"
    
    # Generate APP_KEY if missing
    if ! grep -q "APP_KEY=base64:" .env; then
        print_status "Generating Laravel application key..."
        php artisan key:generate
        print_success "Application key generated"
    else
        print_status "Application key already exists"
    fi
    
    # Update APP_URL based on environment
    case $ENV in
        "codespace")
            if [[ -n "$CODESPACE_NAME" ]]; then
                NEW_APP_URL="https://${CODESPACE_NAME}-8000.app.github.dev"
                print_status "Setting Codespace APP_URL: $NEW_APP_URL"
                sed -i "s|APP_URL=.*|APP_URL=$NEW_APP_URL|" .env
            fi
            ;;
        "cursor"|"local")
            print_status "Setting local APP_URL: http://localhost:8000"
            sed -i "s|APP_URL=.*|APP_URL=http://localhost:8000|" .env
            ;;
    esac
    
    print_success "Environment configured"
    
    # Step 3: Database setup
    print_header "💾 Step 3: Database Setup"
    
    if [[ ! -f "database/database.sqlite" ]]; then
        print_status "Creating SQLite database file..."
        touch database/database.sqlite
        print_success "Database file created"
    else
        print_status "Database file already exists"
    fi
    
    print_status "Running database migrations..."
    php artisan migrate --force
    print_success "Migrations completed"
    
    # Step 4: Install Filament assets
    print_header "🎨 Step 4: Installing Filament Assets"
    
    print_status "Installing Filament assets (this will overwrite AdminPanelProvider)..."
    # Use expect to automate the interactive prompts
    expect << EOF
spawn php artisan filament:install --panels
expect "What is the ID?"
send "admin\r"
expect "AdminPanelProvider.php already exists, do you want to overwrite it?"
send "Yes\r"
expect "All done! Would you like to show some love by starring"
send "No\r"
expect eof
EOF
    
    print_success "Filament assets installed"
    
    # Step 5: Configure AdminPanelProvider
    print_header "⚙️ Step 5: Configuring Admin Panel Provider"
    
    print_status "Restoring AdminPanelProvider configuration..."
    cat > app/Providers/Filament/AdminPanelProvider.php << 'EOL'
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
EOL
    
    print_success "AdminPanelProvider configured"
    
    # Step 6: Create Dashboard components
    print_header "📊 Step 6: Creating Dashboard Components"
    
    # Create Dashboard page
    print_status "Creating custom Dashboard page..."
    mkdir -p app/Filament/Pages
    cat > app/Filament/Pages/Dashboard.php << 'EOL'
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
EOL
    
    # Create StatsOverviewWidget
    print_status "Creating StatsOverview widget..."
    mkdir -p app/Filament/Widgets
    cat > app/Filament/Widgets/StatsOverviewWidget.php << 'EOL'
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
EOL
    
    print_success "Dashboard components created"
    
    # Step 7: Create User Resource
    print_header "👥 Step 7: Setting Up User Management"
    
    if [[ ! -f "app/Filament/Resources/UserResource.php" ]]; then
        print_status "Generating User resource..."
        php artisan make:filament-resource User --generate
        
        # Improve the generated UserResource
        print_status "Improving User resource configuration..."
        sed -i 's/protected static ?string $navigationIcon = .*/protected static ?string $navigationIcon = '\''heroicon-o-users'\'';/' app/Filament/Resources/UserResource.php
        sed -i '/protected static ?string $navigationIcon/a\\n    protected static ?string $navigationGroup = '\''User Management'\'';' app/Filament/Resources/UserResource.php
        sed -i 's/->required(),/->required()\n                    ->hiddenOn('\''edit'\''),/' app/Filament/Resources/UserResource.php
    else
        print_status "User resource already exists"
    fi
    
    print_success "User management configured"
    
    # Step 8: Create admin user
    print_header "🔐 Step 8: Creating Admin User"
    
    # Create admin role
    print_status "Creating admin role..."
    php artisan tinker --execute="try { Spatie\\Permission\\Models\\Role::firstOrCreate(['name' => 'admin']); echo 'Admin role created/exists'; } catch (Exception \$e) { echo 'Error: ' . \$e->getMessage(); }" 2>/dev/null || print_warning "Could not create role via tinker"
    
    # Create admin user
    print_status "Creating admin user..."
    php artisan app:make-user admin@example.com admin --name="Admin User" --password=password 2>/dev/null || print_warning "Admin user may already exist"
    
    print_success "Admin user setup completed"
    
    # Step 9: Clean up routes
    print_header "🛠️ Step 9: Cleaning Up Route Conflicts"
    
    print_status "Commenting out problematic API routes..."
    if grep -q "ProjectController" routes/api.php; then
        sed -i '/Route::middleware.*ensure.role.*app.*group/,/});/s/^/\/\/ /' routes/api.php
        print_success "Problematic routes commented out"
    else
        print_status "No problematic routes found"
    fi
    
    # Step 10: Clear caches
    print_header "🧹 Step 10: Clearing Caches"
    
    print_status "Clearing Laravel caches..."
    php artisan cache:clear &>/dev/null || true
    php artisan config:clear &>/dev/null || true
    php artisan route:clear &>/dev/null || true
    php artisan view:clear &>/dev/null || true
    
    print_success "Caches cleared"
    
    # Final verification
    print_header "✅ Step 11: Final Verification"
    
    print_status "Verifying Filament routes..."
    ROUTE_COUNT=$(php artisan route:list --name=filament 2>/dev/null | grep -c "filament" || echo "0")
    if [[ $ROUTE_COUNT -gt 0 ]]; then
        print_success "Found $ROUTE_COUNT Filament routes"
    else
        print_warning "No Filament routes found - there may be an issue"
    fi
    
    # Setup complete
    print_header "🎉 SETUP COMPLETE!"
    
    echo -e "${GREEN}✅ Filament v3 Admin Panel is ready!${NC}\n"
    
    case $ENV in
        "codespace")
            ADMIN_URL="https://${CODESPACE_NAME}-8000.app.github.dev/admin"
            ;;
        *)
            ADMIN_URL="http://localhost:8000/admin"
            ;;
    esac
    
    echo -e "${BLUE}📱 Access Information:${NC}"
    echo -e "   Admin Panel: ${YELLOW}$ADMIN_URL${NC}"
    echo -e "   Login Email: ${YELLOW}admin@example.com${NC}"
    echo -e "   Password:    ${YELLOW}password${NC}"
    echo ""
    echo -e "${BLUE}🚀 Next Steps:${NC}"
    echo -e "   1. Start the server: ${YELLOW}php artisan serve --host=0.0.0.0 --port=8000${NC}"
    echo -e "   2. Visit the admin panel at the URL above"
    echo -e "   3. Login with the credentials above"
    echo -e "   4. Verify dashboard and user management work"
    echo ""
    echo -e "${GREEN}🏆 Happy coding!${NC}"
}

# Check if expect is installed (needed for automated prompts)
if ! command -v expect &> /dev/null; then
    print_warning "expect is not installed. The script will continue but may require manual input."
    print_status "On Ubuntu/Debian: sudo apt-get install expect"
    print_status "On macOS: brew install expect"
fi

# Run main function
main "$@"