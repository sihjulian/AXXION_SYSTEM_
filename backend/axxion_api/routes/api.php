<?php

use App\Http\Controllers\Api\categoriaController;
use App\Http\Controllers\Api\clienteController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\UsuarioController;
use App\Http\Controllers\Api\rolController;
use App\Http\Controllers\Api\cotizacionController;
use App\Http\Controllers\Api\detalleCotizacionController;
use App\Http\Controllers\Api\devolucionController;
use App\Http\Controllers\Api\direccionController;

use App\Http\Controllers\Api\entregaController;

// Rutas públicas (sin autenticación)
Route::post('/usuarios', [UsuarioController::class, 'store']);

Route::post('/login',    [UsuarioController::class, 'login']);
Route::get('/usuarios',  [UsuarioController::class, 'index']);
Route::delete('/usuario/{id}', [UsuarioController::class, 'destroy']);
Route::get('/usuario/{id}', [UsuarioController::class, 'show']);

    // Rutas para actualizar usuario
    Route::put('/usuario/{id}', [UsuarioController::class, 'update']);
    Route::patch('/usuario/{id}', [UsuarioController::class, 'update']);
    
// Rutas protegidas (requieren autenticación)
Route::middleware(['jwt.auth'])->group(function () {
    
    // Rutas para administradores
    Route::middleware(['check.role:ADMIN'])->group(function () {

    });
    // Ruta de logout
    Route::post('/logout', [UsuarioController::class, 'logout']);
});




// ROLES

Route::get('/rol', [rolController::class, 'index']); 
Route::post('/rol', [rolController::class, 'store']); 
Route::get('/rol/{id}', [rolController::class, 'show']);
Route::delete('/rol/{id}', [rolController::class, 'destroy']);
Route::put('/rol/{id}', [rolController::class, 'update']);
Route::patch('/rol/{id}', [rolController::class, 'updatePartial']);

// CATEGORIA

Route::get('/categoria', [categoriaController::class, 'index']);
Route::post('/categoria', [categoriaController::class, 'store']);
Route::get('/categoria/{id}', [categoriaController::class, 'show']);
Route::delete('/categoria/{id}', [categoriaController::class, 'destroy']);
Route::put('/categoria/{id}', [categoriaController::class, 'update']);
Route::patch('/categoria/{id}', [categoriaController::class, 'updatePartial']);

// CLIENTE  

Route::get('/cliente', [clienteController::class, 'index']);
Route::post('/cliente', [clienteController::class, 'store']);
Route::get('/cliente/{id}', [clienteController::class, 'show']);
Route::delete('/cliente/{id}', [clienteController::class, 'destroy']);
Route::put('/cliente/{id}', [clienteController::class, 'update']);
Route::patch('/cliente/{id}', [clienteController::class, 'updatePartial']);

// COTIZACION

Route::get('/cotizacion', [cotizacionController::class, 'index']);
Route::post('/cotizacion', [cotizacionController::class, 'store']);
Route::get('/cotizacion/{id}', [cotizacionController::class, 'show']);
Route::delete('/cotizacion/{id}', [cotizacionController::class, 'destroy']);
Route::put('/cotizacion/{id}', [cotizacionController::class, 'update']);
Route::patch('/cotizacion/{id}', [cotizacionController::class, 'updatePartial']);

// DETALLECOTIZACION

Route::get('/detalleCotizacion', [detalleCotizacionController::class, 'index']);
Route::post('/detalleCotizacion', [detalleCotizacionController::class, 'store']);
Route::get('/detalleCotizacion/{id}', [detalleCotizacionController::class, 'show']);
Route::delete('/detalleCotizacion/{id}', [detalleCotizacionController::class, 'destroy']);
Route::put('/detalleCotizacion/{id}', [detalleCotizacionController::class, 'update']);
Route::patch('/detalleCotizacion/{id}', [detalleCotizacionController::class, 'updatePartial']);

// DEVOLUCION

Route::get('/devolucion', [devolucionController::class, 'index']);
Route::post('/devolucion', [devolucionController::class, 'store']);
Route::get('/devolucion/{id}', [devolucionController::class, 'show']);
Route::delete('/devolucion/{id}', [devolucionController::class, 'destroy']);
Route::put('/devolucion/{id}', [devolucionController::class, 'update']);
Route::patch('/devolucion/{id}', [devolucionController::class, 'updatePartial']);

// DIRECCION

Route::get('/direccion', [direccionController::class, 'index']);
Route::post('/direccion', [direccionController::class, 'store']);
Route::get('/direccion/{id}', [direccionController::class, 'show']);
Route::delete('/direccion/{id}', [direccionController::class, 'destroy']);
Route::put('/direccion/{id}', [direccionController::class, 'update']);
Route::patch('/direccion/{id}', [direccionController::class, 'updatePartial']);


// ENTREGA

Route::get('/entrega', [entregaController::class, 'index']);
Route::post('/entrega', [entregaController::class, 'store']);
Route::get('/entrega/{id}', [entregaController::class, 'show']);
Route::delete('/entrega/{id}', [entregaController::class, 'destroy']);
Route::put('/entrega/{id}', [entregaController::class, 'update']);
Route::patch('/entrega/{id}', [entregaController::class, 'updatePartial']);