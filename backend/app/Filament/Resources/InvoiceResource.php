<?php
namespace App\Filament\Resources;

use Filament\Resources\Resource;
use Filament\Resources\Forms\Form;
use Filament\Resources\Tables\Table;
use App\Models\Invoice;

class InvoiceResource extends Resource
{
    protected static string $model = Invoice::class;
    protected static ?string $navigationIcon = 'heroicon-o-receipt-refund';
    protected static ?string $navigationGroup = 'Projects';
    protected static ?string $navigationLabel = 'Invoices';

    public static function form(Form $form): Form
    {
        return $form->schema([
            // Add invoice fields here
        ]);
    }

    public static function table(Table $table): Table
    {
        return $table->columns([
            // Add invoice columns here
        ]);
    }
}
