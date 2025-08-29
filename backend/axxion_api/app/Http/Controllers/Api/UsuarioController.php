<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreUsuarioRequest;
use App\Http\Requests\UpdateUsuarioRequest;
use App\Http\Resources\UsuarioResource;
use App\Models\Usuario;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
class UsuarioController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $usuarios = Usuario::all();
        return UsuarioResource::collection($usuarios);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validator = Validator :: make($request->all(), [
            'nombre_usuario' => 'required',
            'nombre' => 'required',
            'nombre2' => 'required',
            'apellido1' => 'required',
            'apellido2' => 'required',
            'password' => 'required',
            'email' => 'required|email',
            'telefono' => 'required',
            'departamento' => 'required',
            'estado' => 'required',
            'roles' => 'required'
            ]);
            
            if ($validator->fails()) {
            $data = [
            'message' => 'Error en la validacion de los datos',
            'errors' => $validator->errors(),
            'status' => 400
            ];

            return response()->json($data, 400);    
        }

    $usuario = Usuario::create([
        'nombre_usuario' => $request->nombre_usuario,
        'nombre' => $request->nombre,
        'nombre2' => $request->nombre2,
        'apellido1' => $request->apellido1,
        'apellido2' => $request->apellido2,
        'password_hash' => Hash::make($request->password),
        'email' => $request->email,
        'telefono' => $request->telefono,
        'departamento' => $request->departamento,
    ]);
        
        if ($request->has('roles')) {
            $usuario->roles()->sync($request->roles);
        }


        return response()->json([
            'message' => 'Usuario creado correctamente',
            'data' => $usuario
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $usuario = Usuario::with('roles')->findOrFail($id);
        return new UsuarioResource($usuario);
    }

    /**
     * Update the specified resource in storage.

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $usuario = Usuario::findOrFail($id);
        $usuario->roles()->detach();
        $usuario->delete();
        return response()->json(status: 204);
    }
}
