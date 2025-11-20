<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\InventarioItem;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;

class InventarioItemController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        try {
            $inventarioItems = InventarioItem::with('producto', 'mantenimientos', 'rentas')->get();
            return response()->json([
                'inventario_items' => $inventarioItems,
                'status' => 200
            ], 200);
        } catch (\Exception $e) {
            Log::error('Error al obtener inventario items: ' . $e->getMessage());
            return response()->json([
                'error' => 'Error al obtener los items de inventario: ' . $e->getMessage(),
                'status' => 500
            ], 500);
        }
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'producto_id' => ['required', Rule::exists('producto', 'id')],
                'numero_serie' => ['nullable', 'string', 'max:100', 'unique:inventario_item,numero_serie'],
                'estado_item' => ['required', 'string', Rule::in(['Disponible', 'Rentado', 'EnMantenimiento', 'DeBaja'])],
                'fecha_adquisicion' => ['nullable', 'date'],
                'costo_adquisicion' => ['nullable', 'numeric', 'min:0'],
                'ubicacion_fisica' => ['nullable', 'string', 'max:100'],
                'notas' => ['nullable', 'string'],
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'message' => 'Validation failed',
                    'errors' => $validator->errors(),
                    'status' => 400
                ], 400);
            }

            DB::beginTransaction();

            $inventarioItem = InventarioItem::create($request->all());
            $inventarioItem->load('producto');

            DB::commit();

            return response()->json([
                'message' => 'Item de inventario creado exitosamente',
                'inventario_item' => $inventarioItem,
                'status' => 201
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Error al crear inventario item: ' . $e->getMessage());
            return response()->json([
                'error' => 'Error interno al crear el item de inventario: ' . $e->getMessage(),
                'status' => 500
            ], 500);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        try {
            $inventarioItem = InventarioItem::with('producto', 'mantenimientos', 'rentas')->find($id);

            if (!$inventarioItem) {
                return response()->json([
                    'message' => 'Item de inventario no encontrado',
                    'status' => 404
                ], 404);
            }

            return response()->json([
                'inventario_item' => $inventarioItem,
                'status' => 200
            ], 200);

        } catch (\Exception $e) {
            Log::error('Error al obtener inventario item: ' . $e->getMessage());
            return response()->json([
                'error' => 'Error al obtener el item de inventario: ' . $e->getMessage(),
                'status' => 500
            ], 500);
        }
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        try {
            $inventarioItem = InventarioItem::find($id);

            if (!$inventarioItem) {
                return response()->json([
                    'message' => 'Item de inventario no encontrado',
                    'status' => 404
                ], 404);
            }

            $validator = Validator::make($request->all(), [
                'producto_id' => ['sometimes', 'required', Rule::exists('producto', 'id')],
                'numero_serie' => ['nullable', 'string', 'max:100', Rule::unique('inventario_item', 'numero_serie')->ignore($id)],
                'estado_item' => ['sometimes', 'required', 'string', Rule::in(['Disponible', 'Rentado', 'EnMantenimiento', 'DeBaja'])],
                'fecha_adquisicion' => ['nullable', 'date'],
                'costo_adquisicion' => ['nullable', 'numeric', 'min:0'],
                'ubicacion_fisica' => ['nullable', 'string', 'max:100'],
                'notas' => ['nullable', 'string'],
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'message' => 'Validation failed',
                    'errors' => $validator->errors(),
                    'status' => 400
                ], 400);
            }

            DB::beginTransaction();

            $inventarioItem->update($request->all());
            $inventarioItem->load('producto');

            DB::commit();

            return response()->json([
                'message' => 'Item de inventario actualizado exitosamente',
                'inventario_item' => $inventarioItem,
                'status' => 200
            ], 200);

        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Error al actualizar inventario item: ' . $e->getMessage());
            return response()->json([
                'error' => 'Error interno al actualizar el item de inventario: ' . $e->getMessage(),
                'status' => 500
            ], 500);
        }
    }

    /**
     * Update partial resource in storage.
     */
    public function updatePartial(Request $request, $id)
    {
        try {
            $inventarioItem = InventarioItem::find($id);

            if (!$inventarioItem) {
                return response()->json([
                    'message' => 'Item de inventario no encontrado',
                    'status' => 404
                ], 404);
            }

            $validator = Validator::make($request->all(), [
                'producto_id' => ['sometimes', Rule::exists('producto', 'id')],
                'numero_serie' => ['nullable', 'string', 'max:100', Rule::unique('inventario_item', 'numero_serie')->ignore($id)],
                'estado_item' => ['sometimes', 'string', Rule::in(['Disponible', 'Rentado', 'EnMantenimiento', 'DeBaja'])],
                'fecha_adquisicion' => ['nullable', 'date'],
                'costo_adquisicion' => ['nullable', 'numeric', 'min:0'],
                'ubicacion_fisica' => ['nullable', 'string', 'max:100'],
                'notas' => ['nullable', 'string'],
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'message' => 'Validation failed',
                    'errors' => $validator->errors(),
                    'status' => 400
                ], 400);
            }

            DB::beginTransaction();

            $inventarioItem->update($request->only(array_keys($request->all())));
            $inventarioItem->load('producto');

            DB::commit();

            return response()->json([
                'message' => 'Item de inventario actualizado parcialmente',
                'inventario_item' => $inventarioItem,
                'status' => 200
            ], 200);

        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Error al actualizar inventario item: ' . $e->getMessage());
            return response()->json([
                'error' => 'Error interno al actualizar el item de inventario: ' . $e->getMessage(),
                'status' => 500
            ], 500);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        try {
            $inventarioItem = InventarioItem::find($id);

            if (!$inventarioItem) {
                return response()->json([
                    'message' => 'Item de inventario no encontrado',
                    'status' => 404
                ], 404);
            }

            DB::beginTransaction();

            $inventarioItem->delete();

            DB::commit();

            return response()->json([
                'message' => 'Item de inventario eliminado exitosamente',
                'status' => 200
            ], 200);

        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Error al eliminar inventario item: ' . $e->getMessage());
            return response()->json([
                'error' => 'Error interno al eliminar el item de inventario: ' . $e->getMessage(),
                'status' => 500
            ], 500);
        }
    }

    /**
     * Get inventario items by producto
     */
    public function getByProducto($producto_id)
    {
        try {
            $inventarioItems = InventarioItem::where('producto_id', $producto_id)
                ->with('producto', 'mantenimientos', 'rentas')
                ->orderBy('created_at', 'desc')
                ->get();

            return response()->json([
                'inventario_items' => $inventarioItems,
                'status' => 200
            ], 200);

        } catch (\Exception $e) {
            Log::error('Error al obtener inventario items por producto: ' . $e->getMessage());
            return response()->json([
                'error' => 'Error al obtener los items de inventario del producto: ' . $e->getMessage(),
                'status' => 500
            ], 500);
        }
    }

    /**
     * Get inventario items by estado
     */
    public function getByEstado($estado)
    {
        try {
            $estados_validos = ['Disponible', 'Rentado', 'EnMantenimiento', 'DeBaja'];
            
            if (!in_array($estado, $estados_validos)) {
                return response()->json([
                    'error' => 'Estado no válido',
                    'status' => 400
                ], 400);
            }

            $inventarioItems = InventarioItem::where('estado_item', $estado)
                ->with('producto', 'mantenimientos', 'rentas')
                ->orderBy('created_at', 'desc')
                ->get();

            return response()->json([
                'inventario_items' => $inventarioItems,
                'status' => 200
            ], 200);

        } catch (\Exception $e) {
            Log::error('Error al obtener inventario items por estado: ' . $e->getMessage());
            return response()->json([
                'error' => 'Error al obtener los items de inventario por estado: ' . $e->getMessage(),
                'status' => 500
            ], 500);
        }
    }
}
