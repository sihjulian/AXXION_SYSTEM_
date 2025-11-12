<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateUsuarioRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        $usuarioId = $this->route('usuario');

        return [
            'nombre_usuario' => 'sometimes|string|max:100|unique:usuario,nombre_usuario,' . $usuarioId,
            'password' => 'sometimes|string|min:8',
            'nombre_completo' => 'sometimes|nullable|string|max:200',
            'email' => 'sometimes|email|max:100|unique:usuario,email,' . $usuarioId,
            'telefono' => 'sometimes|nullable|string|max:20',
            'departamento' => 'sometimes|nullable|string|max:100',
            'estado' => 'sometimes|in:Activo,Inactivo,Bloqueado',
            'roles' => 'sometimes|array',
            'roles.*' => 'integer|exists:rol,id',
        ];
    }
}
