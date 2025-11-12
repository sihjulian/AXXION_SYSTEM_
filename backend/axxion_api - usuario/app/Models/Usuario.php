<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Tymon\JWTAuth\Contracts\JWTSubject;



class Usuario extends Authenticatable implements JWTSubject
{
    use HasFactory;

    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    public function getJWTCustomClaims()
    {
        return [
            'email' => $this->email,
            'roles' => $this->roles()->pluck('codigo')->toArray()
        ];
    }
 
    protected $table = 'usuario';

    protected $fillable = [
        'id',
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
