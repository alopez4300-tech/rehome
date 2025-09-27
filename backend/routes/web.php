<?php

use Illuminate\Support\Facades\Route;


use App\Http\Controllers\AuthController;

// Sanctum provides /sanctum/csrf-cookie automatically
Route::post('/login', [AuthController::class, 'login']);
Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');

Route::middleware(['auth:sanctum', 'ensure.role:admin'])->prefix('admin')->group(function () {
    // Filament admin panel
    Route::get('/', 'App\\Http\\Controllers\\AdminController@index');
    Route::resource('workspaces', 'App\\Http\\Controllers\\WorkspaceController');
    Route::resource('workspaces.projects', 'App\\Http\\Controllers\\ProjectController');
    Route::post('workspaces/{workspace}/assign', 'App\\Http\\Controllers\\WorkspaceController@assignUser');
});
