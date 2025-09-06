<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Categoria;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class categoriaController extends Controller
    {
        public function index(){
        $categoria = Categoria::all();
        $data = [
            'categoria' => $categoria,
            'status' => 200
        ];
        return response()->json($data, 200);
        }
        public function store(Request $request){
            $validator = Validator::make($request->all(),[
                'nombre' => 'required',
                'descripcion' => 'required',
                'tipo_categoria' => 'required'
            ]);
            if($validator->fails()){
                $data = [
                    'message' => 'Validation failed',
                    'errors' => $validator->errors(),
                    'status' => 400
                ];
                return response()->json($data, 400);
            }
            $categoria = Categoria::create([
                'nombre' => $request->nombre,
                'descripcion' => $request->descripcion,
                'tipo_categoria' => $request->tipo_categoria
            ]);
            if(!$categoria){
                $data = [
                    'message' => 'Error al crear categoria',
                    'status' => 500
                ];
                return response()->json($data, 500);
            }
            $data = [
                'categoria' => $categoria,
                'status' => 200
            ];
            return response()->json($data, 200);
        }
        public function show($id){
            $categoria = Categoria::find($id);
            if(!$categoria){
                $data = [
                    'message' => 'Categoria no encontrada',
                    'status' => 404
                ];
                return response()->json($data, 404);
            }
            $data = [
                'categoria' => $categoria,
                'status' => 200
            ];
            return response()->json($data, 200);
        }
        public function destroy($id){
            $categoria = Categoria::find($id);
            if(!$categoria){
                $data = [
                    'message' => 'Categoria no encontrada',
                    'status' => 404
                ];
                return response()->json($data, 404);
            }
            $categoria->delete();
            $data = [
                'categoria' => $categoria,
                'status' => 200
            ];
            return response()->json($data, 200);
        }
        public function update(Request $request, $id){
            $categoria = Categoria::find($id);
            if(!$categoria){
                $data = [
                    'message' => 'categoria no encontrada',
                    'status' => 200
                ];
                return response()->json($data, 200);
            }
            $validator = Validator::make($request->all(), [
                'nombre' => 'required',
                'descripcion' => 'required',
                'tipo_categoria' => 'required',
            ]);
            if($validator->fails()){
                $data = [
                    'message' => 'Validator failed',
                    'errors' => $validator->errors(),
                    'status' => 400
                ];
                return response()->json($data, 400);
            }
            $categoria->nombre = $request->nombre;
            $categoria->descripcion = $request->descripcion;
            $categoria->tipo_categoria = $request->tipo_categoria;
            $categoria->save();
            $data = [
                'message' => 'categoria actualizada',
                'categoria' => $categoria,
                'status' => 200
            ];
            return response()->json($data, 200);
        }
        public function updatePartial(Request $request, $id){
            $categoria = Categoria::find($id);
            if(!$categoria){
                $data = [
                    'message' => 'categoria no encontrado',
                    'status' => 404
                ];
                return response()->json($data, 404);
            }
            $validator = Validator::make($request->all(),[
                'nombre' => 'string',
                'descripcion' => 'string',
                'tipo_categoria' => 'string'
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
                $categoria->nombre = $request->nombre;
            }
            if($request->has('descripcion')){
                $categoria->descripcion = $request->descripcion;
            }
            if($request->has('tipo_categoria')){
                $categoria->tipo_categoria = $request->tipo_categoria;
            }
            $categoria->save();
            $data = [
                'message' => 'categoria actualizado',
                'categoria' => $categoria,
                'status' => 200
            ];
            return response()->json($data, 200);
        }
    }
