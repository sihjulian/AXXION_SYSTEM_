<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;

class Usuario extends Model

{ 
    use HasFactory;
  
    protected $table = 'usuario';

    protected $fillable = [
        'nombre_usuario',
        'nombre',
        'nombre2',
        'apellido1',
        'apellido2',
        'password_hash',
        'email',
        'telefono',
        'departamento',
        'estado',
    ];

    protected $hidden = [
        'password_hash',
    ];

    protected $casts = [
        'estado' => 'string',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    public function getAuthPassword()
    {
        return $this->password_hash;
    }

    public function roles()
    {
        return $this->belongsToMany(Rol::class, 'usuario_rol');
    }
}
