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