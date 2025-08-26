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
    public function index()
    {
        $usuarios = Usuario::all();
        return UsuarioResource::collection($usuarios);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreUsuarioRequest $request)
    {
        $data = $request->validated();
        $data['password_hash'] = Hash::make($data['password']);

        $roles = $data['roles'] ?? [];
        unset($data['roles'], $data['password']);

        $usuario = Usuario::create($data);

        if (!empty($roles)) {
            $usuario->roles()->sync($roles);
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

        if (isset($data['password'])) {
            $usuario->password_hash = Hash::make($data['password']);
            unset($data['password']);
        }

        if (array_key_exists('roles', $data)) {
            $usuario->roles()->sync($data['roles'] ?? []);
            unset($data['roles']);
        }

        $usuario->update($data);

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
