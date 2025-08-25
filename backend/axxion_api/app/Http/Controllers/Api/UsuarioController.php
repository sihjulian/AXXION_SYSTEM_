<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreUsuarioRequest;
use App\Http\Requests\UpdateUsuarioRequest;
use App\Http\Resources\UsuarioResource;
use App\Models\Usuario;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class UsuarioController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Usuario::query()->with('roles');

        if ($search = $request->string('q')) {
            $query->where(function ($q) use ($search) {
                $q->where('nombre_usuario', 'like', "%{$search}%")
                  ->orWhere('nombre_completo', 'like', "%{$search}%")
                  ->orWhere('email', 'like', "%{$search}%");
            });
        }

        if ($estado = $request->string('estado')) {
            $query->where('estado', $estado);
        }

        $usuarios = $query->paginate($request->integer('per_page', 15));

        return UsuarioResource::collection($usuarios);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreUsuarioRequest $request)
    {
        $data = $request->validated();

        $usuario = new Usuario();
        $usuario->nombre_usuario = $data['nombre_usuario'];
        $usuario->password_hash = Hash::make($data['password']);
        $usuario->nombre_completo = $data['nombre_completo'] ?? null;
        $usuario->email = $data['email'];
        $usuario->telefono = $data['telefono'] ?? null;
        $usuario->departamento = $data['departamento'] ?? null;
        $usuario->estado = $data['estado'] ?? 'Activo';
        $usuario->save();

        if (!empty($data['roles'])) {
            $usuario->roles()->sync($data['roles']);
        }

        return (new UsuarioResource($usuario->load('roles')))
            ->response()
            ->setStatusCode(201);
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
     */
    public function update(UpdateUsuarioRequest $request, string $id)
    {
        $usuario = Usuario::findOrFail($id);
        $data = $request->validated();

        if (array_key_exists('nombre_usuario', $data)) {
            $usuario->nombre_usuario = $data['nombre_usuario'];
        }
        if (array_key_exists('password', $data)) {
            $usuario->password_hash = Hash::make($data['password']);
        }
        if (array_key_exists('nombre_completo', $data)) {
            $usuario->nombre_completo = $data['nombre_completo'];
        }
        if (array_key_exists('email', $data)) {
            $usuario->email = $data['email'];
        }
        if (array_key_exists('telefono', $data)) {
            $usuario->telefono = $data['telefono'];
        }
        if (array_key_exists('departamento', $data)) {
            $usuario->departamento = $data['departamento'];
        }
        if (array_key_exists('estado', $data)) {
            $usuario->estado = $data['estado'];
        }

        $usuario->save();

        if (array_key_exists('roles', $data)) {
            $usuario->roles()->sync($data['roles'] ?? []);
        }

        return new UsuarioResource($usuario->load('roles'));
    }

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
