<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\UsuarioController;

Route::get('/usuarios', [\App\Http\Controllers\Api\UsuarioController::class, 'index']);
Route::get('/usuario/{id}', [\App\Http\Controllers\Api\UsuarioController::class, 'show']);
Route::delete('/usuario/{id}', [\App\Http\Controllers\Api\UsuarioController::class, 'destroy']);
Route::post('/usuarios', [\App\Http\Controllers\Api\UsuarioController::class, 'store']);
