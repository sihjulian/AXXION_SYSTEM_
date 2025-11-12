<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreUsuarioRequest extends FormRequest
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
        return [
            'nombre_usuario' => 'required|string|max:100|unique:usuario,nombre_usuario',
            'password' => 'required|string|min:8',
            'nombre_completo' => 'nullable|string|max:200',
            'email' => 'required|email|max:100|unique:usuario,email',
            'telefono' => 'nullable|string|max:20',
            'departamento' => 'nullable|string|max:100',
            'estado' => 'nullable|in:Activo,Inactivo,Bloqueado',
            'roles' => 'nullable|array',
            'roles.*' => 'integer|exists:rol,id',
        ];
    }
}
