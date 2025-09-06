<?php

namespace App\Http\Controllers\api;

use App\Http\Controllers\Controller;
use App\Models\Cotizacion;
use App\Models\DetalleCotizacion;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class detalleCotizacionController extends Controller
{
        public function index(){
        $detalleCotizacion = DetalleCotizacion::all();
        $data = [
            'detalleCotizacion' => $detalleCotizacion,
            'status' => 200
        ];
        return response()->json($data, 200);
        }
        public function store(Request $request){
            $validator = Validator::make($request->all(),[
                'cotizacion_id' => ['required', Rule::exists('cotizacion','id')],
                'producto_id' => ['required', Rule::exists('producto','id')],
                'descripcion_item' => ['required', 'string'],
                'cantidad' => ['required', 'numeric'],
                'precio_unitario' => ['required', 'numeric'],
                'descuento_porcentaje' => ['required', 'numeric'],
                'impuestos_aplicables' => ['required', 'numeric'],
                'notas' => ['required', 'string'],
            ]);
            if($validator->fails()){
                $data = [
                    'message' => 'Validation failed',
                    'errors' => $validator->errors(),
                    'status' => 400
                ];
                return response()->json($data, 400);
            }
            $detalleCotizacion = DetalleCotizacion::create([
                'cotizacion_id' => $request->cotizacion_id,
                'producto_id' => $request->producto_id,
                'descripcion_item' => $request->descripcion_item,
                'cantidad' => $request->cantidad,
                'precio_unitario' => $request->precio_unitario,
                'descuento_porcentaje' => $request->descuento_porcentaje,
                'impuestos_aplicables' => $request->impuestos_aplicables,
                'notas' => $request->notas,
            ]);
            if(!$detalleCotizacion){
                $data = [
                    'message' => 'Error al crear detalle de cotizacion',
                    'status' => 500
                ];
                return response()->json($data, 500);
            }
            $detalleCotizacion->load(['cotizacion', 'producto']);
            $data = [
                'detalleCotizacion' => $detalleCotizacion,
                'status' => 200
            ];
            return response()->json($data, 200);
        }
        public function show($id){
            $detalleCotizacion = DetalleCotizacion::find($id);
            if(!$detalleCotizacion){
                $data = [
                    'message' => 'Detalle de cotizacion no encontrado',
                    'status' => 404
                ];
                return response()->json($data, 404);
            }
            $data = [
                'detalleCotizacion' => $detalleCotizacion,
                'status' => 200
            ];
            return response()->json($data, 200);
        }
        public function destroy($id){
            $detalleCotizacion = DetalleCotizacion::find($id);
            if(!$detalleCotizacion){
                $data = [
                    'message' => 'Detalle de cotizacion no encontrado',
                    'status' => 404
                ];
                return response()->json($data, 404);
            }
            $detalleCotizacion->delete();
            $data = [
                'detalleCotizacion' => $detalleCotizacion,
                'status' => 200
            ];
            return response()->json($data, 200);
        }
        public function update(Request $request, $id){
            $detalleCotizacion = DetalleCotizacion::find($id);
            if(!$detalleCotizacion){
                $data = [
                    'message' => 'Detalle de cotizacion no encontrado',
                    'status' => 404
                ];
                return response()->json($data, 404);
            }
            $validator = Validator::make($request->all(), [
                'cotizacion_id' => ['required', Rule::exists('cotizaciones','id')],
                'producto_id' => ['required', Rule::exists('productos','id')],
                'descripcion_item' => ['required', 'string', 'max:255'],
                'cantidad' => ['required', 'integer', 'min:1'],
                'precio_unitario' => ['required', 'numeric', 'min:0'],
                'descuento_porcentaje' => ['required', 'numeric', 'min:0', 'max:100'],
                'impuestos_aplicables' => ['required', 'numeric'],
                'notas' => ['required', 'string', 'max:255'],
            ]);
            if($validator->fails()){
                $data = [
                    'message' => 'Validator failed',
                    'errors' => $validator->errors(),
                    'status' => 400
                ];
                return response()->json($data, 400);
            }
            $detalleCotizacion->cotizacion_id = $request->cotizacion_id;
            $detalleCotizacion->producto_id = $request->producto_id;
            $detalleCotizacion->descripcion_item = $request->descripcion_item;
            $detalleCotizacion->cantidad = $request->cantidad;
            $detalleCotizacion->precio_unitario = $request->precio_unitario;
            $detalleCotizacion->descuento_porcentaje = $request->descuento_porcentaje;
            $detalleCotizacion->impuestos_aplicables = $request->impuestos_aplicables;
            $detalleCotizacion->notas = $request->notas;
            $detalleCotizacion->save();
            $detalleCotizacion->load(['cotizacion', 'producto']);
            $data = [
                'message' => 'detalle de cotizacion actualizado',
                'detalleCotizacion' => $detalleCotizacion,
                'status' => 200
            ];
            return response()->json($data, 200);
        }
        public function updatePartial(Request $request, $id){
            $detalleCotizacion = DetalleCotizacion::find($id);
            if(!$detalleCotizacion){
                $data = [
                    'message' => 'detalle de cotizacion no encontrado',
                    'status' => 404
                ];
                return response()->json($data, 404);
            }
            $validator = Validator::make($request->all(),[
                'cotizacion_id' => 'integer|exists:cotizaciones,id',
                'producto_id' => 'integer|exists:productos,id',
                'descripcion_item' => 'string|max:255',
                'cantidad' => 'integer|min:1',
                'precio_unitario' => 'numeric|min:0',
                'descuento_porcentaje' => 'numeric|min:0|max:100',
                'impuestos_aplicables' => 'string',
                'notas' => 'string|max:255',
            ]);
            if($validator->fails()){
                $data = [
                    'message' => 'Error en la Validacion',
                    'errors' => $validator->errors(),
                    'status' => 400
                ];
                return response()->json($data, 400);
            }
            if($request->has('cotizacion_id')){
                $detalleCotizacion->cotizacion_id = $request->cotizacion_id;
            }
            if($request->has('producto_id')){
                $detalleCotizacion->producto_id = $request->producto_id;
            }
            if($request->has('descripcion_item')){
                $detalleCotizacion->descripcion_item = $request->descripcion_item;
            }
            if($request->has('cantidad')){
                $detalleCotizacion->cantidad = $request->cantidad;
            }
            if($request->has('precio_unitario')){
                $detalleCotizacion->precio_unitario = $request->precio_unitario;
            }
            if($request->has('descuento_porcentaje')){
                $detalleCotizacion->descuento_porcentaje = $request->descuento_porcentaje;
            }
            if($request->has('impuestos_aplicables')){
                $detalleCotizacion->impuestos_aplicables = $request->impuestos_aplicables;
            }
            if($request->has('notas')){
                $detalleCotizacion->notas = $request->notas;
            }
            $detalleCotizacion->save();
            $data = [
                'message' => 'detalle de cotizacion actualizado',
                'detalleCotizacion' => $detalleCotizacion,
                'status' => 200
            ];
            return response()->json($data, 200);
        }
}
