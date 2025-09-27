<?php

use Illuminate\Support\Facades\Route;


use App\Http\Controllers\AuthController;

// Sanctum provides /sanctum/csrf-cookie automatically
Route::post('/login', [AuthController::class, 'login']);
Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');
