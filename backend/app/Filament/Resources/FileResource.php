<?php
namespace App\Filament\Resources;

use Filament\Resources\Resource;
use Filament\Resources\Forms\Form;
use Filament\Resources\Tables\Table;
use App\Models\File;

class FileResource extends Resource
{
    protected static string $model = File::class;
    protected static ?string $navigationIcon = 'heroicon-o-document';
    protected static ?string $navigationGroup = 'Projects';
    protected static ?string $navigationLabel = 'Files';

    public static function form(Form $form): Form
    {
        return $form->schema([
            \Filament\Forms\Components\TextInput::make('name')->required(),
            \Filament\Forms\Components\TextInput::make('path')->required(),
            \Filament\Forms\Components\TextInput::make('type'),
        ]);
    }

    public static function table(Table $table): Table
    {
        return $table->columns([
            \Filament\Tables\Columns\TextColumn::make('id'),
            \Filament\Tables\Columns\TextColumn::make('name'),
            \Filament\Tables\Columns\TextColumn::make('type'),
            \Filament\Tables\Columns\TextColumn::make('created_at')->dateTime(),
        ]);
    }
}
