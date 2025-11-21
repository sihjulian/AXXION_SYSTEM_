<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Renta;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;

class RentaController extends Controller
{
    public function index() 
    {
        try {
            $renta = Renta::with('cliente', 'cotizacion', 'inventarioItems', 'entrega', 'devolucion')->get();
            $data = [
                'renta' => $renta,
                'status' => 200
            ];
            return response()->json($data, 200);
        } catch (\Exception $e) {
                Log::error('Error al listar Rentas: ' . $e->getMessage());
                return response()->json([
                    'error' => $e->getMessage(),
                    'status' => 500
                ], 500);
            }
    }
    public function store(Request $request) 
    {
        try {
            $validator = Validator::make($request->all(), [
                'cliente_id' => ['required', Rule::exists('cliente', 'id')],
                'cotizacion_id' => ['nullable', Rule::exists('cotizacion', 'id')],
                'fecha_inicio'=> ['required', 'date'],
                'fecha_fin_prevista' => ['required', 'date'],
                'fecha_devolucion_real' => ['nullable', 'date'],
                'estado_renta' => ['required', 'string', Rule::in(['Programada','EnCurso','Finalizada','Retrasada','Cancelada'])],
                'monto_total_renta' => ['required', 'numeric'],
                'deposito_garantia' => ['required', 'numeric'],
                'notas' => ['nullable', 'string'],
                'inventarioItems' => ['array'],
                'entrega' => ['array'],
                'devolucion' => ['array'],
            ]);
            if ($validator->fails()){
                $data = [
                    'message' => 'Validation failed',
                    'errors' => $validator->errors(),
                    'status' => 422
                ];
                return response()->json($data, 422);
            }
            $renta = Renta::create([
                'cliente_id' => $request->cliente_id,
                'cotizacion_id' => $request->cotizacion_id,
                'fecha_inicio' => $request->fecha_inicio,
                'fecha_fin_prevista' => $request->fecha_fin_prevista,
                'fecha_devolucion_real' => $request->fecha_devolucion_real,
                'estado_renta' => $request->estado_renta,
                'monto_total_renta' => $request->monto_total_renta,
                'deposito_garantia' => $request->deposito_garantia,
                'notas' => $request->notas
            ]);
            if (!$renta){
                $data = [
                    'message' => 'Error al crear renta',
                    'status' => 500
                ];
                return response()->json($data, 500);
            }
            $renta->load('cliente', 'cotizacion');
            $data = [
                'renta' => $renta,
                'status' => 200
            ];
            return response()->json($data, 200);
        } catch (\Exception $e) {
                Log::error('Error al crear Renta: ' . $e->getMessage());
                return response()->json([
                    'error' => $e->getMessage(),
                    'status' => 500
                ], 500);
            }
    }
    public function show($id)
    {
        try {
                $renta = Renta::with('cliente', 'cotizacion', 'inventarioItems', 'entrega', 'devolucion')->find($id);
                if (!$renta) {
                    $data = [
                        'message' => 'Renta no encontrada',
                        'status' => 404
                    ];
                    return response()->json($data, 404);
                }
                $data = [
                    'renta' => $renta,
                    'status' => 200
                ];
                return response()->json($data, 200);
            } catch (\Exception $e) {
                Log::error('Error al consultar Renta: ' . $e->getMessage());
                return response()->json([
                    'error' => $e->getMessage(),
                    'status' => 500
                ], 500);
            }
    }
    public function destroy($id)
    {
        try {
            $renta = Renta::with('cliente', 'cotizacion', 'inventarioItems', 'entrega', 'devolucion')->find($id);
            if (!$renta){
                $data = [
                    'message' => 'Renta no encontrada',
                    'status' => 404
                ];
                return response()->json($data, 404);
            }
            DB::transaction(function () use ($renta) {
                $renta->inventarioItems()->detach();
                if ($renta->entrega) {
                    $renta->entrega()->delete();
                }
                if ($renta->devolucion) {
                    $renta->devolucion()->delete();
                }
                $renta->delete();
            });
            $data = [
                'renta' => $renta,
                'status' => 200
            ];
            return response()->json($data, 200);
        } catch (\Exception $e) {
                Log::error('Error al eliminar Renta: ' . $e->getMessage());
                return response()->json([
                    'error' => $e->getMessage(),
                    'status' => 500
                ], 500);
        }
    }
    public function update(Request $request, $id) 
    {
        try {
            $renta = Renta::with('cliente', 'cotizacion', 'inventarioItems', 'entrega', 'devolucion')->find($id);
            if (!$renta){
                $data = [
                    'message' => 'Renta no encontrada',
                    'status' => 404
                ];
                return response()->json($data, 404);
            }
            $validator = Validator::make($request->all(), [
                'cliente_id' => ['required', Rule::exists('cliente', 'id')],
                'cotizacion_id' => ['nullable', Rule::exists('cotizacion', 'id')],
                'fecha_inicio'=> ['required', 'date'],
                'fecha_fin_prevista' => ['required', 'date'],
                'fecha_devolucion_real' => ['nullable', 'date'],
                'estado_renta' => ['required', 'string', Rule::in(['Programada','EnCurso','Finalizada','Retrasada','Cancelada'])],
                'monto_total_renta' => ['required', 'numeric'],
                'deposito_garantia' => ['required', 'numeric'],
                'notas' => ['nullable', 'string'],
                'inventarioItems' => ['array'],
                'entrega' => ['array'],
                'devolucion' => ['array'],
            ]);
            if ($validator->fails()){
                $data = [
                    'message' => 'Validation failed',
                    'errors' => $validator->errors(),
                    'status' => 422
                ];
                return response()->json($data, 422);
            }
            $renta->cliente_id = $request->cliente_id;
            $renta->cotizacion_id = $request->cotizacion_id;
            $renta->fecha_inicio = $request->fecha_inicio;
            $renta->fecha_fin_prevista = $request->fecha_fin_prevista;
            $renta->fecha_devolucion_real = $request->fecha_devolucion_real;
            $renta->estado_renta = $request->estado_renta;
            $renta->monto_total_renta = $request->monto_total_renta;
            $renta->deposito_garantia = $request->deposito_garantia;
            $renta->notas = $request->notas;
            if($request->has('inventarioItems')){
                $renta->inventarioItems()->sync($request->inventarioItems);
            }
            if($request->has('entrega')){
                $entregaData = $request->input('entrega');
                // Si existe entrega relacionada, actualizar; si no, crear y asociar
                if ($renta->entrega) {
                    $renta->entrega()->update($entregaData);
                } else {
                    $renta->entrega()->create($entregaData);
                }
            }

            if($request->has('devolucion')){
                $devolucionData = $request->input('devolucion');
                if ($renta->devolucion) {
                    $renta->devolucion()->update($devolucionData);
                } else {
                    $renta->devolucion()->create($devolucionData);
                }
            }
            $renta->save();
            $data = [
                'message' => 'renta actualizada',
                'renta' => $renta,
                'status' => 200
            ];
            return response()->json($data, 200);
        } catch (\Exception $e) {
                Log::error('Error al actualizar Renta: ' . $e->getMessage());
                return response()->json([
                    'error' => $e->getMessage(),
                    'status' => 500
                ], 500);
            }
    }
    public function updatePartial(Request $request, $id)
    {
        try {
            $renta = Renta::with('cliente', 'cotizacion')->find($id);
            if (!$renta){
                $data = [
                    'message' => 'Renta no encontrada',
                    'status' => 404
                ];
                return response()->json($data, 404);
            }
            $validator = Validator::make($request->all(), [
                'cliente_id' => [Rule::exists('cliente', 'id')],
                'cotizacion_id' => [Rule::exists('cotizacion', 'id')],
                'fecha_inicio'=> ['date'],
                'fecha_fin_prevista' => ['date'],
                'fecha_devolucion_real' => ['date'],
                'estado_renta' => ['string', Rule::in(['Programada','EnCurso','Finalizada','Retrasada','Cancelada'])],
                'monto_total_renta' => ['numeric'],
                'deposito_garantia' => ['numeric'],
                'notas'=> ['string']
            ]);
            if ($validator->fails()){
                $data = [
                    'message' => 'Validation failed',
                    'errors' => $validator->errors(),
                    'status' => 422
                ];
                return response()->json($data, 422);
            }
            if($request->has('cliente_id')){
                $renta->cliente_id = $request->cliente_id;
            }
            if($request->has('cotizacion_id')){
                $renta->cotizacion_id = $request->cotizacion_id;
            }
            if($request->has('fecha_inicio')){
                $renta->fecha_inicio = $request->fecha_inicio;
            }
            if($request->has('fecha_fin_prevista')){
                $renta->fecha_fin_prevista = $request->fecha_fin_prevista;
            }
            if($request->has('fecha_devolucion_real')){
                $renta->fecha_devolucion_real = $request->fecha_devolucion_real;
            }
            if($request->has('estado_renta')){
                $renta->estado_renta = $request->estado_renta;
            }
            if($request->has('monto_total_renta')){
                $renta->monto_total_renta = $request->monto_total_renta;
            }
            if($request->has('deposito_garantia')){
                $renta->deposito_garantia = $request->deposito_garantia;
            }
            if($request->has('notas')){
                $renta->notas = $request->notas;
            }
            $renta->save();
            $renta->load('cliente', 'cotizacion');
            $data = [
                'message' => 'renta actualizado',
                'renta' => $renta,
                'status' => 200
            ];
            return response()->json($data, 200);
        } catch (\Exception $e) {
                Log::error('Error al actualizar Renta: ' . $e->getMessage());
                return response()->json([
                    'error' => $e->getMessage(),
                    'status' => 500
                ], 500);
            }
    }
}
