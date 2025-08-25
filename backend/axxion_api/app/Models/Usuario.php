<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Usuario extends Model
{
    protected $table = 'usuario';

    protected $fillable = [
        'nombre_usuario',
        'password_hash',
        'nombre_completo',
        'email',
        'telefono',
        'departamento',
        'estado',
    ];

    protected $hidden = [
        'password_hash',
    ];

    public function roles(): BelongsToMany
    {
        return $this->belongsToMany(Rol::class, 'usuario_rol', 'usuario_id', 'rol_id');
    }
}
