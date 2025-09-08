<?php

namespace App\Http\Controllers\api;

use App\Http\Controllers\Controller;
use App\Models\Entrega;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class entregaController extends Controller
{
        public function index(){
        $entrega = Entrega::all();
        $data = [
            'entrega' => $entrega,
            'status' => 200
        ];
        return response()->json($data, 200);
        }
        public function store(Request $request){
            $validator = Validator::make($request->all(),[
                'renta_id' => 'required',
                'direccion_id' => 'required',
                'fecha_envio' => 'required',
                'compania_envio' => 'required',
                'numero_guia' => 'required',
                'estado_entrega' => 'required',
                'notas' => 'required',
            ]);
            if($validator->fails()){
                $data = [
                    'message' => 'Validation failed',
                    'errors' => $validator->errors(),
                    'status' => 400
                ];
                return response()->json($data, 400);
            }
            $entrega = Entrega::create([
                'renta_id' => $request->renta_id,
                'direccion_id' => $request->direccion_id,
                'fecha_envio' => $request->fecha_envio,
                'compania_envio' => $request->compania_envio,
                'numero_guia' => $request->numero_guia,
                'estado_entrega' => $request->estado_entrega,
                'notas' => $request->notas,
            ]);
            if(!$entrega){
                $data = [
                    'message' => 'Error al crear entrega',
                    'status' => 500
                ];
                return response()->json($data, 500);
            }
            $data = [
                'entrega' => $entrega,
                'status' => 200
            ];
            return response()->json($data, 200);
        }
        public function show($id){
            $entrega = Entrega::find($id);
            if(!$entrega){
                $data = [
                    'message' => 'Entrega no encontrada',
                    'status' => 404
                ];
                return response()->json($data, 404);
            }
            $data = [
                'entrega' => $entrega,
                'status' => 200
            ];
            return response()->json($data, 200);
        }
        public function destroy($id){
            $entrega = Entrega::find($id);
            if(!$entrega){
                $data = [
                    'message' => 'Entrega no encontrada',
                    'status' => 404
                ];
                return response()->json($data, 404);
            }
            $entrega->delete();
            $data = [
                'entrega' => $entrega,
                'status' => 200
            ];
            return response()->json($data, 200);
        }
        public function update(Request $request, $id){
            $entrega = Entrega::find($id);
            if(!$entrega){
                $data = [
                    'message' => 'Entrega no encontrada',
                    'status' => 404
                ];
                return response()->json($data, 404);
            }
            $validator = Validator::make($request->all(), [
                'renta_id' => 'required',
                'direccion_id' => 'required',
                'fecha_envio' => 'required',
                'compania_envio' => 'required',
                'numero_guia' => 'required',
                'estado_entrega' => 'required',
                'notas' => 'required',
            ]);
            if($validator->fails()){
                $data = [
                    'message' => 'Validator failed',
                    'errors' => $validator->errors(),
                    'status' => 400
                ];
                return response()->json($data, 400);
            }
            $entrega->renta_id = $request->renta_id;
            $entrega->direccion_id = $request->direccion_id;
            $entrega->fecha_envio = $request->fecha_envio;
            $entrega->compania_envio = $request->compania_envio;
            $entrega->numero_guia = $request->numero_guia;
            $entrega->estado_entrega = $request->estado_entrega;
            $entrega->notas = $request->notas;
            $entrega->save();
            $data = [
                'message' => 'entrega actualizado',
                'entrega' => $entrega,
                'status' => 200
            ];
            return response()->json($data, 200);
        }
        public function updatePartial(Request $request, $id){
            $entrega = Entrega::find($id);
            if(!$entrega){
                $data = [
                    'message' => 'entrega no encontrada',
                    'status' => 404
                ];
                return response()->json($data, 404);
            }
            $validator = Validator::make($request->all(),[
                'renta_id' => 'string',
                'direccion_id' => 'string',
                'fecha_envio' => 'string',
                'compania_envio' => 'string',
                'numero_guia' => 'string',
                'estado_entrega' => 'string',
                'notas' => 'string'
            ]);
            
            if($validator->fails()){
                $data = [
                    'message' => 'Error en la Validacion',
                    'errors' => $validator->errors(),
                    'status' => 400
                ];
                return response()->json($data, 400);
            }
            
            if($request->has('renta_id')){
                $entrega->renta_id = $request->renta_id;
            }
            if($request->has('direccion_id')){
                $entrega->direccion_id = $request->direccion_id;
            }
            if($request->has('fecha_envio')){
                $entrega->fecha_envio = $request->fecha_envio;
            }
            if($request->has('compania_envio')){
                $entrega->compania_envio = $request->compania_envio;
            }
            if($request->has('numero_guia')){
                $entrega->numero_guia = $request->numero_guia;
            }
            if($request->has('estado_entrega')){
                $entrega->estado_entrega = $request->estado_entrega;
            }
            if($request->has('notas')){
                $entrega->notas = $request->notas;
            }
            $entrega->save();
            $data = [
                'message' => 'entrega actualizado',
                'entrega' => $entrega,
                'status' => 200
            ];
            return response()->json($data, 200);
        }
    }
