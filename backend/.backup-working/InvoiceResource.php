<?php
namespace App\Filament\Resources;

use Filament\Resources\Resource;
use Filament\Forms\Form;
use Filament\Tables\Table;
use App\Models\Invoice;

class InvoiceResource extends Resource
{
    protected static ?string $model = Invoice::class;
    protected static ?string $navigationIcon = 'heroicon-o-receipt-refund';
    protected static ?string $navigationGroup = 'Projects';
    protected static ?string $navigationLabel = 'Invoices';

    public static function form(Form $form): Form
    {
        return $form->schema([
            \Filament\Forms\Components\TextInput::make('number')->required(),
            \Filament\Forms\Components\TextInput::make('amount')->required(),
            \Filament\Forms\Components\TextInput::make('client_id')->required(),
        ]);
    }

    public static function table(Table $table): Table
    {
        return $table->columns([
            \Filament\Tables\Columns\TextColumn::make('id'),
            \Filament\Tables\Columns\TextColumn::make('number'),
            \Filament\Tables\Columns\TextColumn::make('amount'),
            \Filament\Tables\Columns\TextColumn::make('client_id'),
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
