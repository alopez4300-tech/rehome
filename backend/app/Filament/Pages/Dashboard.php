<?php

namespace App\Filament\Pages;

use Filament\Pages\Dashboard as BaseDashboard;

class Dashboard extends BaseDashboard
{
    protected static ?string $title = 'Home';
    protected static ?string $navigationLabel = 'Home';
    protected static ?string $navigationIcon = 'heroicon-o-home';
    
    public function getWidgets(): array
    {
        return [
            // No widgets - just clean home page
        ];
    }
}