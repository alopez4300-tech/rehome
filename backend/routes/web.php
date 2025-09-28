<?php

use Illuminate\Support\Facades\Route;

use App\Http\Controllers\AuthController;

// Default route
Route::get('/', function () {
    return response()->json([
        'app' => 'Rehome API',
        'version' => '1.0',
        'endpoints' => [
            'GET /login' => 'Login page info',
            'POST /login' => 'Authenticate user',
            'GET /api/health' => 'Health check',
            'GET /sanctum/csrf-cookie' => 'CSRF token'
        ]
    ]);
});

// Sanctum provides /sanctum/csrf-cookie automatically
Route::post('/login', [AuthController::class, 'login']);
Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');

// Filament admin panel routes are handled automatically by FilamentServiceProvider
// No manual admin routes needed - Filament will register /admin, /admin/login, etc.
