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
use App\Http\Controllers\Api\MantenimientoController;

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
    Route::delete('/usuario/{id}', [UsuarioController::class, 'destroy'])->middleware('check.role:ADMIN');

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
    Route::delete('/producto/{id}', [ProductoController::class, 'destroy'])->middleware('check.role:ADMIN');

    // ============================================
    // ROLES (solo administradores)
    // ============================================
    Route::get('/rol', [rolController::class, 'index'])->middleware('check.role:ADMIN');
    Route::post('/rol', [rolController::class, 'store'])->middleware('check.role:ADMIN');
    Route::get('/rol/{id}', [rolController::class, 'show'])->middleware('check.role:ADMIN');
    Route::delete('/rol/{id}', [rolController::class, 'destroy'])->middleware('check.role:ADMIN');
    Route::put('/rol/{id}', [rolController::class, 'update'])->middleware('check.role:ADMIN');
    Route::patch('/rol/{id}', [rolController::class, 'updatePartial'])->middleware('check.role:ADMIN');

    // ============================================
    // CATEGORÍAS (requiere autenticación)
    // ============================================
    Route::get('/categoria', [categoriaController::class, 'index']);
    Route::get('/categoria/{id}', [categoriaController::class, 'show']);
    Route::post('/categoria', [categoriaController::class, 'store']);
    Route::put('/categoria/{id}', [categoriaController::class, 'update']);
    Route::patch('/categoria/{id}', [categoriaController::class, 'updatePartial']);
    
    // Solo administradores pueden eliminar categorías
    Route::delete('/categoria/{id}', [categoriaController::class, 'destroy'])->middleware('check.role:ADMIN');

    // ============================================
    // SUBCATEGORÍAS (requiere autenticación)
    // ============================================
    Route::get('/subcategoria', [subcategoriaController::class, 'index']);
    Route::get('/subcategoria/{id}', [subcategoriaController::class, 'show']);
    Route::post('/subcategoria', [subcategoriaController::class, 'store']);
    Route::put('/subcategoria/{id}', [subcategoriaController::class, 'update']);
    Route::patch('/subcategoria/{id}', [subcategoriaController::class, 'updatePartial']);
    
    // Solo administradores pueden eliminar subcategorías
    Route::delete('/subcategoria/{id}', [subcategoriaController::class, 'destroy'])->middleware('check.role:ADMIN');

    // ============================================
    // CLIENTES (requiere autenticación)
    // ============================================
    Route::get('/cliente', [clienteController::class, 'index']);
    Route::get('/cliente/{id}', [clienteController::class, 'show']);
    Route::post('/cliente', [clienteController::class, 'store']);
    Route::put('/cliente/{id}', [clienteController::class, 'update']);
    Route::patch('/cliente/{id}', [clienteController::class, 'updatePartial']);
    
    // Solo administradores pueden eliminar clientes
    Route::delete('/cliente/{id}', [clienteController::class, 'destroy'])->middleware('check.role:ADMIN');

    // ============================================
    // COTIZACIONES (requiere autenticación)
    // ============================================
    Route::get('/cotizacion', [cotizacionController::class, 'index']);
    Route::get('/cotizacion/{id}', [cotizacionController::class, 'show']);
    Route::post('/cotizacion', [cotizacionController::class, 'store']);
    Route::put('/cotizacion/{id}', [cotizacionController::class, 'update']);
    Route::patch('/cotizacion/{id}', [cotizacionController::class, 'updatePartial']);
    
    // Solo administradores pueden eliminar cotizaciones
    Route::delete('/cotizacion/{id}', [cotizacionController::class, 'destroy'])->middleware('check.role:ADMIN');

    // ============================================
    // DETALLE COTIZACIÓN (requiere autenticación)
    // ============================================
    Route::get('/detalleCotizacion', [detalleCotizacionController::class, 'index']);
    Route::get('/detalleCotizacion/{id}', [detalleCotizacionController::class, 'show']);
    Route::post('/detalleCotizacion', [detalleCotizacionController::class, 'store']);
    Route::put('/detalleCotizacion/{id}', [detalleCotizacionController::class, 'update']);
    Route::patch('/detalleCotizacion/{id}', [detalleCotizacionController::class, 'updatePartial']);
    
    // Solo administradores pueden eliminar detalles de cotización
    Route::delete('/detalleCotizacion/{id}', [detalleCotizacionController::class, 'destroy'])->middleware('check.role:ADMIN');

    // ============================================
    // DEVOLUCIONES (requiere autenticación)
    // ============================================
    Route::get('/devolucion', [devolucionController::class, 'index']);
    Route::get('/devolucion/{id}', [devolucionController::class, 'show']);
    Route::post('/devolucion', [devolucionController::class, 'store']);
    Route::put('/devolucion/{id}', [devolucionController::class, 'update']);
    Route::patch('/devolucion/{id}', [devolucionController::class, 'updatePartial']);
    
    // Solo administradores pueden eliminar devoluciones
    Route::delete('/devolucion/{id}', [devolucionController::class, 'destroy'])->middleware('check.role:ADMIN');

    // ============================================
    // DIRECCIONES (requiere autenticación)
    // ============================================
    Route::get('/direccion', [direccionController::class, 'index']);
    Route::get('/direccion/{id}', [direccionController::class, 'show']);
    Route::post('/direccion', [direccionController::class, 'store']);
    Route::put('/direccion/{id}', [direccionController::class, 'update']);
    Route::patch('/direccion/{id}', [direccionController::class, 'updatePartial']);
    
    // Solo administradores pueden eliminar direcciones
    Route::delete('/direccion/{id}', [direccionController::class, 'destroy'])->middleware('check.role:ADMIN');

    // ============================================
    // ENTREGAS (requiere autenticación)
    // ============================================
    Route::get('/entrega', [entregaController::class, 'index']);
    Route::get('/entrega/{id}', [entregaController::class, 'show']);
    Route::post('/entrega', [entregaController::class, 'store']);
    Route::put('/entrega/{id}', [entregaController::class, 'update']);
    Route::patch('/entrega/{id}', [entregaController::class, 'updatePartial']);
    
    // Solo administradores pueden eliminar entregas
    Route::delete('/entrega/{id}', [entregaController::class, 'destroy'])->middleware('check.role:ADMIN');

    // ============================================
    // MANTENIMIENTOS (requiere autenticación)
    // ============================================
    Route::get('/mantenimiento', [MantenimientoController::class, 'index']);
    Route::get('/mantenimiento/{id}', [MantenimientoController::class, 'show']);
    Route::post('/mantenimiento', [MantenimientoController::class, 'store']);
    Route::put('/mantenimiento/{id}', [MantenimientoController::class, 'update']);
    Route::patch('/mantenimiento/{id}', [MantenimientoController::class, 'updatePartial']);
    
    // Solo administradores pueden eliminar mantenimientos
    Route::delete('/mantenimiento/{id}', [MantenimientoController::class, 'destroy'])->middleware('check.role:ADMIN');

    // Rutas adicionales para mantenimientos
    Route::get('/mantenimiento/inventario/{inventario_item_id}', [MantenimientoController::class, 'getByInventarioItem']);
    Route::get('/mantenimiento/estado/{estado}', [MantenimientoController::class, 'getByEstado']);
    Route::get('/mantenimiento/tipo/{tipo}', [MantenimientoController::class, 'getByTipo']);

});

