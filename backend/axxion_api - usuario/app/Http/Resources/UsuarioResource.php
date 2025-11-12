<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UsuarioResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'nombre_usuario' => $this->nombre_usuario,
            'nombre' => $this->nombre,
            'nombre2' => $this->nombre2,
            'apellido1' => $this->apellido1,
            'apellido2' => $this->apellido2,
            'email' => $this->email,
            'telefono' => $this->telefono,
            'departamento' => $this->departamento,
            'estado' => $this->estado,
            'roles' => $this->whenLoaded('roles', function () {
                return $this->roles->map(fn($r) => [
                    'id' => $r->id,
                    'codigo' => $r->codigo,
                    'nombre' => $r->nombre,
                ]);
            }),
            'created_at' => optional($this->created_at)->toISOString(),
            'updated_at' => optional($this->updated_at)->toISOString(),
        ];
    }
}
