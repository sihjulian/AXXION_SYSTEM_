<?php

namespace App\Http\Controllers\api;

use App\Http\Controllers\Controller;
use App\Models\Producto;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;

class ProductoController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        try {
            $productos = Producto::all();
            return response()->json($productos);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Error al obtener los productos: ' . $e->getMessage()], 500);
        }
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nombre' => 'required|string|max:255',
            'descripcion' => 'nullable|string',
            'marca' => 'nullable|string|max:255',
            'modelo' => 'nullable|string|max:255',
            'precio_referencia_renta' => 'nullable|numeric|min:0',
            'sku' => 'nullable|string|max:255|unique:producto,sku',
            'numero_serie' => 'nullable|string|max:100|unique:producto,numero_serie',
            'categoria' => 'nullable|string|max:50',
            'especificaciones' => 'nullable|array',
            'precio_alquiler_dia' => 'nullable|numeric|min:0',
            'precio_alquiler_semanal' => 'nullable|numeric|min:0',
            'precio_alquiler_mensual' => 'nullable|numeric|min:0',
            'precio_compra' => 'nullable|numeric|min:0',
            'valor_actual' => 'nullable|numeric|min:0',
            'fecha_compra' => 'nullable|date',
            'condicion' => 'nullable|string|max:50',
            'ubicacion' => 'nullable|string|max:255',
            'notas' => 'nullable|string',
            'estado' => 'nullable|string|max:50',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            $data = $request->all();
            // Agregar estado por defecto si no se proporciona
            if (!isset($data['estado'])) {
                $data['estado'] = 'disponible';
            }
            
            $producto = Producto::create($data);
            return response()->json($producto, 201);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Error al crear el producto: ' . $e->getMessage()], 500);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Producto $producto)
    {
        try {
            return response()->json($producto);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Error al obtener el producto: ' . $e->getMessage()], 500);
        }
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Producto $producto)
    {
        $validator = Validator::make($request->all(), [
            'nombre' => 'sometimes|required|string|max:255',
            'descripcion' => 'nullable|string',
            'marca' => 'nullable|string|max:255',
            'modelo' => 'nullable|string|max:255',
            'precio_referencia_renta' => 'nullable|numeric|min:0',
            'sku' => 'nullable|string|max:255|unique:producto,sku,' . $producto->id,
            'numero_serie' => 'nullable|string|max:100|unique:producto,numero_serie,' . $producto->id,
            'categoria' => 'nullable|string|max:50',
            'especificaciones' => 'nullable|array',
            'precio_alquiler_dia' => 'nullable|numeric|min:0',
            'precio_alquiler_semanal' => 'nullable|numeric|min:0',
            'precio_alquiler_mensual' => 'nullable|numeric|min:0',
            'precio_compra' => 'nullable|numeric|min:0',
            'valor_actual' => 'nullable|numeric|min:0',
            'fecha_compra' => 'nullable|date',
            'condicion' => 'nullable|string|max:50',
            'ubicacion' => 'nullable|string|max:255',
            'notas' => 'nullable|string',
            'estado' => 'nullable|string|max:50',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            $producto->update($request->all());
            return response()->json($producto);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Error al actualizar el producto: ' . $e->getMessage()], 500);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        try {
            // Buscar el producto por ID
            $producto = Producto::find($id);
            
            if (!$producto) {
                return response()->json(['error' => 'Producto no encontrado'], 404);
            }
            
            // Log para debugging
            \Log::info('Intentando eliminar producto ID: ' . $id . ', Nombre: ' . $producto->nombre);
            
            // Eliminar directamente con query builder
            $deleted = DB::table('producto')->where('id', $id)->delete();
            
            \Log::info('Filas eliminadas: ' . $deleted);
            
            if ($deleted > 0) {
                return response()->json([
                    'message' => 'Producto eliminado exitosamente',
                    'deleted_id' => $id
                ], 200);
            } else {
                return response()->json(['error' => 'No se pudo eliminar el producto'], 500);
            }
            
        } catch (\Exception $e) {
            \Log::error('Error al eliminar producto: ' . $e->getMessage());
            \Log::error('Stack trace: ' . $e->getTraceAsString());
            return response()->json([
                'error' => 'Error al eliminar el producto: ' . $e->getMessage()
            ], 500);
        }
    }
}
