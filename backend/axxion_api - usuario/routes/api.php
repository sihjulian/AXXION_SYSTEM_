<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\UsuarioController;
use App\Http\Controllers\Api\rolController;

// ============================================
// RUTAS PÚBLICAS (sin autenticación)
// ============================================
Route::post('/login', [UsuarioController::class, 'login']);
Route::post('/usuarios', [UsuarioController::class, 'store']); // Registro de usuarios
Route::get('/usuarios', [UsuarioController::class, 'index']);

// ============================================
// RUTAS PROTEGIDAS (requieren autenticación)
// ============================================
Route::middleware(['jwt.auth'])->group(function () {
    
    // Ruta de logout
    Route::post('/logout', [UsuarioController::class, 'logout']);
    
    // ============================================
    // GESTIÓN DE USUARIOS (requiere autenticación)
    // ============================================
    // Route::get('/usuarios', [UsuarioController::class, 'index']);
    Route::get('/usuario/{id}', [UsuarioController::class, 'show']);
    Route::put('/usuario/{id}', [UsuarioController::class, 'update']);
    Route::patch('/usuario/{id}', [UsuarioController::class, 'update']);
    
    // Solo administradores pueden eliminar usuarios
    Route::delete('/usuario/{id}', [UsuarioController::class, 'destroy'])->middleware('check.role:ADMIN');

    // ============================================
    // ROLES (solo administradores)
    // ============================================
    Route::get('/rol', [rolController::class, 'index'])->middleware('check.role:ADMIN');
    Route::post('/rol', [rolController::class, 'store'])->middleware('check.role:ADMIN');
    Route::get('/rol/{id}', [rolController::class, 'show'])->middleware('check.role:ADMIN');
    Route::delete('/rol/{id}', [rolController::class, 'destroy'])->middleware('check.role:ADMIN');
    Route::put('/rol/{id}', [rolController::class, 'update'])->middleware('check.role:ADMIN');
    Route::patch('/rol/{id}', [rolController::class, 'updatePartial'])->middleware('check.role:ADMIN');

});
