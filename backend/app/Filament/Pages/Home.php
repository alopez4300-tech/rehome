<?php

namespace App\Filament\Pages;

use Filament\Pages\Page;

class Home extends Page
{
    protected static ?string $navigationIcon = 'heroicon-o-home';
    protected static ?string $navigationLabel = 'Home';
    protected static ?string $title = 'Welcome to Rehome Admin';
    protected static string $view = 'filament.pages.home';
}