<?php
namespace App\Filament\Resources;

use Filament\Resources\Resource;
use Filament\Resources\Forms\Form;
use Filament\Resources\Tables\Table;
use App\Models\Project;

class ProjectResource extends Resource
{
    protected static string $model = Project::class;
    protected static ?string $navigationIcon = 'heroicon-o-briefcase';
    protected static ?string $navigationGroup = 'Projects';
    protected static ?string $navigationLabel = 'Projects';

    public static function form(Form $form): Form
    {
        return $form->schema([
            // Add project fields here
        ]);
    }

    public static function table(Table $table): Table
    {
        return $table->columns([
            // Add project columns here
        ]);
    }
}
