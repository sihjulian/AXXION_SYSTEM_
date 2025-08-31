<?php

use Illuminate\Support\Facades\Route;
use app\Http\Controllers\Api\UsuarioController;
use App\Http\Controllers\Api\rolController;

// USUARIOS

Route::get('/usuarios', [UsuarioController::class, 'index']);
Route::get('/usuario/{id}', [UsuarioController::class, 'show']);
Route::delete('/usuario/{id}', [UsuarioController::class, 'destroy']);
Route::post('/usuarios', [UsuarioController::class, 'store']);

// ROLES

Route::get('/rol', [rolController::class, 'index']); 
Route::post('/rol', [rolController::class, 'store']); 
Route::get('/rol/{id}', [rolController::class, 'show']);
Route::delete('/rol/{id}', [rolController::class, 'destroy']);
Route::put('/rol/{id}', [rolController::class, 'update']);
Route::patch('/rol/{id}', [rolController::class, 'updatePartial']);