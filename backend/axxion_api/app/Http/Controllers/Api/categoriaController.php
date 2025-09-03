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
        }
    }
