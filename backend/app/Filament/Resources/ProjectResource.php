<?php
namespace App\Filament\Resources;

use Filament\Resources\Resource;
use Filament\Forms\Form;
use Filament\Tables\Table;
use App\Models\Project;

class ProjectResource extends Resource
{
    protected static ?string $model = Project::class;
    protected static ?string $navigationIcon = 'heroicon-o-briefcase';
    protected static ?string $navigationGroup = 'Projects';
    protected static ?string $navigationLabel = 'Projects';

    public static function form(Form $form): Form
    {
        return $form->schema([
            \Filament\Forms\Components\TextInput::make('name')->required(),
            \Filament\Forms\Components\Textarea::make('description'),
            \Filament\Forms\Components\Select::make('status')
                ->options([
                    'in_progress' => 'In Progress',
                    'paused' => 'Paused',
                    'completed' => 'Completed',
                    'archived' => 'Archived',
                ])->required(),
        ]);
    }

    public static function table(Table $table): Table
    {
        return $table->columns([
            \Filament\Tables\Columns\TextColumn::make('id'),
            \Filament\Tables\Columns\TextColumn::make('name'),
            \Filament\Tables\Columns\TextColumn::make('status')->badge(),
            \Filament\Tables\Columns\TextColumn::make('created_at')->dateTime(),
        ])
        ->defaultSort('status')
        ->groupBy('status');
    }
}
