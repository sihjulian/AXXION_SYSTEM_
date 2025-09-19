<?php

use App\Http\Controllers\Api\categoriaController;
use App\Http\Controllers\Api\clienteController;
use App\Http\Controllers\Api\subcategoriaController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\UsuarioController;
use App\Http\Controllers\Api\ProductoController;
use App\Http\Controllers\Api\rolController;
use App\Http\Controllers\Api\cotizacionController;
use App\Http\Controllers\Api\detalleCotizacionController;
use App\Http\Controllers\Api\devolucionController;
use App\Http\Controllers\Api\direccionController;
use App\Http\Controllers\Api\entregaController;

// ============================================
// RUTAS PÚBLICAS (sin autenticación)
// ============================================
Route::post('/login', [UsuarioController::class, 'login']);
Route::post('/usuarios', [UsuarioController::class, 'store']); // Registro de usuarios

// ============================================
// RUTAS PROTEGIDAS (requieren autenticación)
// ============================================
Route::middleware(['jwt.auth'])->group(function () {
    
    // Ruta de logout
    Route::post('/logout', [UsuarioController::class, 'logout']);
    
    // ============================================
    // GESTIÓN DE USUARIOS (requiere autenticación)
    // ============================================
    Route::get('/usuarios', [UsuarioController::class, 'index']);
    Route::get('/usuario/{id}', [UsuarioController::class, 'show']);
    Route::put('/usuario/{id}', [UsuarioController::class, 'update']);
    Route::patch('/usuario/{id}', [UsuarioController::class, 'update']);
    
    // Solo administradores pueden eliminar usuarios
    Route::middleware(['check.role:ADMIN'])->group(function () {
        Route::delete('/usuario/{id}', [UsuarioController::class, 'destroy']);
    });

    // ============================================
    // PRODUCTOS (requiere autenticación)
    // ============================================
    Route::get('/producto', [ProductoController::class, 'index']);
    Route::get('/producto/{id}', [ProductoController::class, 'show']);
    
    // Solo usuarios autenticados pueden crear/modificar productos
    Route::post('/producto', [ProductoController::class, 'store']);
    Route::put('/producto/{id}', [ProductoController::class, 'update']);
    Route::patch('/producto/{id}', [ProductoController::class, 'updatePartial']);
    
    // Solo administradores pueden eliminar productos
    Route::middleware(['check.role:ADMIN'])->group(function () {
        Route::delete('/producto/{id}', [ProductoController::class, 'destroy']);
    });

    // ============================================
    // ROLES (solo administradores)
    // ============================================
    Route::middleware(['check.role:ADMIN'])->group(function () {
        Route::get('/rol', [rolController::class, 'index']); 
        Route::post('/rol', [rolController::class, 'store']); 
        Route::get('/rol/{id}', [rolController::class, 'show']);
        Route::delete('/rol/{id}', [rolController::class, 'destroy']);
        Route::put('/rol/{id}', [rolController::class, 'update']);
        Route::patch('/rol/{id}', [rolController::class, 'updatePartial']);
    });

    // ============================================
    // CATEGORÍAS (requiere autenticación)
    // ============================================
    Route::get('/categoria', [categoriaController::class, 'index']);
    Route::get('/categoria/{id}', [categoriaController::class, 'show']);
    Route::post('/categoria', [categoriaController::class, 'store']);
    Route::put('/categoria/{id}', [categoriaController::class, 'update']);
    Route::patch('/categoria/{id}', [categoriaController::class, 'updatePartial']);
    
    // Solo administradores pueden eliminar categorías
    Route::middleware(['check.role:ADMIN'])->group(function () {
        Route::delete('/categoria/{id}', [categoriaController::class, 'destroy']);
    });

    // ============================================
    // SUBCATEGORÍAS (requiere autenticación)
    // ============================================
    Route::get('/subcategoria', [subcategoriaController::class, 'index']);
    Route::get('/subcategoria/{id}', [subcategoriaController::class, 'show']);
    Route::post('/subcategoria', [subcategoriaController::class, 'store']);
    Route::put('/subcategoria/{id}', [subcategoriaController::class, 'update']);
    Route::patch('/subcategoria/{id}', [subcategoriaController::class, 'updatePartial']);
    
    // Solo administradores pueden eliminar subcategorías
    Route::middleware(['check.role:ADMIN'])->group(function () {
        Route::delete('/subcategoria/{id}', [subcategoriaController::class, 'destroy']);
    });

    // ============================================
    // CLIENTES (requiere autenticación)
    // ============================================
    Route::get('/cliente', [clienteController::class, 'index']);
    Route::get('/cliente/{id}', [clienteController::class, 'show']);
    Route::post('/cliente', [clienteController::class, 'store']);
    Route::put('/cliente/{id}', [clienteController::class, 'update']);
    Route::patch('/cliente/{id}', [clienteController::class, 'updatePartial']);
    
    // Solo administradores pueden eliminar clientes
    Route::middleware(['check.role:ADMIN'])->group(function () {
        Route::delete('/cliente/{id}', [clienteController::class, 'destroy']);
    });

    // ============================================
    // COTIZACIONES (requiere autenticación)
    // ============================================
    Route::get('/cotizacion', [cotizacionController::class, 'index']);
    Route::get('/cotizacion/{id}', [cotizacionController::class, 'show']);
    Route::post('/cotizacion', [cotizacionController::class, 'store']);
    Route::put('/cotizacion/{id}', [cotizacionController::class, 'update']);
    Route::patch('/cotizacion/{id}', [cotizacionController::class, 'updatePartial']);
    
    // Solo administradores pueden eliminar cotizaciones
    Route::middleware(['check.role:ADMIN'])->group(function () {
        Route::delete('/cotizacion/{id}', [cotizacionController::class, 'destroy']);
    });

    // ============================================
    // DETALLE COTIZACIÓN (requiere autenticación)
    // ============================================
    Route::get('/detalleCotizacion', [detalleCotizacionController::class, 'index']);
    Route::get('/detalleCotizacion/{id}', [detalleCotizacionController::class, 'show']);
    Route::post('/detalleCotizacion', [detalleCotizacionController::class, 'store']);
    Route::put('/detalleCotizacion/{id}', [detalleCotizacionController::class, 'update']);
    Route::patch('/detalleCotizacion/{id}', [detalleCotizacionController::class, 'updatePartial']);
    
    // Solo administradores pueden eliminar detalles de cotización
    Route::middleware(['check.role:ADMIN'])->group(function () {
        Route::delete('/detalleCotizacion/{id}', [detalleCotizacionController::class, 'destroy']);
    });

    // ============================================
    // DEVOLUCIONES (requiere autenticación)
    // ============================================
    Route::get('/devolucion', [devolucionController::class, 'index']);
    Route::get('/devolucion/{id}', [devolucionController::class, 'show']);
    Route::post('/devolucion', [devolucionController::class, 'store']);
    Route::put('/devolucion/{id}', [devolucionController::class, 'update']);
    Route::patch('/devolucion/{id}', [devolucionController::class, 'updatePartial']);
    
    // Solo administradores pueden eliminar devoluciones
    Route::middleware(['check.role:ADMIN'])->group(function () {
        Route::delete('/devolucion/{id}', [devolucionController::class, 'destroy']);
    });

    // ============================================
    // DIRECCIONES (requiere autenticación)
    // ============================================
    Route::get('/direccion', [direccionController::class, 'index']);
    Route::get('/direccion/{id}', [direccionController::class, 'show']);
    Route::post('/direccion', [direccionController::class, 'store']);
    Route::put('/direccion/{id}', [direccionController::class, 'update']);
    Route::patch('/direccion/{id}', [direccionController::class, 'updatePartial']);
    
    // Solo administradores pueden eliminar direcciones
    Route::middleware(['check.role:ADMIN'])->group(function () {
        Route::delete('/direccion/{id}', [direccionController::class, 'destroy']);
    });

    // ============================================
    // ENTREGAS (requiere autenticación)
    // ============================================
    Route::get('/entrega', [entregaController::class, 'index']);
    Route::get('/entrega/{id}', [entregaController::class, 'show']);
    Route::post('/entrega', [entregaController::class, 'store']);
    Route::put('/entrega/{id}', [entregaController::class, 'update']);
    Route::patch('/entrega/{id}', [entregaController::class, 'updatePartial']);
    
    // Solo administradores pueden eliminar entregas
    Route::middleware(['check.role:ADMIN'])->group(function () {
        Route::delete('/entrega/{id}', [entregaController::class, 'destroy']);
    });

});

