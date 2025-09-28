<?php
namespace App\Filament\Resources;

use Filament\Resources\Resource;
use Filament\Forms\Form;
use Filament\Tables\Table;
use App\Models\Workspace;

class WorkspaceResource extends Resource
{
    protected static ?string $model = Workspace::class;
    protected static ?string $navigationIcon = 'heroicon-o-collection';
    protected static ?string $navigationGroup = 'Navigation';
    protected static ?string $navigationLabel = 'Workspaces';

    public static function form(Form $form): Form
    {
        return $form->schema([
            \Filament\Forms\Components\TextInput::make('name')->required(),
            \Filament\Forms\Components\Textarea::make('description'),
        ]);
    }

    public static function table(Table $table): Table
    {
        return $table->columns([
            \Filament\Tables\Columns\TextColumn::make('id'),
            \Filament\Tables\Columns\TextColumn::make('name'),
            \Filament\Tables\Columns\TextColumn::make('description'),
            \Filament\Tables\Columns\TextColumn::make('created_at')->dateTime(),
        ]);
    }

    public static function getPages(): array
    {
        return [
            'index' => \Filament\Resources\Pages\ListRecords::route('/'),
            'create' => \Filament\Resources\Pages\CreateRecord::route('/create'),
            'edit' => \Filament\Resources\Pages\EditRecord::route('/{record}/edit'),
        ];
    }
}
