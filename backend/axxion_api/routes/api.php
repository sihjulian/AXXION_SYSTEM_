<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\UsuarioController;

// Rutas públicas (sin autenticación)
Route::post('/login', [UsuarioController::class, 'login']);

// Rutas protegidas (requieren autenticación)
Route::middleware(['jwt.auth'])->group(function () {
    
    // Rutas para administradores
    Route::middleware(['check.role:ADMIN'])->group(function () {
        Route::post('/usuarios', [UsuarioController::class, 'store']);
        Route::delete('/usuario/{id}', [UsuarioController::class, 'destroy']);
    });
    
    // Rutas para usuarios autenticados (cualquier rol)
    Route::get('/usuarios', [UsuarioController::class, 'index']);
    Route::get('/usuario/{id}', [UsuarioController::class, 'show']);
    
    // Ruta de logout
    Route::post('/logout', [UsuarioController::class, 'logout']);
});
