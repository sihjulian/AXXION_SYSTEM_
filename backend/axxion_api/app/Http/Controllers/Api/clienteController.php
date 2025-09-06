<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Cliente;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class clienteController extends Controller
    {
        public function index(){
        $cliente = Cliente::all();
        $data = [
            'cliente' => $cliente,
            'status' => 200
        ];
        return response()->json($data, 200);
        }
        public function store(Request $request){
            $validator = Validator::make($request->all(),[
                'nombre' => 'required',
                'nombre2' => 'required',
                'apellido1' => 'required',
                'apellido2' => 'required',
                'rfc' => 'required',
                'telefono_principal' => 'required',
                'correo_electronico' => 'required',
                'tipo_cliente' => 'required',
                'estado_cliente' => 'required'
            ]);
            if($validator->fails()){
                $data = [
                    'message' => 'Validation failed',
                    'errors' => $validator->errors(),
                    'status' => 400
                ];
                return response()->json($data, 400);
            }
            $cliente = Cliente::create([
                'nombre' => $request->nombre,
                'nombre2' => $request->nombre2,
                'apellido1' => $request->apellido1,
                'apellido2' => $request->apellido2,
                'rfc' => $request->rfc,
                'telefono_principal' => $request->telefono_principal,
                'correo_electronico' => $request->correo_electronico,
                'tipo_cliente' => $request->tipo_cliente,
                'estado_cliente' => $request->estado_cliente
            ]);
            if(!$cliente){
                $data = [
                    'message' => 'Error al crear cliente',
                    'status' => 500
                ];
                return response()->json($data, 500);
            }
            $data = [
                'cliente' => $cliente,
                'status' => 200
            ];
            return response()->json($data, 200);
        }
        public function show($id){
            $cliente = Cliente::find($id);
            if(!$cliente){
                $data = [
                    'message' => 'Cliente no encontrado',
                    'status' => 404
                ];
                return response()->json($data, 404);
            }
            $data = [
                'cliente' => $cliente,
                'status' => 200
            ];
            return response()->json($data, 200);
        }
        public function destroy($id){
            $cliente = Cliente::find($id);
            if(!$cliente){
                $data = [
                    'message' => 'Cliente no encontrado',
                    'status' => 404
                ];
                return response()->json($data, 404);
            }
            $cliente->delete();
            $data = [
                'cliente' => $cliente,
                'status' => 200
            ];
            return response()->json($data, 200);
        }
        public function update(Request $request, $id){
            $cliente = Cliente::find($id);
            if(!$cliente){
                $data = [
                    'message' => 'Cliente no encontrado',
                    'status' => 404
                ];
                return response()->json($data, 404);
            }
            $validator = Validator::make($request->all(), [
                'nombre' => 'required',
                'nombre2' => 'required',
                'apellido1' => 'required',
                'apellido2' => 'required',
                'rfc' => 'required',
                'telefono_principal' => 'required',
                'correo_electronico' => 'required',
                'tipo_cliente' => 'required',
                'estado_cliente' => 'required',
            ]);
            if($validator->fails()){
                $data = [
                    'message' => 'Validator failed',
                    'errors' => $validator->errors(),
                    'status' => 400
                ];
                return response()->json($data, 400);
            }
            $cliente->nombre = $request->nombre;
            $cliente->nombre2 = $request->nombre2;
            $cliente->apellido1 = $request->apellido1;
            $cliente->apellido2 = $request->apellido2;
            $cliente->rfc = $request->rfc;
            $cliente->telefono_principal = $request->telefono_principal;
            $cliente->correo_electronico = $request->correo_electronico;
            $cliente->tipo_cliente = $request->tipo_cliente;
            $cliente->estado_cliente = $request->estado_cliente;
            $cliente->save();
            $data = [
                'message' => 'cliente actualizado',
                'cliente' => $cliente,
                'status' => 200
            ];
            return response()->json($data, 200);
        }
        public function updatePartial(Request $request, $id){
            $cliente = Cliente::find($id);
            if(!$cliente){
                $data = [
                    'message' => 'cliente no encontrado',
                    'status' => 404
                ];
                return response()->json($data, 404);
            }
            $validator = Validator::make($request->all(),[
                'nombre' => 'string',
                'nombre2' => 'string',
                'apellido1' => 'string',
                'apellido2' => 'string',
                'rfc' => 'string',
                'telefono_principal' => 'string',
                'correo_electronico' => 'string',
                'tipo_cliente' => 'string',
                'estado_cliente' => 'string'
            ]);
            
            if($validator->fails()){
                $data = [
                    'message' => 'Error en la Validacion',
                    'errors' => $validator->errors(),
                    'status' => 400
                ];
                return response()->json($data, 400);
            }
            
            if($request->has('nombre')){
                $cliente->nombre = $request->nombre;
            }
            if($request->has('nombre2')){
                $cliente->nombre2 = $request->nombre2;
            }
            if($request->has('apellido1')){
                $cliente->apellido1 = $request->apellido1;
            }
            if($request->has('apellido2')){
                $cliente->apellido2 = $request->apellido2;
            }
            if($request->has('rfc')){
                $cliente->rfc = $request->rfc;
            }
            if($request->has('telefono_principal')){
                $cliente->telefono_principal = $request->telefono_principal;
            }
            if($request->has('correo_electronico')){
                $cliente->correo_electronico = $request->correo_electronico;
            }
            if($request->has('tipo_cliente')){
                $cliente->tipo_cliente = $request->tipo_cliente;
            }
            if($request->has('estado_cliente')){
                $cliente->estado_cliente = $request->estado_cliente;
            }
            $cliente->save();
            $data = [
                'message' => 'cliente actualizado',
                'cliente' => $cliente,
                'status' => 200
            ];
            return response()->json($data, 200);
        }
    }
