<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user', fn (Request $r) => $r->user());
    Route::get('/ping', fn () => ['ok' => true]);
});

Route::get('/health', function () {
    return response()->json([
        'ok' => true,
        'app' => config('app.name'),
        'time' => now()->toISOString(),
        'env' => app()->environment(),
    ]);
});

Route::middleware(['auth:sanctum', 'ensure.role:team,consultant,client'])->prefix('app')->group(function () {
    Route::get('/workspaces/{workspace}/projects', 'App\\Http\\Controllers\\ProjectController@index')->middleware('scope.workspace');
    Route::get('/workspaces/{workspace}/projects/{project}', 'App\\Http\\Controllers\\ProjectController@show')->middleware('scope.workspace');
    Route::post('/workspaces/{workspace}/projects', 'App\\Http\\Controllers\\ProjectController@store')->middleware('scope.workspace');
    Route::put('/workspaces/{workspace}/projects/{project}', 'App\\Http\\Controllers\\ProjectController@update')->middleware('scope.workspace');
    Route::delete('/workspaces/{workspace}/projects/{project}', 'App\\Http\\Controllers\\ProjectController@destroy')->middleware('scope.workspace');

    Route::apiResource('workspaces.projects.tasks', 'App\\Http\\Controllers\\TaskController')->middleware('scope.workspace');
    Route::apiResource('workspaces.projects.files', 'App\\Http\\Controllers\\FileController')->middleware('scope.workspace');
    Route::apiResource('workspaces.projects.comments', 'App\\Http\\Controllers\\CommentController')->middleware('scope.workspace');
});
