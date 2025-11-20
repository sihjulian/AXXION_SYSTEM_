<?php

namespace App\Http\Controllers\api;

use App\Http\Controllers\Controller;
use App\Models\Mantenimiento;
use App\Models\InventarioItem;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;

class MantenimientoController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        try {
            $mantenimientos = Mantenimiento::with('inventarioItem')->get();
            return response()->json($mantenimientos);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Error al obtener los mantenimientos: ' . $e->getMessage()], 500);
        }
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'inventario_item_id' => 'required|exists:inventario_item,id',
            'fecha_inicio' => 'required|date',
            'fecha_fin_prevista' => 'required|date|after_or_equal:fecha_inicio',
            'fecha_fin_real' => 'nullable|date',
            'tipo_mantenimiento' => 'required|string|in:PREVENTIVO,CORRECTIVO,PREDICTIVO,EMERGENCIA',
            'descripcion_problema' => 'required|string|max:1000',
            'descripcion_trabajo_realizado' => 'nullable|string|max:1000',
            'costo_estimado' => 'nullable|numeric|min:0',
            'costo_real' => 'nullable|numeric|min:0',
            'estado_mantenimiento' => 'required|string|in:PROGRAMADO,EN_PROCESO,COMPLETADO,CANCELADO,PAUSADO',
            'responsable' => 'required|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'error' => 'Datos de validación incorrectos',
                'messages' => $validator->errors()
            ], 422);
        }

        try {
            DB::beginTransaction();

            $mantenimiento = Mantenimiento::create($request->all());
            $mantenimiento->load('inventarioItem');

            DB::commit();

            return response()->json([
                'message' => 'Mantenimiento creado exitosamente',
                'mantenimiento' => $mantenimiento
            ], 201);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'error' => 'Error al crear el mantenimiento: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        try {
            $mantenimiento = Mantenimiento::with('inventarioItem')->find($id);
            if (!$mantenimiento) {
                return response()->json(['error' => 'Mantenimiento no encontrado'], 404);
            }

            return response()->json($mantenimiento);

        } catch (\Exception $e) {
            return response()->json(['error' => 'Error al obtener el mantenimiento: ' . $e->getMessage()], 500);
        }
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'inventario_item_id' => 'sometimes|required|exists:inventario_item,id',
            'fecha_inicio' => 'sometimes|required|date',
            'fecha_fin_prevista' => 'sometimes|required|date|after_or_equal:fecha_inicio',
            'fecha_fin_real' => 'nullable|date',
            'tipo_mantenimiento' => 'sometimes|required|string|in:PREVENTIVO,CORRECTIVO,PREDICTIVO,EMERGENCIA',
            'descripcion_problema' => 'sometimes|required|string|max:1000',
            'descripcion_trabajo_realizado' => 'nullable|string|max:1000',
            'costo_estimado' => 'nullable|numeric|min:0',
            'costo_real' => 'nullable|numeric|min:0',
            'estado_mantenimiento' => 'sometimes|required|string|in:PROGRAMADO,EN_PROCESO,COMPLETADO,CANCELADO,PAUSADO',
            'responsable' => 'sometimes|required|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'error' => 'Datos de validación incorrectos',
                'messages' => $validator->errors()
            ], 422);
        }

        try {
            $mantenimiento = Mantenimiento::find($id);

            if (!$mantenimiento) {
                return response()->json(['error' => 'Mantenimiento no encontrado'], 404);
            }

            DB::beginTransaction();

            $mantenimiento->update($request->all());
            $mantenimiento->load('inventarioItem');

            DB::commit();

            return response()->json([
                'message' => 'Mantenimiento actualizado exitosamente',
                'mantenimiento' => $mantenimiento
            ]);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'error' => 'Error al actualizar el mantenimiento: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update partial resource in storage.
     */
    public function updatePartial(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'inventario_item_id' => 'sometimes|exists:inventario_item,id',
            'fecha_inicio' => 'sometimes|date',
            'fecha_fin_prevista' => 'sometimes|date',
            'fecha_fin_real' => 'nullable|date',
            'tipo_mantenimiento' => 'sometimes|string|in:PREVENTIVO,CORRECTIVO,PREDICTIVO,EMERGENCIA',
            'descripcion_problema' => 'sometimes|string|max:1000',
            'descripcion_trabajo_realizado' => 'nullable|string|max:1000',
            'costo_estimado' => 'nullable|numeric|min:0',
            'costo_real' => 'nullable|numeric|min:0',
            'estado_mantenimiento' => 'sometimes|string|in:PROGRAMADO,EN_PROCESO,COMPLETADO,CANCELADO,PAUSADO',
            'responsable' => 'sometimes|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'error' => 'Datos de validación incorrectos',
                'messages' => $validator->errors()
            ], 422);
        }

        try {
            $mantenimiento = Mantenimiento::find($id);

            if (!$mantenimiento) {
                return response()->json(['error' => 'Mantenimiento no encontrado'], 404);
            }

            DB::beginTransaction();

            $mantenimiento->update($request->only(array_keys($request->all())));
            $mantenimiento->load('inventarioItem');

            DB::commit();

            return response()->json([
                'message' => 'Mantenimiento actualizado parcialmente',
                'mantenimiento' => $mantenimiento
            ]);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'error' => 'Error al actualizar el mantenimiento: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        try {
            $mantenimiento = Mantenimiento::find($id);

            if (!$mantenimiento) {
                return response()->json(['error' => 'Mantenimiento no encontrado'], 404);
            }

            DB::beginTransaction();

            $mantenimiento->delete();

            DB::commit();

            return response()->json([
                'message' => 'Mantenimiento eliminado exitosamente'
            ]);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'error' => 'Error al eliminar el mantenimiento: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get mantenimientos by inventario item
     */
    public function getByInventarioItem($inventario_item_id)
    {
        try {
            $mantenimientos = Mantenimiento::where('inventario_item_id', $inventario_item_id)
                ->with('inventarioItem')
                ->orderBy('fecha_inicio', 'desc')
                ->get();

            return response()->json($mantenimientos);

        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Error al obtener los mantenimientos del item: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get mantenimientos by estado
     */
    public function getByEstado($estado)
    {
        try {
            $estados_validos = ['PROGRAMADO', 'EN_PROCESO', 'COMPLETADO', 'CANCELADO', 'PAUSADO'];
            
            if (!in_array(strtoupper($estado), $estados_validos)) {
                return response()->json(['error' => 'Estado no válido'], 400);
            }

            $mantenimientos = Mantenimiento::where('estado_mantenimiento', strtoupper($estado))
                ->with('inventarioItem')
                ->orderBy('fecha_inicio', 'desc')
                ->get();

            return response()->json($mantenimientos);

        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Error al obtener los mantenimientos por estado: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get mantenimientos by tipo
     */
    public function getByTipo($tipo)
    {
        try {
            $tipos_validos = ['PREVENTIVO', 'CORRECTIVO', 'PREDICTIVO', 'EMERGENCIA'];
            
            if (!in_array(strtoupper($tipo), $tipos_validos)) {
                return response()->json(['error' => 'Tipo de mantenimiento no válido'], 400);
            }

            $mantenimientos = Mantenimiento::where('tipo_mantenimiento', strtoupper($tipo))
                ->with('inventarioItem')
                ->orderBy('fecha_inicio', 'desc')
                ->get();

            return response()->json($mantenimientos);

        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Error al obtener los mantenimientos por tipo: ' . $e->getMessage()
            ], 500);
        }
    }
}
